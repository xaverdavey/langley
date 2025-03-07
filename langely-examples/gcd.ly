/*
    Langely (.ly)
    GCD Example
*/

func gcd(a, b) {
    // NOTE: a must be greater than b
    let cand = a % b;
    if cand != 0 {
        b = gcd(b, cand);
    };
    return b;
};

print gcd(1245, 36);