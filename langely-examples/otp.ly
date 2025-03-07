/*
    Langely (.ly)
    One-Time Pad (OTP) Example
*/

func otp(x, pad) {
    return x ^ pad;
};

let my_num = 18;
let my_pad = rand;

printx my_num;
printx otp(my_num, my_pad);
printx otp(otp(my_num, my_pad), my_pad);
