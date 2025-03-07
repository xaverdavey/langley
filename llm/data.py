MODEL_NAME = "deepseek-ai/deepseek-coder-1.3b-instruct"
MODEL_MAX_NAME = 512
LY_EXAMPLES_PATH = '../langely-examples'
LY_EXEC_PATH = './../main.native'
IGNORE_INDEX = -100

EXAMPLE_MAPPING = {
    'approximate_e.ly': 'Create a function to approximate euler\'s number.',
    'approximate_pi.ly': 'Create a function to approximate pi.',
    'classify_sign.ly': 'Give me a function that outputs -1, 0 or 1 depending on the sign of a given integer.',
    'even_range.ly': 'Produce two ways to count the number of even numbers in a given range (inclusive).',
    'factorial.ly': 'Create a function that calculates the factorial of a given number.',
    'fibonacci_dynamic.ly': 'Produce a dynamic programming approach for a fibonacci sequence function.',
    'fibonacci_recursive.ly': 'Create a recursive function for a fibonacci sequence function.',
    'gcd.ly': 'Make a function that calculates the greatest common denominator.',
    'isqrt.ly': 'Give a function that calculates the integer square root. ',
    'manhattan_distance.ly': 'Produce a function that determines the manhattan distance in 2 dimensions.',
    'otp.ly': 'Use a random number for a one-tap pad.',
    'power.ly': 'Create a function that calculates integer exponentiation.',
    'random_generator.ly': 'Please make a function that generates a random number using up to a specified number of bits.',
    'rsa.ly': 'Please make a function for encrypting and decrypting a single value using the RSA method.',
    'sum_range.ly': 'Find a way to calculate the sum of a range of integers (inclusive).',
}

FEW_SHOT_PREFIX = '''Here is an example of a new and very simple programming language that is entirely integer-based (no types):

```langely
/*
    this is a
    multi-line comment
*/

// recursive implementation of fibonacci
func fibonacci_rec(n) {
    let val = 0;
    if n == 0 {
        val = 0;
    };
    if n == 1 {
        val = 1;
    };
    if n > 1 {
        val = fibonacci_rec(n - 1) + fibonacci_rec(n - 2);
    };
    return val; // return value must come at the end of a function
};

// dynamic programming implementation of fibonacci
func fibonacci_dyn(n) {
    let counter = 2;
    let x_2 = 0;
    let x_1 = 1;
    let x = 1;
    while counter < n {
        x_2 = x_1;
        x_1 = x;
        x = x_1 + x_2;
        counter = counter + 1;
    };
    if n == 0 {
        x = 0;
    };
    return x;
};

let random_number = rand; // how to generate a random number

print fibonacci_dyn(3);
```

Please perform the following task using the language above (langely):

'''
