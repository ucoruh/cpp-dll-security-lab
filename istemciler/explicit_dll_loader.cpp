#include <iostream>
#include <windows.h>
#include <string>

// Matematik DLL fonksiyon tipleri
typedef int (*ToplaFunc)(int a, int b);
typedef int (*CikarFunc)(int a, int b);
typedef int (*CarpFunc)(int a, int b);
typedef double (*BolFunc)(int a, int b);

void PrintEvent(const std::string& message) {
    std::cout << "[EVENT] " << message << std::endl;
}

int main() {
    std::cout << "DLL Programatik Yukleme ve Fonksiyon Cagirilari Ornegi\n" << std::endl;
    
    // Adım 1: DLL'i yükle
    PrintEvent("DLL yukleniyor...");
    HMODULE hDLL = LoadLibraryA("matematik.dll");
    
    if (!hDLL) {
        std::cerr << "Hata: DLL yuklenemedi! Hata kodu: " << GetLastError() << std::endl;
        return 1;
    }
    
    PrintEvent("DLL basariyla yuklendi!");
    
    // Adım 2: Fonksiyon adreslerini al
    PrintEvent("Fonksiyon adresleri aliniyor...");
    
    ToplaFunc topla = (ToplaFunc)GetProcAddress(hDLL, "topla");
    if (!topla) {
        std::cerr << "Hata: 'topla' fonksiyonu bulunamadi!" << std::endl;
        FreeLibrary(hDLL);
        return 1;
    }
    
    CikarFunc cikar = (CikarFunc)GetProcAddress(hDLL, "cikar");
    if (!cikar) {
        std::cerr << "Hata: 'cikar' fonksiyonu bulunamadi!" << std::endl;
        FreeLibrary(hDLL);
        return 1;
    }
    
    CarpFunc carp = (CarpFunc)GetProcAddress(hDLL, "carp");
    if (!carp) {
        std::cerr << "Hata: 'carp' fonksiyonu bulunamadi!" << std::endl;
        FreeLibrary(hDLL);
        return 1;
    }
    
    BolFunc bol = (BolFunc)GetProcAddress(hDLL, "bol");
    if (!bol) {
        std::cerr << "Hata: 'bol' fonksiyonu bulunamadi!" << std::endl;
        FreeLibrary(hDLL);
        return 1;
    }
    
    PrintEvent("Tum fonksiyon adresleri alindi!");
    
    // Adım 3: Fonksiyonları çağır
    int a = 15, b = 5;
    std::cout << "\nFonksiyonlar cagiriliyor (a=" << a << ", b=" << b << "):\n" << std::endl;
    
    PrintEvent("'topla' fonksiyonu cagriliyor...");
    int toplaSonuc = topla(a, b);
    std::cout << "  Sonuc: " << a << " + " << b << " = " << toplaSonuc << std::endl;
    
    PrintEvent("'cikar' fonksiyonu cagriliyor...");
    int cikarSonuc = cikar(a, b);
    std::cout << "  Sonuc: " << a << " - " << b << " = " << cikarSonuc << std::endl;
    
    PrintEvent("'carp' fonksiyonu cagriliyor...");
    int carpSonuc = carp(a, b);
    std::cout << "  Sonuc: " << a << " * " << b << " = " << carpSonuc << std::endl;
    
    PrintEvent("'bol' fonksiyonu cagriliyor...");
    double bolSonuc = bol(a, b);
    std::cout << "  Sonuc: " << a << " / " << b << " = " << bolSonuc << std::endl;
    
    // Sıfıra bölme durumu da test et
    PrintEvent("'bol' fonksiyonu sifira bolme ile cagriliyor...");
    double bolSonuc2 = bol(a, 0);
    std::cout << "  Sonuc: " << a << " / 0 = " << bolSonuc2 << std::endl;
    
    // Adım 4: DLL'i kaldır
    std::cout << "\n";
    PrintEvent("DLL kaldiriliyor...");
    FreeLibrary(hDLL);
    PrintEvent("DLL kaldirildi!");
    
    // Bekleme
    std::cout << "\nCikis icin bir tusa basin..." << std::endl;
    std::cin.get();
    
    return 0;
} 