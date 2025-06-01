#define MATEMATIK_EXPORTS
#define _CRT_SECURE_NO_WARNINGS  // Güvenlik uyarılarını bastır
#include "matematik.h"
#include <stdio.h>
#include <windows.h>

// DLL yaşam döngüsü eventleri için log dosyası
FILE* logFile = NULL;

// DLL yaşam döngüsü eventi yazdırma fonksiyonu
void LogDllEvent(const char* event) {
    if (logFile == NULL) {
        errno_t err = fopen_s(&logFile, "matematik_dll_events.log", "a");
        if (err != 0) {
            logFile = NULL;
        }
    }
    
    if (logFile != NULL) {
        fprintf(logFile, "%s\n", event);
        fflush(logFile);
    }
    
    // Konsola da yazdır
    printf("[MATEMATIK DLL EVENT] %s\n", event);
}

// DLL giriş noktası
BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) {
    char buffer[256];
    
    switch (fdwReason) {
        case DLL_PROCESS_ATTACH:
            LogDllEvent("DLL_PROCESS_ATTACH: DLL bir process'e yuklendi.");
            sprintf_s(buffer, sizeof(buffer), "   DLL yuklenen process ID: %lu", GetCurrentProcessId());
            LogDllEvent(buffer);
            // Her thread için DLL_THREAD_ATTACH çağrılmasını engellemek için
            DisableThreadLibraryCalls(hinstDLL);
            break;
            
        case DLL_THREAD_ATTACH:
            LogDllEvent("DLL_THREAD_ATTACH: Yeni bir thread DLL'i kullaniyor.");
            break;
            
        case DLL_THREAD_DETACH:
            LogDllEvent("DLL_THREAD_DETACH: Bir thread DLL'i kullanmayi birakti.");
            break;
            
        case DLL_PROCESS_DETACH:
            sprintf_s(buffer, sizeof(buffer), "DLL_PROCESS_DETACH: DLL process'ten ayrildi. Process ID: %lu", 
                    GetCurrentProcessId());
            LogDllEvent(buffer);
            
            if (lpvReserved != NULL) {
                LogDllEvent("   Process sonlandirildi.");
            } else {
                LogDllEvent("   DLL FreeLibrary() ile kaldirildi.");
            }
            
            // Log dosyasını kapat
            if (logFile != NULL) {
                fclose(logFile);
                logFile = NULL;
            }
            break;
    }
    
    return TRUE;
}

// Fonksiyon çağrı kaydını tutan fonksiyon
void LogFunctionCall(const char* functionName, int a, int b) {
    char buffer[256];
    sprintf_s(buffer, sizeof(buffer), "FONKSIYON CAGRISI: %s(%d, %d)", functionName, a, b);
    LogDllEvent(buffer);
}

// Fonksiyon implementasyonları
int topla(int a, int b) {
    LogFunctionCall("topla", a, b);
    printf("C DLL: %d + %d islemi yapiliyor\n", a, b);
    return a + b;
}

int cikar(int a, int b) {
    LogFunctionCall("cikar", a, b);
    printf("C DLL: %d - %d islemi yapiliyor\n", a, b);
    return a - b;
}

int carp(int a, int b) {
    LogFunctionCall("carp", a, b);
    printf("C DLL: %d * %d islemi yapiliyor\n", a, b);
    return a * b;
}

double bol(int a, int b) {
    LogFunctionCall("bol", a, b);
    printf("C DLL: %d / %d islemi yapiliyor\n", a, b);
    if (b == 0) {
        printf("Hata: Sifira bolme!\n");
        return 0;
    }
    return (double)a / b;
} 