# swig-arrays-hello

Some macros for referring to C/C++ pointers as arrays from python. Unfortunately swig does not offer this capability from the box, and there is a little information in the internet how to do it.



## ARRAYMEMBER(cls, name, type)

Macro for referring to array member of class. If you have

float * Spam::array

, if you define

%array_class(float, floatArray);

...

ARRAYMEMBER(Spam, array, floatArray);

you will be able to access it from python like a regular array:


o = Spam(100)

o.array[3] = 54

o.array[3]

54.0




## ARRAYCLASS(cls, name, len, type)

Macro for referring to class as array. If you have

float * Spam::array

int Spam::q // length of array

, if you define

static int myErr = 0; // global veriable - flag to save error state

...

%array_class(float, floatArray);

...

ARRAYCLASS(Spam, array, q, float);

you will be able to access class from python like if it was your array:

o = Spam(100)

o[3] = 54

o[3]

54.0

o[564687213]

IndexError: Can not get Spam::array : index out of bounds


## Arrays of pointers

You may wrap arrays of pointers this way:

%inline %{

    typedef Spam * Spampp;
    
%}

%array_class(Spampp, spamArray);

ARRAYMEMBER(Box, content, spamArray);

, where Box::content is of type Spam**. ARRAYCLASS properly wraps such arrays without additional definitions.

So you can call your array of objects like this:

b = Box(10, 20)

b[4][5] = 200 # actually b.content[4].array[5]

## Slicing

Unfortunately, slicing is not supported yet.
