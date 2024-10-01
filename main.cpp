// main.cpp
#include <iostream>

int soma(int a, int b) {
    return a + b;
}

int main() {
    int a, b;
    std::cin >> a >> b;
    std::cout << soma(a, b) << std::endl;
    return 0;
}
