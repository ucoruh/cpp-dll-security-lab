[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host "DLL Guvenlik Simulasyonu" -ForegroundColor Green
Write-Host ""

# Root klasörüne göre yol
$rootDir = $PSScriptRoot | Split-Path -Parent
$buildDir = Join-Path -Path $rootDir -ChildPath "build\bin\Debug"

# Build klasörüne git
if (Test-Path $buildDir) {
    Set-Location -Path $buildDir
    
    Write-Host "1. Normal DLL ile calistirma" -ForegroundColor Cyan
    Write-Host "-------------------------"
    Write-Host "Normal DLL ile matematik_client.exe calistirilacak..."
    Write-Host "Kapatmak icin mesaj kutusuna tiklayiniz..."
    Write-Host ""
    
    if (Test-Path "matematik_client.exe") {
        Start-Process -FilePath .\matematik_client.exe -Wait
        
        Write-Host ""
        Write-Host "2. Kotu niyetli DLL ile degistirme" -ForegroundColor Yellow
        Write-Host "---------------------------------"
        Write-Host "Orijinal DLL'i yedekliyoruz..."
        
        if (Test-Path "matematik.dll") {
            Copy-Item -Path .\matematik.dll -Destination .\matematik.dll.bak
            
            Write-Host "Kotu niyetli DLL'i matematik.dll olarak kopyaliyoruz..."
            if (Test-Path "malicious_matematik.dll") {
                Copy-Item -Path .\malicious_matematik.dll -Destination .\matematik.dll -Force
                
                Write-Host ""
                Write-Host "3. Kotu niyetli DLL ile calistirma" -ForegroundColor Red
                Write-Host "---------------------------------"
                Write-Host "Simdi kotu niyetli DLL ile matematik_client.exe calistirilacak..."
                Write-Host "DIKKAT: Mesaj kutulari goreceksiniz!" -ForegroundColor Red
                Write-Host "Kapatmak icin tum mesaj kutularina tiklayiniz..."
                Write-Host ""
                Start-Process -FilePath .\matematik_client.exe -Wait
                
                Write-Host ""
                Write-Host "4. Orijinal DLL'i geri yukleme" -ForegroundColor Cyan
                Write-Host "-----------------------------"
                Write-Host "Orijinal DLL'i geri yukluyoruz..."
                Copy-Item -Path .\matematik.dll.bak -Destination .\matematik.dll -Force
                Remove-Item -Path .\matematik.dll.bak
            } else {
                Write-Host "Hata: malicious_matematik.dll bulunamadi!" -ForegroundColor Red
            }
        } else {
            Write-Host "Hata: matematik.dll bulunamadi!" -ForegroundColor Red
        }
    } else {
        Write-Host "Hata: matematik_client.exe bulunamadi!" -ForegroundColor Red
    }
} else {
    Write-Host "Hata: Build klasörü bulunamadı: $buildDir" -ForegroundColor Red
}

Write-Host ""
Write-Host "Test tamamlandi!" -ForegroundColor Green
Write-Host ""
Write-Host "Cikmak icin herhangi bir tusa basin..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")