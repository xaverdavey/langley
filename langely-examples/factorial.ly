/*
    Langely (.ly)
    Factorial Example
*/

func factorial(n) {
    let value = 1;
    if n != 0 {
        value = n * factorial(n - 1);
    };
    return value;
};

print factorial(5);