# DLL Guvenlik Simulasyonu
# Bu script egitim amacli DLL replacement saldirisini simule eder

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "DLL Guvenlik Simulasyonu" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
Write-Host ""

# Root klasorune gore yol
$rootDir = $PSScriptRoot | Split-Path -Parent
$buildDir = Join-Path -Path $rootDir -ChildPath "build-test\bin\Debug"

Write-Host "Build klasoru: $buildDir" -ForegroundColor Gray
Write-Host ""

# Build klasorune git
if (Test-Path $buildDir) {
    Set-Location -Path $buildDir
    
    Write-Host "1. Normal DLL ile Calistirma" -ForegroundColor Cyan
    Write-Host "-----------------------------" -ForegroundColor Cyan
    Write-Host "Normal matematik.dll ile matematik_client.exe calistirilacak..."
    Write-Host "Log dosyasini kontrol edin: matematik_dll_events.log"
    Write-Host ""
    
    if (Test-Path "matematik_client.exe") {
        Start-Process -FilePath .\matematik_client.exe -Wait
        
        Write-Host ""
        Write-Host "2. Kotu Niyetli DLL ile Degistirme" -ForegroundColor Yellow
        Write-Host "-----------------------------------" -ForegroundColor Yellow
        Write-Host "Orijinal DLL'i yedekliyoruz..."
        
        if (Test-Path "matematik.dll") {
            Copy-Item -Path .\matematik.dll -Destination .\matematik.dll.bak
            Write-Host "matematik.dll -> matematik.dll.bak"
            
            Write-Host "Kotu niyetli DLL'i matematik.dll olarak kopyaliyoruz..."
            if (Test-Path "malicious_matematik.dll") {
                Copy-Item -Path .\malicious_matematik.dll -Destination .\matematik.dll -Force
                Write-Host "malicious_matematik.dll -> matematik.dll"
                
                Write-Host ""
                Write-Host "3. Kotu Niyetli DLL ile Calistirma" -ForegroundColor Red
                Write-Host "-----------------------------------" -ForegroundColor Red
                Write-Host "DIKKAT: Simdi kotu niyetli DLL ile matematik_client.exe calistirilacak!" -ForegroundColor Red
                Write-Host "Guvenlik uyari mesajlari goreceksiniz!" -ForegroundColor Red
                Write-Host "Log dosyasini kontrol edin: malicious_dll_events.log"
                Write-Host "Tum mesaj kutularini kapatmak icin OK'e tiklayin..."
                Write-Host ""
                
                Start-Process -FilePath .\matematik_client.exe -Wait
                
                Write-Host ""
                Write-Host "4. Orijinal DLL'i Geri Yukleme" -ForegroundColor Cyan
                Write-Host "-------------------------------" -ForegroundColor Cyan
                Write-Host "Orijinal DLL'i geri yukluyoruz..."
                Copy-Item -Path .\matematik.dll.bak -Destination .\matematik.dll -Force
                Remove-Item -Path .\matematik.dll.bak
                Write-Host "matematik.dll.bak -> matematik.dll"
                Write-Host "Yedek dosya silindi"
            } else {
                Write-Host "Hata: malicious_matematik.dll bulunamadi!" -ForegroundColor Red
                Write-Host "Once 'cmake --build . --config Debug' komutunu calistirin" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Hata: matematik.dll bulunamadi!" -ForegroundColor Red
            Write-Host "Once 'cmake --build . --config Debug' komutunu calistirin" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Hata: matematik_client.exe bulunamadi!" -ForegroundColor Red
        Write-Host "Once 'cmake --build . --config Debug' komutunu calistirin" -ForegroundColor Yellow
    }
} else {
    Write-Host "Hata: Build klasoru bulunamadi: $buildDir" -ForegroundColor Red
    Write-Host "Once asagidaki komutlari calistirin:" -ForegroundColor Yellow
    Write-Host "   mkdir build-test" -ForegroundColor Gray
    Write-Host "   cd build-test" -ForegroundColor Gray
    Write-Host "   cmake .." -ForegroundColor Gray
    Write-Host "   cmake --build . --config Debug" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Simulasyon tamamlandi!" -ForegroundColor Green
Write-Host ""
Write-Host "Sonuclari Incelemek Icin:" -ForegroundColor Cyan
Write-Host "   matematik_dll_events.log - Normal DLL olaylari" -ForegroundColor Gray
Write-Host "   malicious_dll_events.log - Kotu niyetli DLL olaylari" -ForegroundColor Gray
Write-Host ""
Write-Host "Bu simulasyon sunlari gosterir:" -ForegroundColor Yellow
Write-Host "   DLL replacement saldirisinin nasil calistigi" -ForegroundColor Gray
Write-Host "   Ayni arayuze sahip farkli DLL'lerin nasil degistirilebildigi" -ForegroundColor Gray
Write-Host "   Statik kutuphanelerin bu saldiriya karsi nasil korundugu" -ForegroundColor Gray
Write-Host ""
Write-Host "Cikmak icin herhangi bir tusa basin..." -ForegroundColor White
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 