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
	TARGET_DIR = target/debug

	CXXFLAGS += -g3 -Og
	CXXFLAGS += -fsanitize=address,undefined
	CXXFLAGS += -D_GLIBCXX_ASSERTIONS
	
	LDFLAGS  += -fsanitize=address,undefined
else
	TARGET_DIR = target/release

	CXXFLAGS += -O3 -DNDEBUG -flto
	# use all available CPU instruction (breaks portability)
	CXXFLAGS += -march=native 

	LDFLAGS += -flto
endif

TARGET := $(TARGET_DIR)/a.out

SRC := \
	src/greeter.cpp \
	src/main.cpp \
	# add source files here
INC := \
	include \
	# add include files here
OBJ := $(patsubst src/%.cpp,$(TARGET_DIR)/%.o,$(SRC))

CPPFLAGS := $(addprefix -I,$(INC))

all: $(TARGET)

$(TARGET): $(OBJ)
	@mkdir -p $(dir $@)
	$(CXX) $(OBJ) -o $@ $(LDFLAGS)

$(TARGET_DIR)/%.o: src/%.cpp
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
