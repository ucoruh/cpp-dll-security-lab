#include <iostream>
#include "matematik.h"

int main() {
    std::cout << "C++ Uygulamasi: Matematik DLL kullanimi\n" << std::endl;
    
    // DLL fonksiyonlarini kullan
    int a = 10, b = 5;
    
    std::cout << "Toplama: " << a << " + " << b << " = " << topla(a, b) << std::endl;
    std::cout << "Cikarma: " << a << " - " << b << " = " << cikar(a, b) << std::endl;
    std::cout << "Carpma: " << a << " * " << b << " = " << carp(a, b) << std::endl;
    std::cout << "Bolme: " << a << " / " << b << " = " << bol(a, b) << std::endl;
    
    // Sifira bolme durumu
    std::cout << "\nSifira bolme testi:" << std::endl;
    std::cout << "Bolme: " << a << " / 0 = " << bol(a, 0) << std::endl;
    
    return 0;
} 