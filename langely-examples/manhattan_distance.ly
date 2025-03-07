/*
    Langely (.ly)
    Manhattan Distance Example
*/

func abs(x) {
    let abs_x = x;
    if x < 0 {
        abs_x = -x;
    };
    return abs_x;
};

func manhattan_distance(x1, y1, x2, y2) {
    return abs(x1 - x2) + abs(y1 - y2);
};

print manhattan_distance(1,2,3,4);