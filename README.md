# 🎓 Dinamik ve Statik Kütüphane Öğrenme Laboratuvarı

<div align="center">
  
![Versiyon](https://img.shields.io/badge/version-2.0.0-blue.svg)
![Lisans](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![Eğitim](https://img.shields.io/badge/education-friendly-green.svg)

</div>

<p align="center">
  <b>📚 C/C++ ve C# dillerinde kütüphane yapıları, DLL güvenliği ve sistem programlama kavramlarını öğrenmek için kapsamlı laboratuvar projesi</b>
</p>

---

## 🎯 Bu Projeden Ne Öğreneceksiniz?

Bu laboratuvar projesi ile aşağıdaki konularda uzmanlaşacaksınız:

### 🧩 **Kütüphane Türleri ve Farkları**
- **Statik Kütüphaneler (.lib/.a)**: Derleme zamanında bağlanan kütüphaneler
- **Dinamik Kütüphaneler (.dll/.so)**: Çalışma zamanında yüklenen kütüphaneler
- Her iki yaklaşımın avantaj ve dezavantajları

### 🔗 **DLL Bağlama Teknikleri**
- **İmplisit Bağlama**: Header dosyası ile otomatik bağlama
- **Eksplisit Bağlama**: LoadLibrary/GetProcAddress API'leri ile dinamik yükleme

### 🛡️ **Güvenlik Kavramları**
- DLL Hijacking/Replacement saldırıları
- Güvenlik açıkları ve korunma yöntemleri
- Güvenilir olmayan DLL'lerin riskleri

### 💻 **Çoklu Dil Desteği**
- C/C++ ile DLL geliştirme
- C# ile P/Invoke kullanımı
- Diller arası veri paylaşımı

---

## 📂 Proje Mimarisi ve Dosya Yapısı

```
matematik-kutuphanesi/
│
├── 📁 src/                           # Ana kütüphane kaynak kodları
│   ├── matematik.h                   # Kütüphane arayüz tanımları
│   └── matematik.c                   # Normal DLL implementasyonu
│
├── 📁 kotu-amacli/                   # Güvenlik simülasyonu
│   └── malicious_matematik.c         # Saldırı simülasyonu için zararlı DLL
│
├── 📁 istemciler/                    # Örnek istemci uygulamaları
│   ├── main.cpp                      # C++ implicit DLL client
│   ├── main_static.cpp               # C++ static library client
│   ├── explicit_dll_loader.cpp       # C++ explicit DLL loader
│   ├── CSharpClient/                 # C# implicit client
│   │   ├── Program.cs
│   │   └── CSharpClient.csproj
│   └── CSharpExplicitLoader/         # C# explicit loader
│
├── 📁 simulasyonlar/                 # Eğitici simulasyonlar
│   ├── dll_events_monitor.ps1        # DLL yaşam döngüsü izleme
│   ├── dll_switch.ps1               # DLL değişimi simülasyonu
│   └── dll_switch.bat               # Batch versiyonu
│
├── 📁 build/                         # CMake derleme çıktıları
│   ├── bin/                          # Executable dosyalar
│   └── lib/                          # Kütüphane dosyaları
│
├── 📁 bin/                           # C# uygulamaları için
│   └── Debug/net6.0/                # .NET runtime çıktıları
│
└── CMakeLists.txt                    # Proje yapılandırma dosyası
```

---

## 🚀 Adım Adım Kurulum ve Derleme Rehberi

### ⚙️ Gerekli Yazılımlar

1. **Visual Studio 2019/2022** (C++ geliştirme araçları ile)
2. **CMake 3.10+** (proje yönetimi için)
3. **.NET 6.0 SDK** (C# örnekleri için)
4. **Git** (proje klonlama için)

### 📥 Proje İndirme

```bash
git clone https://github.com/kullanici/matematik-kutuphanesi.git
cd matematik-kutuphanesi
```

### 🔨 C++ Projelerini Derleme

```bash
# 1. Build klasörü oluştur
mkdir build
cd build

# 2. CMake ile proje yapılandır
cmake ..

# 3. Projeyi derle (Debug modu)
cmake --build . --config Debug

# 4. Release modu için (isteğe bağlı)
cmake --build . --config Release
```

### 🔵 C# Projelerini Derleme

```bash
# Ana dizine dön
cd ..

# C# Client'ı derle
cd istemciler/CSharpClient
dotnet build

# C# Explicit Loader'ı derle
cd ../CSharpExplicitLoader
dotnet build

# Ana dizine dön
cd ../..

# DLL'i C# çıktı klasörüne kopyala
copy build\bin\Debug\matematik.dll bin\Debug\net6.0\
```

---

## 🧮 Matematik Kütüphanesi API Dokümantasyonu

### 📋 Fonksiyon Listesi

```c
// Temel matematik işlemleri
MATEMATIK_API int topla(int a, int b);      // İki sayının toplamı
MATEMATIK_API int cikar(int a, int b);      // İki sayının farkı  
MATEMATIK_API int carp(int a, int b);       // İki sayının çarpımı
MATEMATIK_API double bol(int a, int b);     // İki sayının bölümü (sıfır kontrolü ile)
```

### 🔧 Makro Tanımları

```c
#ifdef USE_STATIC_LIB
    #define MATEMATIK_API                    // Statik kütüphane için boş makro
#else
    #ifdef MATEMATIK_EXPORTS
        #define MATEMATIK_API __declspec(dllexport)  // DLL export
    #else
        #define MATEMATIK_API __declspec(dllimport)  // DLL import
    #endif
#endif
```

### 📊 DLL Yaşam Döngüsü Olayları

DLL aşağıdaki olayları loglar:

1. **DLL_PROCESS_ATTACH**: DLL bir process'e yüklendiğinde
2. **DLL_THREAD_ATTACH**: Yeni thread DLL'i kullanmaya başladığında
3. **DLL_THREAD_DETACH**: Thread DLL'i kullanmayı bıraktığında
4. **DLL_PROCESS_DETACH**: DLL process'ten ayrıldığında

---

## 💻 Örnek Uygulamaları Çalıştırma

### 🔗 1. C++ İmplisit DLL Kullanımı

```bash
# DLL'i otomatik yükleyen C++ uygulaması
.\build\bin\Debug\matematik_client.exe
```

**Kod Örneği:**
```cpp
#include "matematik.h"
#include <iostream>

int main() {
    int a = 10, b = 5;
    std::cout << "Toplam: " << topla(a, b) << std::endl;
    return 0;
}
```

### 📚 2. C++ Statik Kütüphane Kullanımı

```bash
# Statik kütüphane kullanan C++ uygulaması
.\build\bin\Debug\matematik_static_client.exe
```

**Avantajları:**
- ✅ Bağımsız çalışan executable
- ✅ DLL saldırılarından korunmalı
- ❌ Daha büyük dosya boyutu

### 🎛️ 3. C++ Eksplisit DLL Yükleme

```bash
# DLL'i programatik olarak yükleyen uygulama
.\build\bin\Debug\explicit_dll_loader.exe
```

**Kod Özeti:**
```cpp
// DLL yükle
HMODULE hDLL = LoadLibraryA("matematik.dll");

// Fonksiyon adresini al
typedef int (*ToplaFunc)(int, int);
ToplaFunc topla = (ToplaFunc)GetProcAddress(hDLL, "topla");

// Kullan
int sonuc = topla(10, 5);

// Temizle
FreeLibrary(hDLL);
```

### 🔵 4. C# İmplisit P/Invoke Kullanımı

```bash
# C# DLL istemcisi
.\bin\Debug\net6.0\CSharpClient.exe
```

**Kod Örneği:**
```csharp
[DllImport("matematik.dll", CallingConvention = CallingConvention.Cdecl)]
public static extern int topla(int a, int b);

static void Main() {
    int sonuc = topla(10, 5);
    Console.WriteLine($"Sonuç: {sonuc}");
}
```

### ⚙️ 5. C# Eksplisit DLL Yükleme

```bash
# C# ile dinamik DLL yükleme
.\bin\Debug\net6.0\CSharpExplicitLoader.exe
```

---

## 🛡️ Güvenlik Simülasyonları

### ⚠️ DLL Replacement Saldırısı Simülasyonu

Bu simülasyon, güvenlik farkındalığı oluşturmak için tasarlanmıştır:

```bash
# PowerShell ile
powershell -ExecutionPolicy Bypass -File .\simulasyonlar\dll_switch.ps1

# Batch ile
.\simulasyonlar\dll_switch.bat
```

**Simülasyon Adımları:**

1. **Normal DLL ile test**: Güvenli matematik işlemleri
2. **Kötü DLL ile değiştirme**: `malicious_matematik.dll` devreye girer
3. **Saldırı gösterimi**: Her fonksiyon çağrısında güvenlik uyarıları
4. **Normal duruma dönüş**: Güvenli DLL geri yüklenir

### 📊 DLL Yaşam Döngüsü İzleme

```bash
powershell -ExecutionPolicy Bypass -File .\simulasyonlar\dll_events_monitor.ps1
```

Bu simülasyon şunları gösterir:
- DLL yükleme/kaldırma süreçleri
- Process ve thread olayları
- İmplisit vs eksplisit yükleme farkları
- Statik kütüphane güvenlik avantajları

---

## 🔬 Detaylı Kod Analizi

### 📄 `matematik.c` - Ana DLL Implementasyonu

```c
// DLL giriş noktası - tüm yaşam döngüsü olaylarını yakalar
BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) {
    switch (fdwReason) {
        case DLL_PROCESS_ATTACH:
            LogDllEvent("DLL yüklendi");
            break;
        case DLL_PROCESS_DETACH:
            LogDllEvent("DLL kaldırıldı");
            break;
    }
    return TRUE;
}

// Örnek matematik fonksiyonu
int topla(int a, int b) {
    LogFunctionCall("topla", a, b);  // Çağrıyı logla
    printf("C DLL: %d + %d işlemi yapılıyor\n", a, b);
    return a + b;
}
```

**Önemli Özellikler:**
- Her fonksiyon çağrısı loglanır
- DLL yaşam döngüsü olayları izlenir
- Process ID'si ile detaylı takip

### 🦠 `malicious_matematik.c` - Güvenlik Demonstrasyonu

```c
int topla(int a, int b) {
    // Saldırı simülasyonu - eğitim amaçlı
    MessageBoxA(NULL, "Bilgileriniz çalınıyor!", 
               "GÜVENLİK UYARISI", MB_OK | MB_ICONWARNING);
    
    // Normal fonksiyonellik korunur (saldırıyı gizlemek için)
    return a + b;
}
```

**Simüle Edilen Saldırı Türleri:**
- Veri hırsızlığı uyarısı
- Parola kopyalama uyarısı
- Dosya şifreleme uyarısı
- Uzaktan erişim uyarısı

### 🎯 `explicit_dll_loader.cpp` - Dinamik Yükleme

```cpp
// 1. DLL'i yükle
HMODULE hDLL = LoadLibraryA("matematik.dll");

// 2. Fonksiyon adresini al
typedef int (*ToplaFunc)(int, int);
ToplaFunc topla = (ToplaFunc)GetProcAddress(hDLL, "topla");

// 3. Fonksiyonu çağır
int sonuc = topla(15, 5);

// 4. DLL'i kaldır
FreeLibrary(hDLL);
```

**Avantajları:**
- Çalışma zamanında DLL seçimi
- İsteğe bağlı özellik yükleme
- Bellek yönetimi kontrolü

---

## 📊 Kütüphane Türleri Karşılaştırması

| Özellik | Statik Kütüphane | Dinamik Kütüphane (DLL) |
|---------|------------------|-------------------------|
| **Boyut** | ❌ Büyük executable | ✅ Küçük executable |
| **Bağımlılık** | ✅ Bağımsız | ❌ DLL gerekli |
| **Güvenlik** | ✅ DLL saldırılarından korunmalı | ❌ DLL değişimine açık |
| **Bellek** | ❌ Her uygulama ayrı kopya | ✅ Paylaşımlı bellek |
| **Güncelleme** | ❌ Yeniden derleme gerekli | ✅ Sadece DLL değişir |
| **Performans** | ✅ Doğrudan çağrı | ❌ İndirection overhead |

---

## 🎓 Eğitici Aktiviteler ve Ödevler

### 🥇 Başlangıç Seviyesi

1. **İlk DLL Deneyimi**
   - Mevcut kodu derleyip çalıştırın
   - Her istemci uygulamasını test edin
   - Log dosyalarını inceleyin

2. **Fonksiyon Ekleme**
   ```c
   // matematik.h'ye ekleyin
   MATEMATIK_API int kare(int x);
   MATEMATIK_API int faktoriyel(int n);
   
   // matematik.c'ye implementasyon ekleyin
   int kare(int x) { return x * x; }
   ```

### 🥈 Orta Seviye

3. **String İşlemleri DLL'i**
   - Yeni bir DLL oluşturun
   - String manipülasyon fonksiyonları ekleyin
   - Unicode desteği ekleyin

4. **Hata Yönetimi**
   ```c
   typedef enum {
       MATEMATIK_OK = 0,
       MATEMATIK_DIVIDE_BY_ZERO = 1,
       MATEMATIK_OVERFLOW = 2
   } MatematikHata;
   
   MATEMATIK_API MatematikHata guvenli_bol(int a, int b, double* sonuc);
   ```

### 🥉 İleri Seviye

5. **Cross-Platform Destek**
   - Linux için .so dosyası desteği ekleyin
   - CMake ile conditional compilation
   - Macro uyumluluğu sağlayın

6. **Callback Fonksiyonları**
   ```c
   typedef void (*ProgressCallback)(int percent);
   MATEMATIK_API void uzun_hesaplama(int n, ProgressCallback callback);
   ```

7. **Thread Safety**
   - Mutex ile thread-safe fonksiyonlar
   - Thread-local storage kullanımı

---

## 🔧 Sorun Giderme

### ❌ Yaygın Hatalar ve Çözümleri

**1. "DLL bulunamadı" Hatası**
```bash
# Çözüm: DLL'i doğru konuma kopyalayın
copy build\bin\Debug\matematik.dll .
# veya PATH'e ekleyin
```

**2. "Fonksiyon bulunamadı" Hatası**
```bash
# DLL'deki fonksiyonları kontrol edin
dumpbin /exports matematik.dll
```

**3. C# P/Invoke Hataları**
```csharp
// CallingConvention'ı doğru ayarlayın
[DllImport("matematik.dll", CallingConvention = CallingConvention.Cdecl)]
```

**4. CMake Derleme Hataları**
```bash
# Build klasörünü temizleyin
rmdir /s build
mkdir build
cd build
cmake ..
```

### 🔍 Debug İpuçları

1. **Log Dosyalarını Kontrol Edin**
   - `matematik_dll_events.log` - Normal DLL olayları
   - `malicious_dll_events.log` - Saldırı simülasyonu

2. **Process Monitor Kullanın**
   - DLL yükleme süreçlerini izleyin
   - Dosya erişimlerini kontrol edin

3. **Dependency Walker**
   - DLL bağımlılıklarını analiz edin
   - Missing imports'ları bulun

---

## 🌟 İleri Düzey Konular

### 🔒 DLL Güvenliği Best Practices

1. **DLL İmzalama**
   ```bash
   # Code signing ile DLL'i imzalayın
   signtool sign /f mycert.pfx matematik.dll
   ```

2. **DLL Doğrulama**
   ```c
   // DLL hash kontrolü
   BOOL VerifyDllIntegrity(const char* dllPath);
   ```

3. **Safe DLL Loading**
   ```c
   // SetDllDirectory ile güvenli yükleme
   SetDllDirectory(L"C:\\MyApp\\SecureDlls\\");
   ```

### 🚀 Performans Optimizasyonu

1. **Delay Loading**
   ```cpp
   #pragma comment(linker, "/DELAYLOAD:matematik.dll")
   ```

2. **Memory Mapping**
   ```c
   // DLL'i memory-mapped file olarak yükle
   HANDLE hFile = CreateFileMapping(...);
   ```

### 🌐 Cross-Language Interoperability

**Python Integration:**
```python
import ctypes
dll = ctypes.CDLL('./matematik.dll')
dll.topla.argtypes = (ctypes.c_int, ctypes.c_int)
dll.topla.restype = ctypes.c_int
result = dll.topla(10, 5)
```

**Java Integration:**
```java
public class MatematikJNI {
    static {
        System.loadLibrary("matematik");
    }
    public native int topla(int a, int b);
}
```

---

## 📚 Ek Kaynaklar ve Okuma Listesi

### 📖 Önerilen Kitaplar
- "Programming Windows" - Charles Petzold
- "Windows System Programming" - Johnson M. Hart
- "Advanced Windows Debugging" - Mario Hewardt

### 🌐 Yararlı Linkler
- [Microsoft DLL Documentation](https://docs.microsoft.com/en-us/windows/win32/dlls/)
- [CMake Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/)
- [P/Invoke Reference](https://docs.microsoft.com/en-us/dotnet/standard/native-interop/pinvoke)

### 🛠️ Geliştirme Araçları
- **Visual Studio** - IDE ve debugger
- **Process Monitor** - Dosya/registry erişimi izleme
- **Dependency Walker** - DLL bağımlılık analizi
- **API Monitor** - API çağrıları izleme

---

## 🤝 Katkıda Bulunma

### 🔧 Geliştirme Yönergeleri

1. **Fork ve Clone**
   ```bash
   git fork https://github.com/kullanici/matematik-kutuphanesi
   git clone your-fork-url
   ```

2. **Feature Branch Oluşturma**
   ```bash
   git checkout -b feature/yeni-ozellik
   ```

3. **Kod Standartları**
   - C kodu için K&R style
   - C++ için Google Style Guide
   - C# için Microsoft Coding Conventions

4. **Test Ekleme**
   - Her yeni fonksiyon için test yazın
   - Güvenlik testlerini unutmayın

### 🐛 Bug Raporu

Issue açarken şunları ekleyin:
- İşletim sistemi ve versiyon
- Compiler ve versiyon
- Hata mesajı ve stack trace
- Tekrarlanabilir örnek kod

---

## 📜 Lisans ve Yasal Uyarılar

### 📄 MIT Lisansı

Bu proje MIT lisansı altında sunulmaktadır. Eğitim amaçlı kullanım için tamamen ücretsizdir.

### ⚠️ Güvenlik Uyarısı

Bu projedeki güvenlik simülasyonları **sadece eğitim amaçlıdır**. Gerçek sistemlerde zararlı amaçlarla kullanılmamalıdır. Proje sahipleri, kötüye kullanımdan sorumlu değildir.

### 🎓 Akademik Kullanım

Bu proje akademik ortamlarda, üniversite derslerinde ve eğitim programlarında serbestçe kullanılabilir. Kaynak gösterimi gereklidir.

---

## 📞 İletişim ve Destek

### 👨‍💻 Proje Sahipleri
- **Ana Geliştirici**: [@ugur-coruh](https://github.com/ugur-coruh)
- **E-posta**: ugur.coruh@bilecik.edu.tr

### 💬 Topluluk Desteği
- **GitHub Issues**: Teknik sorular için
- **Discussions**: Genel tartışmalar için
- **Wiki**: Detaylı dokümantasyon

### 🏫 Eğitim Kurumları İçin
Eğitim kurumları için özel workshop ve training programları mevcuttur. İletişime geçin.

---

<div align="center">

### 🌟 Bu projeyi beğendiyseniz ⭐ vermeyi unutmayın!

**Happy Coding! 🚀**

*"En iyi öğrenme yolu, uygulayarak öğrenmektir."*

</div>

---

<p align="center">
  <sub>Son güncelleme: 2024 | Eğitim amaçlı olarak geliştirilmiştir | MIT Lisansı</sub>
</p> 