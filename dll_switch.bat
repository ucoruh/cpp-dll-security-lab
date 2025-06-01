@echo off
chcp 65001 > nul
echo DLL Guvenlik Simulasyonu
echo.

cd build\bin\Release

echo 1. Normal DLL ile calistirma
echo -------------------------
echo Normal DLL ile matematik_client.exe calistirilacak...
echo Kapatmak icin mesaj kutusuna tiklayiniz...
echo.
matematik_client.exe

echo.
echo 2. Kotu niyetli DLL ile degistirme
echo ---------------------------------
echo Orijinal DLL'i yedekliyoruz...
copy matematik.dll matematik.dll.bak

echo Kotu niyetli DLL'i matematik.dll olarak kopyaliyoruz...
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

echo.
echo Test tamamlandi!
pause 