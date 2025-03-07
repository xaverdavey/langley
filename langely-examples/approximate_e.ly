/*
    Langely (.ly)
    Approximation of Euler's Number Example
*/

func factorial(n) {
    let value = 1;
    let i = 1;
    while i <= n {
        value = value * i;
        i = i + 1;
    };
    if n == 0 {
        value = 1;
    };
    return value;
};

func approximate_e(prec, n) {
    /*
        - prec refers to precision (expressing real number as integer)
        - n refers to the number of iterations
    */
    let euler = 0;
    let i = 0;
    while i < n {
        euler = euler + prec / factorial(i);
        i = i + 1;
    };
    return euler;
};

// NOTE: this will print an approximation of euler's number times the first argument
print approximate_e(10000000, 13);