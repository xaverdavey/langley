/*
    Langely (.ly)
    Fibonacci (Dynamic Programming Implementation) Example
*/

func fibonacci_dynamic(n) {
    let counter = 2;
    let x_2 = 0;
    let x_1 = 1;
    let x = 1; // x = x_1 + x_2;
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

print fibonacci_dynamic(45);