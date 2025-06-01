#include <iostream>
// Statik kütüphaneyi kullanmak için USE_STATIC_LIB tanımı CMake ile yapılıyor
#include "matematik.h"

int main() {
    std::cout << "C++ Uygulamasi: Matematik STATIC LIB kullanimi\n" << std::endl;
    
    // Statik kütüphane fonksiyonlarini kullan
    int a = 20, b = 10;
    
    std::cout << "Toplama: " << a << " + " << b << " = " << topla(a, b) << std::endl;
    std::cout << "Cikarma: " << a << " - " << b << " = " << cikar(a, b) << std::endl;
    std::cout << "Carpma: " << a << " * " << b << " = " << carp(a, b) << std::endl;
    std::cout << "Bolme: " << a << " / " << b << " = " << bol(a, b) << std::endl;
    
    // Sifira bolme durumu
    std::cout << "\nSifira bolme testi:" << std::endl;
    std::cout << "Bolme: " << a << " / 0 = " << bol(a, 0) << std::endl;
    
    return 0;
} 