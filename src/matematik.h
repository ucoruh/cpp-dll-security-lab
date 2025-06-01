#ifndef MATEMATIK_H
#define MATEMATIK_H

// DLL export/import makroları
#ifdef USE_STATIC_LIB
    // Statik kütüphane kullanımı için makro tanımı
    #define MATEMATIK_API
#else
    // DLL kullanımı için makro tanımları
    #ifdef MATEMATIK_EXPORTS
        #define MATEMATIK_API __declspec(dllexport)
    #else
        #define MATEMATIK_API __declspec(dllimport)
    #endif
#endif

#ifdef __cplusplus
extern "C" {  // C++ uyumluluğu için
#endif

// DLL'in dışa açılan fonksiyonları
MATEMATIK_API int topla(int a, int b);
MATEMATIK_API int cikar(int a, int b);
MATEMATIK_API int carp(int a, int b);
MATEMATIK_API double bol(int a, int b);

#ifdef __cplusplus
}
#endif

#endif // MATEMATIK_H 