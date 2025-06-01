@echo off
chcp 65001 > nul
echo DLL Guvenlik Simulasyonu
echo.

rem Proje kök dizinini belirleme
set "ROOT_DIR=%~dp0.."
set "BUILD_DIR=%ROOT_DIR%\build\bin\Debug"

if exist "%BUILD_DIR%" (
    cd "%BUILD_DIR%"

    echo 1. Normal DLL ile calistirma
    echo -------------------------
    echo Normal DLL ile matematik_client.exe calistirilacak...
    echo Kapatmak icin mesaj kutusuna tiklayiniz...
    echo.
    
    if exist matematik_client.exe (
        matematik_client.exe

        echo.
        echo 2. Kotu niyetli DLL ile degistirme
        echo ---------------------------------
        echo Orijinal DLL'i yedekliyoruz...
        
        if exist matematik.dll (
            copy matematik.dll matematik.dll.bak

            echo Kotu niyetli DLL'i matematik.dll olarak kopyaliyoruz...
            
            if exist malicious_matematik.dll (
                copy malicious_matematik.dll matematik.dll

                echo.
                echo 3. Kotu niyetli DLL ile calistirma
                echo ---------------------------------
                echo Simdi kotu niyetli DLL ile matematik_client.exe calistirilacak...
                echo DIKKAT: Mesaj kutulari goreceksiniz!
                echo Kapatmak icin tum mesaj kutularina tiklayiniz...
                echo.
                matematik_client.exe

                echo.
                echo 4. Orijinal DLL'i geri yukleme
                echo -----------------------------
                echo Orijinal DLL'i geri yukluyoruz...
                copy matematik.dll.bak matematik.dll
                del matematik.dll.bak
            ) else (
                echo Hata: malicious_matematik.dll bulunamadi!
            )
        ) else (
            echo Hata: matematik.dll bulunamadi!
        )
    ) else (
        echo Hata: matematik_client.exe bulunamadi!
    )
) else (
    echo Hata: Build klasoru bulunamadi: %BUILD_DIR%
)

echo.
echo Test tamamlandi!
pause 