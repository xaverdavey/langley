/*
    Langely (.ly)
    Integer Square Root Example
*/

func isqrt(x) {
    let result = 0;
    while result ** 2 <= x {
        result = result + 1;
    };
    result = result - 1;
    if x < 0 {
        result = -1;
    };
    return result;
};

print isqrt(-8); // negative number
print isqrt(0); // zero
print isqrt(1); // one
print isqrt(8); // imperfect square
print isqrt(9); // perfect square
