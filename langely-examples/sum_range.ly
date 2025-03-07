/*
    Langely (.ly)
    Sum of Range Example
*/

func sum_range(start, end) {
    let sum = 0;
    let counter = start;
    while counter <= end {
        sum = sum + counter;
        counter = counter + 1;
    };
    return sum;
};

print sum_range(2, 4);