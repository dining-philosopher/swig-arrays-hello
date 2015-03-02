%module hello
%{
#include "hello.h"
// typedef Spam * Spam_p;


static int myErr = 0; // flag to save error state

%}
// #define PI 3.14159;

// %include "cpointer.i"
%include "carrays.i"
%include "exception.i"




%array_class(double, doubleArray);
// %array_functions(float, floatArray);
%array_class(float, floatArray);



//static_cast< type * >

// macro definition for referring to array in class like o.a[i] from python
// define %array_class(smth, smthArray); first !
// usage example: ARRAYMEMBER(Spam, array, floatArray);

%define ARRAYMEMBER(cls, name, type)

%extend cls{
    type * name ## _getarray(){
        // return type ## _frompointer((*self).name);
        return type ## _frompointer((*self).name);
    }
    
    %pythoncode %{
       __swig_getmethods__["name"] = name ## _getarray
       if _newclass: name = _swig_property(name ## _getarray, __swig_setmethods__["name"])
    %}
}
%enddef
// /macro definition for referring to array in class like o.a[i] from python



// macro definition for referring to array in class 
// like class itself is array, i. e. o[i] from python
// http://stackoverflow.com/questions/8776328/swig-interfacing-c-library-to-python-creating-iterable-python-data-type-from
// no slicing supported!
// define static int myErr = 0; and %array_class(smth, smthArray); first !
// usage example: ARRAYCLASS(Spam, array, q, float);

%define ARRAYCLASS(cls, name, len, type)

%exception cls::__getitem__ {
  assert(!myErr);
  $action
  if (myErr) {
    myErr = 0; // clear flag for next time
    // You could also check the value in $result, but it''s a PyObject here
    SWIG_exception(SWIG_IndexError, "Can not get cls::name : index out of bounds");
  }
}

%exception cls::__setitem__ {
  assert(!myErr);
  $action
  if (myErr) {
    myErr = 0; // clear flag for next time
    // You could also check the value in $result, but it''s a PyObject here
    SWIG_exception(SWIG_IndexError, "Can not set cls::name : index out of bounds");
  }
}

%extend cls{
    type __getitem__(int index) const {
        if (index >= $self->len) {
            myErr = 1;
            return 0;
        }
        return $self->name[index];
        // return (*self).name[index];
    }
    void __setitem__(int index, type value) const {
        if (index >= $self->len) {
            myErr = 1;
            return;
        }
        (*self).name[index] = value;
    };
    int __len__() {
        return (*self).len;
    }
     
}
%enddef
// /macro definition for referring to array in class like o[i] from python















// works but replaced by macros
/*
%exception Spam::__getitem__ {
  assert(!myErr);
  $action
  if (myErr) {
    myErr = 0; // clear flag for next time
    // You could also check the value in $result, but it''s a PyObject here
    SWIG_exception(SWIG_IndexError, "Index out of bounds");
  }
}
%exception Spam::__setitem__ {
  assert(!myErr);
  $action
  if (myErr) {
    myErr = 0; // clear flag for next time
    // You could also check the value in $result, but it''s a PyObject here
    SWIG_exception(SWIG_IndexError, "Index out of bounds");
  }
}


%extend Spam{
    
    float __getitem__(int index) const {
        if (index >= $self->q) {
            myErr = 1;
            return 0;
        }
        return $self->array[index];
        // return (*self).array[index];
    }
    void __setitem__(int index, float value) const {
        if (index >= $self->q) {
            myErr = 1;
            return;
        }
        (*self).array[index] = value;
    };
    int __len__() {
        return (*self).q;
    }
    
    
    
    // void setarray(float * value) const {
        // dummy function!
        // (*self).array = value;
    // };
    floatArray * getarray(){
        return floatArray_frompointer((*self).array);
    }
    
    %pythoncode %{
       __swig_getmethods__["array"] = getarray
       #__swig_setmethods__["array"] = __swig_setmethods__["array"]
       if _newclass: array = _swig_property(getarray, __swig_setmethods__["array"])
    %}
    

}
// works but replaced by macros
*/



ARRAYMEMBER(Spam, array, floatArray);
ARRAYCLASS(Spam, array, q, float);

// %pointer_class(Spam, Spamp);
%inline %{
    typedef Spam * Spampp;
%}
// %array_class(Spam_p, spamArray);
%array_class(Spampp, spamArray);
ARRAYMEMBER(Box, content, spamArray);
ARRAYCLASS(Box, content, n, Spam*);


// http://stackoverflow.com/questions/11998369/swig-python-structure-array

// %shadow Spam::array_get

%pythonappend Spam::array_get() %{
    # Wrap it automatically
    val = floatArray.frompointer(val)
%}

%pythonappend Spam::getarray() %{
    # Wrap it automatically - does not work for entities defined in swig file
    val = floatArray.frompointer(val)
%}


%pythonappend Spam::garray() %{
    # Wrap it automatically
    val = floatArray.frompointer(val)
%}

%pythonappend fnew(int) %{
    # Wrap it automatically
    val = floatArray.frompointer(val)
%}


// %typemap(out) float * = ($result = floatArray_frompointer($1));

// %apply float * { floatArray  };
// %apply floatArray  { float * };


%include "hello_export.h"

extern float * fnew(int n);

/*
%inline %{
void array_set(int i, float val) {
   array[i] = val;
}
float array_get(int i) {
   return array[i];
}
%}
*/

/*int foo(int x, int y);
double bar(const char *s);
struct Spam {
 int a, b, q;
 float * array;
 Spam(int _q);
};*/



/*
    python test for memory leaks

def deltest(n, x = 10000, y = 10000, verbose = False):
    for i in xrange(n):
        b = hello.Box(x, y)
        del b
        if verbose: print i, " creation-deletion cycles of Box[", x, "][", y, "]"


 */
