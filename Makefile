CXX=mpic++
CXXFLAGS=-std=c++11 -DNDEBUG -fopenmp -Wall -Wextra -Wno-cast-function-type -O3 -Isrc
LDLIBS=-lfftw3_mpi -lfftw3_omp -lfftw3 -larmadillo
.PHONY : all clean test install uninstall

OBJECTS=$(patsubst src/%.cpp,obj/%.o,$(wildcard src/*.cpp))

all : coulombo potentials

coulombo : coulombo.cpp $(OBJECTS)

potentials: potentials.cpp $(OBJECTS)

run-tests : LDLIBS := $(LDLIBS) -lcppunit
run-tests : run-tests.cpp $(OBJECTS)

obj/%.o : src/%.cpp | obj
	$(CXX) -c $(CXXFLAGS) -o $@ $<

obj :
	@mkdir -pv obj

clean :
	@rm -rvf coulombo potentials obj run-tests

test : run-tests
	@./run-tests

install : coulombo
	@cp -v coulombo /usr/local/bin/

uninstall :
	@rm -vf /usr/local/bin/coulombo
