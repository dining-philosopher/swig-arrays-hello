# TARGET=$(shell basename `pwd`)
TARGET=hello
PYWRAPCPP = $(TARGET)_wrap.cpp
PYTARGET=_$(TARGET).so

#SOURCES=$(wildcard *.cpp)
SOURCES= hello.cpp
PYSOURCES=$(SOURCES) $(PYWRAPCPP) 
SWIGFILE = hello.i

OBJECTS=$(SOURCES:%.cpp=%.o)
PYWRAPO=$(PYWRAPCPP:%.cpp=%.o)
PYOBJECTS=$(PYSOURCES:%.cpp=%.o)

#CFLAGS+=$(shell pkg-config --cflags libxslt sqlite3)
#LDFLAGS+=$(shell pkg-config --libs ncurses)
#LDFLAGS+= -lncurses -lblas -lpthread -ldl -g -pg
#LDLIBS+= -g -pg

CXXFLAGS+= -fPIC -I/usr/include/python2.7

# PYFLAGS =


all: $(TARGET) $(PYTARGET)

$(OBJECTS): $(SOURCES)

$(TARGET): $(OBJECTS)
	$(CXX) -o $(TARGET) $(LDFLAGS) $(OBJECTS) $(LOADLIBES) $(LDLIBS)

force_look :
	true


# gcc -MM generates list of dependencies!

$(PYWRAPCPP): $(SWIGFILE)
	swig -includeall -c++ -python -o $(PYWRAPCPP) $(SWIGFILE)

$(PYWRAPO): $(PYWRAPCPP)
# 	$(CXX) $(CFLAGS) -o hello_wrap.o $(PYWRAPCPP)

$(PYTARGET): $(PYOBJECTS) $(PYWRAPO)
	$(CXX) -shared $(CFLAGS) -o $(PYTARGET) $(LDFLAGS) $(PYOBJECTS) $(LOADLIBES) $(LDLIBS)

clean:
	$(RM) $(PYOBJECTS) $(PYTARGET) $(TARGET) $(PYWRAPCPP)

.PHONY: all clean
