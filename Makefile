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

# sanitizers
CXXFLAGS += -fsanitize=address,undefined
LDFLAGS  += -fsanitize=address,undefined

# debug
CXXFLAGS += -g3 -O0

TARGET := target/a.out

SRC := $(shell find src -name '*.cpp')
INC := $(shell find include -type d)
OBJ := $(patsubst src/%.cpp,target/%.o,$(SRC))

CPPFLAGS := $(addprefix -I,$(INC))

$(TARGET): $(OBJ)
	@mkdir -p $(dir $@)
	$(CXX) $(OBJ) -o $@ $(LDFLAGS)

target/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf target

.PHONY: clean
