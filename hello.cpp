#include "hello.h"

int foo(int x, int y){
    return - x * y;
};
double bar(const char *s){
    return atof(s);
};

int main(){
    return 0;
}

Spam::Spam(int _q) {
    q = _q;
    array = new float[_q];
    square = new float * [_q];
    for (int i = 0; i < q; i++) array[i] = i * 10;
    for (int i = 0; i < q; i++) {
        square[i] = new float[_q];
        for (int j = 0; j < q; j++) square[i][j] = j * i;
    }
    a = q * 100;
    b = q * 1000;
}

Spam::Spam() {
    q = 0;
    array = NULL;
}

Spam::~Spam() {
    delete array;
}

float * Spam::garray(){
    return array;
}

Box::Box(int _n, int _q){
    n = _n;
    content = new Spam * [n];
    for (int i = 0; i < n; i++) content[i] = new Spam(_q);
};

Box::~Box() {
    for (int i = 0; i < n; i++) delete content[i];
    delete content;
}



float * fnew(int n) {
    float * f = new float[n];
    for (int i = 0; i < n; i++) f[i] = - 1.001 * i;
    return f;
}

/*
void Spam::__setitem__(int index, float value){
        (*this).array[index] = value;
    }
*/
