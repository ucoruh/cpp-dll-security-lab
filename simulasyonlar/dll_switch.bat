@echo off
chcp 65001 > nul
echo.
echo ===============================
echo 🛡️  DLL Güvenlik Simülasyonu
echo ===============================
echo.

rem Proje kök dizinini belirleme
set "ROOT_DIR=%~dp0.."
set "BUILD_DIR=%ROOT_DIR%\build-test\bin\Debug"

echo 📁 Build klasörü: %BUILD_DIR%
echo.

if exist "%BUILD_DIR%" (
    cd "%BUILD_DIR%"

    echo 1️⃣  Normal DLL ile Çalıştırma
    echo -----------------------------
    echo ✅ Normal matematik.dll ile matematik_client.exe çalıştırılacak...
    echo ℹ️  Log dosyasını kontrol edin: matematik_dll_events.log
    echo.
    
    if exist matematik_client.exe (
        matematik_client.exe

        echo.
        echo 2️⃣  Kötü Niyetli DLL ile Değiştirme
        echo -----------------------------------
        echo 💾 Orijinal DLL'i yedekliyoruz...
        
        if exist matematik.dll (
            copy matematik.dll matematik.dll.bak > nul
            echo ✅ matematik.dll -^> matematik.dll.bak

            echo 🦠 Kötü niyetli DLL'i matematik.dll olarak kopyalıyoruz...
            
            if exist malicious_matematik.dll (
                copy malicious_matematik.dll matematik.dll > nul
                echo ✅ malicious_matematik.dll -^> matematik.dll

                echo.
                echo 3️⃣  Kötü Niyetli DLL ile Çalıştırma
                echo -----------------------------------
                echo ⚠️  DIKKAT: Şimdi kötü niyetli DLL ile matematik_client.exe çalıştırılacak!
                echo 🚨 Güvenlik uyarı mesajları göreceksiniz!
                echo ℹ️  Log dosyasını kontrol edin: malicious_dll_events.log
                echo 👆 Tüm mesaj kutularını kapatmak için OK'e tıklayın...
                echo.
                matematik_client.exe

                echo.
                echo 4️⃣  Orijinal DLL'i Geri Yükleme
                echo -------------------------------
                echo 🔄 Orijinal DLL'i geri yüklüyoruz...
                copy matematik.dll.bak matematik.dll > nul
                del matematik.dll.bak
                echo ✅ matematik.dll.bak -^> matematik.dll
                echo 🗑️  Yedek dosya silindi
            ) else (
                echo ❌ Hata: malicious_matematik.dll bulunamadı!
                echo 💡 Önce 'cmake --build . --config Debug' komutunu çalıştırın
            )
        ) else (
            echo ❌ Hata: matematik.dll bulunamadı!
            echo 💡 Önce 'cmake --build . --config Debug' komutunu çalıştırın
        )
    ) else (
        echo ❌ Hata: matematik_client.exe bulunamadı!
        echo 💡 Önce 'cmake --build . --config Debug' komutunu çalıştırın
    )
) else (
    echo ❌ Hata: Build klasörü bulunamadı: %BUILD_DIR%
    echo 💡 Önce aşağıdaki komutları çalıştırın:
    echo    mkdir build-test
    echo    cd build-test
    echo    cmake ..
    echo    cmake --build . --config Debug
)

echo.
echo 🎉 Simülasyon tamamlandı!
echo.
echo 📊 Sonuçları İncelemek İçin:
echo    • matematik_dll_events.log - Normal DLL olayları
echo    • malicious_dll_events.log - Kötü niyetli DLL olayları
echo.
echo 🔍 Bu simülasyon şunları gösterir:
echo    • DLL replacement saldırısının nasıl çalıştığı
echo    • Aynı arayüze sahip farklı DLL'lerin nasıl değiştirilebildiği
echo    • Statik kütüphanelerin bu saldırıya karşı nasıl korunduğu
echo.
pause 