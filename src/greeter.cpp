#include "greeter.hpp"

#include <iostream>

void Greeter::greet() {
#ifdef NDEBUG
    std::cout << "i was built without debug!\n";
#else
    std::cout << "hello :)\n";
#endif
}
