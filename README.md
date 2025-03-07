```

      ___       ___           ___           ___           ___           ___       ___     
     /\__\     /\  \         /\__\         /\  \         /\  \         /\__\     |\__\    
    /:/  /    /::\  \       /::|  |       /::\  \       /::\  \       /:/  /     |:|  |   
   /:/  /    /:/\:\  \     /:|:|  |      /:/\:\  \     /:/\:\  \     /:/  /      |:|  |   
  /:/  /    /::\~\:\  \   /:/|:|  |__   /:/  \:\  \   /::\~\:\  \   /:/  /       |:|__|__ 
 /:/__/    /:/\:\ \:\__\ /:/ |:| /\__\ /:/__/_\:\__\ /:/\:\ \:\__\ /:/__/        /::::\__\
 \:\  \    \/__\:\/:/  / \/__|:|/:/  / \:\  /\ \/__/ \:\~\:\ \/__/ \:\  \       /:/~~/~   
  \:\  \        \::/  /      |:/:/  /   \:\ \:\__\    \:\ \:\__\    \:\  \     /:/  /     
   \:\  \       /:/  /       |::/  /     \:\/:/  /     \:\ \/__/     \:\  \    \/__/      
    \:\__\     /:/  /        /:/  /       \::/  /       \:\__\        \:\__\              
     \/__/     \/__/         \/__/         \/__/         \/__/         \/__/              
   

```

## Introduction

<b>*Langely*</b> is a highly simple, integer-based programming language and intepreter. In a nutshell, it supports basic arithmetic, logical operations, branching, while loops, and functions (including recursion). It's intention is to demonstrate a basic understanding of working with functional programming languages (OCaml, specifically), and the inner-workings of an interpreter. For specific examples, check `langely-examples`.

To try using the programming language, try modifying `main.ly` and then run `make run`. For more details, feel free to look at the `Makefile` to see what the process of running <b>*Langely*</b> looks like.

## Large Language Models (LLMs)

This repository also includes a brief exploration into using LLMs (specifically `"deepseek-ai/deepseek-coder-1.3b-instruct"`) to produce working code in the <b>*Langely*</b> programming language. The three main techniques used were:

1. Full Finetuning (see `llm/full_finetuning.ipynb`)
2. LoRA Finetuning (see `llm/lora_finetuning.ipynb`)
3. Few-Shot Prompting (see `llm/prompting.ipynb`)

Each method has pros and cons and the results can be seen and further indivdiually tested by viewing the referenced files. Due to personal computational limitations, all the methods used had to be compatible with CPU use. While this limit severely constrains what may be done, it has the upside of forcing the discovery of relatively effecient methods. This is also the reason why the smallest DeepSeek Coder model was used.

## Resources Referenced:
- https://dev.to/nt591/writing-an-interpreter-in-ocaml-45hm
- https://canvas.kth.se/courses/42986/pages/literature-and-resources
- https://github.com/david-broman/ocaml-examples/blob/main/README.md
- https://github.com/david-broman/javascriptish
- https://discuss.ocaml.org/t/linked-list-in-ocaml/9814
- https://github.com/deepseek-ai/DeepSeek-Coder
