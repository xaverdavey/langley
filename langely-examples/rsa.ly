/*
    Langely (.ly)
    RSA Example
*/

func encrypt(char, _e, _n) {
    return char ** _e % _n;
};

func decrypt(sym, _d, _n) {
    return sym ** _d % _n;
};

let n = 33;
let e = 7; // (e, n) is public key
let d = 3; // (d, n) is private key

let MY_CHAR = 2;

let encrypted_char = encrypt(MY_CHAR, e, n);
let decrypted_char = decrypt(encrypted_char, d, n);

printx MY_CHAR;
printx encrypted_char;
printx decrypted_char;
