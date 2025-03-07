/*
    Langely (.ly)
    Approximation of Pi Example
*/

func approximate_pi(prec, n) {
    /*
        - prec refers to precision (expressing real number as integer)
        - n refers to the number of iterations
    */
    let pi = 0;
    let i = 0;
    while i < n {
        pi = pi + prec * (-1) ** i / (2 * i + 1);
        i = i + 1;
    };
    return pi * 4;
};

// NOTE: this will print an approximation of pi times the first argument
print approximate_pi(10000, 10000);