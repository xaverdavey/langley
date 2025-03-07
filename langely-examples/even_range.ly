/*
    Langely (.ly)
    Even Range Example
*/

// less effecient approach
func even_range_bad(a, b) {
    let loc = a;
    let counter = 0;
    while loc <= b {
        if loc % 2 == 0 {
            counter = counter + 1;
        };
        loc = loc + 1;
    };
    return counter;
};

// more effecient approach
func even_range_good(a, b) {
    let first_even = a;
    if a % 2 != 0 {
        first_even = a + 1;
    };
    let last_even = b;
    if b % 2 != 0 {
        last_even = b - 1;
    };
    return (last_even - first_even) / 2 + 1;
};

let start = 8;
let finish = 14;

print even_range_bad(start, finish);
print even_range_good(start, finish);

