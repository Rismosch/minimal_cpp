CXX := clang++
CXXFLAGS := -std=c++20 \
            -Wall -Wextra -Wpedantic \
            -Wconversion -Wsign-conversion \
            -Wshadow \
            -Wold-style-cast \
            -Wnon-virtual-dtor \
            -Woverloaded-virtual \
            -Wnull-dereference \
            -Wdouble-promotion \
            -Wformat=2 

DEBUG ?= 1

ifeq ($(DEBUG), 1)
	CXXFLAGS += -g3 -Og
	CXXFLAGS += -fsanitize=address,undefined
	LDFLAGS  += -fsanitize=address,undefined
else
	CXXFLAGS += -O3 -DNDEBUG -flto
	CXXFLAGS += -march=native # use all available CPU instruction (breaks portability)
	LDFLAGS += -flto
endif

TARGET := target/a.out

SRC := \
	src/greeter.cpp \
	src/main.cpp
INC := \
	include
OBJ := $(patsubst src/%.cpp,target/%.o,$(SRC))

CPPFLAGS := $(addprefix -I,$(INC))

all: $(TARGET)

$(TARGET): $(OBJ)
	@mkdir -p $(dir $@)
	$(CXX) $(OBJ) -o $@ $(LDFLAGS)

target/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

debug:
	$(MAKE) DEBUG=1

release:
	$(MAKE) DEBUG=0

clean:
	rm -rf target

run: $(TARGET)
	./$(TARGET)

.PHONY: all debug release clean run
