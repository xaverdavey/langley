import data

import copy
import os
import subprocess
from dataclasses import dataclass, field
from typing import Optional, Dict, Sequence
import torch
import torch.distributed
import transformers
from datasets import Dataset

########## DeepSeek Utils Begin ##########

def build_instruction_prompt(instruction: str):
    return '''
You are an AI programming assistant, utilizing the DeepSeek Coder model, developed by DeepSeek Company, and you only answer questions related to computer science. For politically sensitive questions, security and privacy issues, and other non-computer science questions, you will refuse to answer.
### Instruction:
{}
### Response:
'''.format(instruction.strip()).lstrip()

def _tokenize_fn(strings: Sequence[str], tokenizer: transformers.PreTrainedTokenizer) -> Dict:
    """Tokenize a list of strings."""
    tokenized_list = [
        tokenizer(
            text,
            return_tensors="pt",
            padding="longest",
            max_length=tokenizer.model_max_length,
            truncation=True,
        )
        for text in strings
    ]
    input_ids = [tokenized.input_ids[0] for tokenized in tokenized_list]
    input_ids = torch.nn.utils.rnn.pad_sequence(input_ids, batch_first=True, padding_value=tokenizer.pad_token_id)
    labels = [tokenized.input_ids[0] for tokenized in tokenized_list]
    labels = torch.nn.utils.rnn.pad_sequence(labels, batch_first=True, padding_value=data.IGNORE_INDEX)
    input_ids_lens = labels_lens = [
        tokenized.input_ids.ne(tokenizer.pad_token_id).sum().item() for tokenized in tokenized_list
    ]
    return dict(
        input_ids=input_ids,
        labels=labels,
        input_ids_lens=input_ids_lens,
        labels_lens=labels_lens,
    )

def preprocess(
    sources: Sequence[str],
    targets: Sequence[str],
    tokenizer: transformers.PreTrainedTokenizer,
) -> Dict:
    """Preprocess the data by tokenizing."""
    examples = [s + t for s, t in zip(sources, targets)]
    examples_tokenized, sources_tokenized = [_tokenize_fn(strings, tokenizer) for strings in (examples, sources)]
    input_ids = examples_tokenized["input_ids"]

    labels = copy.deepcopy(input_ids)
    for label, source_len in zip(labels, sources_tokenized["input_ids_lens"]):
        label[:source_len] = data.IGNORE_INDEX
    return dict(input_ids=input_ids, labels=labels)

def train_tokenize_function(examples, tokenizer):
    sources = [
        build_instruction_prompt(instruction)
        for instruction in examples['instruction']
    ]
    targets = [f"{output}\n{tokenizer.eos_token_id}" for output in examples['output']]
    data_dict = preprocess(sources, targets, tokenizer)
    return data_dict

@dataclass
class DataCollatorForSupervisedDataset(object):
    """Collate examples for supervised fine-tuning."""
    tokenizer: transformers.PreTrainedTokenizer

    def __call__(self, instances: Sequence[Dict]) -> Dict[str, torch.Tensor]:
        input_ids, labels = tuple([instance[key] for instance in instances] for key in ("input_ids", "labels"))
        input_ids = [torch.tensor(x) for x in input_ids]
        input_ids = torch.nn.utils.rnn.pad_sequence(
            input_ids, batch_first=True, padding_value=self.tokenizer.pad_token_id
        )
        labels = [torch.tensor(x) for x in labels]
        labels = torch.nn.utils.rnn.pad_sequence(labels, batch_first=True, padding_value=data.IGNORE_INDEX)
        
        return dict(
            input_ids=input_ids,
            labels=labels,
            attention_mask=input_ids.ne(self.tokenizer.pad_token_id),
        )
    
def safe_save_model_for_hf_trainer(trainer: transformers.Trainer, output_dir: str):
    """Collects the state dict and dump to disk."""
    state_dict = trainer.model.state_dict()
    if trainer.args.should_save:
        cpu_state_dict = {key: value.cpu() for key, value in state_dict.items()}
        del state_dict
        trainer._save(output_dir, state_dict=cpu_state_dict)

########## DeepSeek Utils End ##########

def print_params(mod, num_layers=1):
    params = [x for x in mod.parameters()]
    print("Number of Layers: " + str(len(params)))
    for i in range(len(params)):
        print(params[i])
        if i >= num_layers:
            break

def get_training_objects():
    # load the tokenizer
    tokenizer = transformers.AutoTokenizer.from_pretrained(
        data.MODEL_NAME,
        use_fast=True,
        trust_remote_code=True
    )
    # load the model
    model = transformers.AutoModelForCausalLM.from_pretrained(
        data.MODEL_NAME,
        torch_dtype=torch.bfloat16,
    )
    # load the data
    ly_data = {
        'instruction': [],
        'output': [],
    }
    for ly_file in os.listdir(data.LY_EXAMPLES_PATH):
        assert ly_file in data.EXAMPLE_MAPPING
        prompt = data.EXAMPLE_MAPPING[ly_file]
        file_path = os.path.join(data.LY_EXAMPLES_PATH, ly_file)
        all_content = open(file_path).read()
        clean_content = '```langely' + '*/'.join(all_content.split('*/')[1:]).replace('\n', '', 1) + '\n```'
        ly_data['instruction'].append(prompt)
        ly_data['output'].append(clean_content)
    raw_train_datasets = Dataset.from_dict(ly_data)
    print(raw_train_datasets)
    train_dataset = raw_train_datasets.map(
        train_tokenize_function,
        batched=True,
        batch_size=1,
        num_proc=1,
        remove_columns=raw_train_datasets.column_names,
        load_from_cache_file=True,
        fn_kwargs={ "tokenizer": tokenizer },
    )
    data_collator = DataCollatorForSupervisedDataset(tokenizer=tokenizer)
    data_module = dict(train_dataset=train_dataset, eval_dataset=None, data_collator=data_collator)
    # return training objects
    return tokenizer, model, data_module

def langely_pipeline(tokenizer, model, input_content):
    messages=[
        { 'role': 'user', 'content': input_content}
    ]
    inputs = tokenizer.apply_chat_template(messages, add_generation_prompt=True, return_tensors="pt").to(model.device)
    outputs = model.generate(inputs, max_new_tokens=512, do_sample=False, top_k=50, top_p=0.95, num_return_sequences=1, eos_token_id=tokenizer.eos_token_id)
    decoded_outputs = tokenizer.decode(outputs[0][len(inputs[0]):], skip_special_tokens=True)
    is_valid = "```langely" in decoded_outputs
    if not is_valid:
        return is_valid, decoded_outputs, None, None
    code_block = decoded_outputs.split("```langely")[1].split('```')[0]
    proc = subprocess.Popen([data.LY_EXEC_PATH], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate(bytes(code_block, "utf-8"))
    interpreter_result = '\n'.join([stdout.decode(), stderr.decode()])
    return is_valid, decoded_outputs, code_block, interpreter_result

def make_ly_prompt(input_content):
    return data.FEW_SHOT_PREFIX + input_content
