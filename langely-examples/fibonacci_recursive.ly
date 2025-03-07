/*
    Langely (.ly)
    Fibonacci (Recursive Implementation) Example
*/

func fibonacci_recursive(n) {
    let val = 0;
    if n == 0 {
        val = 0;
    };
    if n == 1 {
        val = 1;
    };
    if n > 1 {
        val = fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2);
    };
    return val;
};

print fibonacci_recursive(9);