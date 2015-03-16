int foo(int x, int y);

double bar(const char *s);

class Spam {
    public:
        int a, b, q;
        float * array;
        float ** square;
        
        float * garray();
         
        Spam();
        Spam(int _q);
        ~Spam();
    // void __setitem__(int index, float value);
};

class Box {
    public:
        Spam ** content;
        int n;
        
        Box(int _n, int _q);
        ~Box();
};

float * fnew(int n);
