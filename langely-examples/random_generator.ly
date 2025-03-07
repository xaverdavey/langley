/*
    Langely (.ly)
    Random Generator Example
*/

let BIT_GAUGE = 63;

func random(n) {
    // n represents the number of bits of the number
    let shift = BIT_GAUGE - n;
    return rand << shift >> shift;
};

printx random(1);
printx random(4);
printx random(16);
printx random(32);
