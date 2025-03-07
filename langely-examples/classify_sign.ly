/*
    Langely (.ly)
    Sign Classification Example
*/

func classify_sign(x) {
    let class = 0;
    if x > 0 {
        class = 1; // positive
    };
    if x < 0 {
        class = -1; // negative
    };
    return class;
};

print classify_sign(-7);
print classify_sign(0);
print classify_sign(3);