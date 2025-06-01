# DLL Yaşam Döngüsü ve Olay İzleme Simülasyonu
# Bu script eğitim amaçlı DLL yaşam döngüsü olaylarını gösterir

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "🔍 DLL Events Monitor"

function Write-ColoredText {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text,
        [Parameter(Mandatory=$true)]
        [System.ConsoleColor]$ForegroundColor
    )
    
    $origFg = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $ForegroundColor
    Write-Host $Text
    $Host.UI.RawUI.ForegroundColor = $origFg
}

function Show-Header {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    
    Write-Host ""
    Write-ColoredText "🔹 $Title" "Cyan"
    Write-ColoredText ("=" * ($Title.Length + 3)) "Cyan"
    Write-Host ""
}

function Remove-LogFile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    if (Test-Path $FilePath) {
        Remove-Item $FilePath -Force
        Write-ColoredText "🗑️  Log dosyası silindi: $FilePath" "Gray"
    }
}

function Wait-ForUser {
    Write-Host ""
    Write-ColoredText "⏸️  Devam etmek için bir tuşa basın..." "Yellow"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host ""
}

# Root klasörüne göre yol
$rootDir = $PSScriptRoot | Split-Path -Parent
$buildDir = Join-Path -Path $rootDir -ChildPath "build-test\bin\Debug"

Write-Host "📁 Build klasörü: $buildDir" -ForegroundColor Gray
Write-Host ""

# Log dosyalarını temizle
if (Test-Path $buildDir) {
    Set-Location -Path $buildDir
    Remove-LogFile -FilePath "matematik_dll_events.log"
    Remove-LogFile -FilePath "malicious_dll_events.log"

    Clear-Host
    Write-ColoredText "🔍 DLL YAŞAM DÖNGÜSÜ VE OLAY İZLEME SİMÜLASYONU" "Green"
    Write-ColoredText "=================================================" "Green"
    Write-Host ""
    Write-Host "📚 Bu simülasyon, DLL'lerin nasıl yüklendiğini, kullanıldığını ve kaldırıldığını gösterir."
    Write-Host "🔄 İmplisit ve eksplisit DLL yükleme teknikleri gösterilecektir."
    Write-Host "⚠️  Ayrıca kötüye kullanım örneği için DLL değiştirme de gösterilecektir."
    Write-Host ""

    # BÖLÜM 1: İmplisit (Otomatik) DLL Yükleme
    Show-Header -Title "BÖLÜM 1: İMPLİSİT (OTOMATİK) DLL YÜKLEME"
    Write-Host "📖 İmplisit DLL yüklemede, program başladığında DLL otomatik olarak yüklenir."
    Write-Host "🔧 Bu, Windows'un import table kullanarak yaptığı standart yöntemdir."
    Write-Host ""
    Write-ColoredText "🚀 matematik_client.exe uygulaması çalıştırılıyor..." "Yellow"
    Write-ColoredText "   (Bu uygulama çalışması için DLL'i otomatik olarak yükleyecek)" "Yellow"
    Wait-ForUser

    # Dosya kontrolü
    if (Test-Path "matematik_client.exe") {
        # matematik_client.exe çalıştır
        Start-Process -FilePath .\matematik_client.exe -Wait

        # Log dosyasını oku ve göster
        if (Test-Path "matematik_dll_events.log") {
            Show-Header -Title "📄 matematik_dll_events.log İÇERİĞİ"
            Get-Content "matematik_dll_events.log" | ForEach-Object {
                Write-ColoredText "   $_" "Magenta"
            }
        } else {
            Write-ColoredText "❌ matematik_dll_events.log dosyası bulunamadı!" "Red"
        }

        Wait-ForUser

        # BÖLÜM 2: Explisit (Programatik) DLL Yükleme
        Show-Header -Title "BÖLÜM 2: EKSPLİSİT (PROGRAMATİK) DLL YÜKLEME"
        Write-Host "📖 Eksplisit DLL yüklemede, uygulama LoadLibrary API'sini kullanarak"
        Write-Host "   DLL'i isteğe bağlı olarak yükler ve kaldırır."
        Write-Host ""
        Write-ColoredText "🚀 explicit_dll_loader.exe uygulaması çalıştırılıyor..." "Yellow"
        Write-ColoredText "   (Bu uygulama, DLL'i programatik olarak yükleyip kaldıracak)" "Yellow"
        Wait-ForUser

        # Dosya kontrolü
        if (Test-Path "explicit_dll_loader.exe") {
            # explicit_dll_loader.exe çalıştır
            Remove-LogFile -FilePath "matematik_dll_events.log"
            Start-Process -FilePath .\explicit_dll_loader.exe -Wait

            # Log dosyasını oku ve göster
            if (Test-Path "matematik_dll_events.log") {
                Show-Header -Title "📄 matematik_dll_events.log İÇERİĞİ"
                Get-Content "matematik_dll_events.log" | ForEach-Object {
                    Write-ColoredText "   $_" "Magenta"
                }
            } else {
                Write-ColoredText "❌ matematik_dll_events.log dosyası bulunamadı!" "Red"
            }

            Wait-ForUser

            # BÖLÜM 3: DLL Değişimi (Saldırı Simulasyonu)
            Show-Header -Title "BÖLÜM 3: DLL DEĞİŞİMİ (SALDIRI SİMÜLASYONU)"
            Write-Host "📖 Bu bölümde, orijinal DLL'in kötü niyetli bir DLL ile değiştirilmesi"
            Write-Host "   durumunda ne olacağını göstereceğiz."
            Write-Host ""

            # Dosya kontrolü
            if (Test-Path "matematik.dll" -and Test-Path "malicious_matematik.dll") {
                Write-ColoredText "💾 Orijinal DLL yedekleniyor..." "Yellow"
                Copy-Item -Path .\matematik.dll -Destination .\matematik.dll.original

                Write-ColoredText "🦠 DLL kötü niyetli versiyonu ile değiştiriliyor..." "Red"
                Copy-Item -Path .\malicious_matematik.dll -Destination .\matematik.dll -Force

                Write-ColoredText "🚀 matematik_client.exe uygulaması kötü niyetli DLL ile çalıştırılıyor..." "Red"
                Write-ColoredText "⚠️  DİKKAT: Güvenlik uyarı mesajları açılacaktır!" "Red"
                Wait-ForUser

                # matematik_client.exe tekrar çalıştır (kötü niyetli DLL ile)
                Remove-LogFile -FilePath "malicious_dll_events.log"
                Start-Process -FilePath .\matematik_client.exe -Wait

                # Log dosyasını oku ve göster
                if (Test-Path "malicious_dll_events.log") {
                    Show-Header -Title "📄 malicious_dll_events.log İÇERİĞİ"
                    Get-Content "malicious_dll_events.log" | ForEach-Object {
                        Write-ColoredText "   $_" "Red"
                    }
                } else {
                    Write-ColoredText "❌ malicious_dll_events.log dosyası bulunamadı!" "Red"
                }

                # Orijinal DLL'i geri yükle
                Write-ColoredText "🔄 Orijinal DLL geri yükleniyor..." "Green"
                Copy-Item -Path .\matematik.dll.original -Destination .\matematik.dll -Force
                Remove-Item -Path .\matematik.dll.original -Force
            } else {
                Write-ColoredText "❌ Hata: matematik.dll veya malicious_matematik.dll bulunamadı!" "Red"
                Write-ColoredText "💡 Önce 'cmake --build . --config Debug' komutunu çalıştırın" "Yellow"
            }

            Wait-ForUser

            # BÖLÜM 4: Statik Bağlama (İmplisit vs Explisit Yükleme Karşılaştırması)
            Show-Header -Title "BÖLÜM 4: STATİK BAĞLAMA VS DLL KARŞILAŞTIRMASI"
            Write-Host "📖 Statik bağlama durumunda, kod doğrudan uygulamaya dahil edilir,"
            Write-Host "   bu nedenle DLL değişimi gibi saldırılardan etkilenmez."
            Write-Host ""
            Write-ColoredText "🚀 matematik_static_client.exe uygulaması çalıştırılıyor..." "Yellow"
            Write-ColoredText "   (Bu uygulama, statik bağlı kütüphaneleri kullandığı için DLL yükleme eventi olmaz)" "Yellow"
            Wait-ForUser

            # Dosya kontrolü
            if (Test-Path "matematik_static_client.exe") {
                # matematik_static_client.exe çalıştır
                Start-Process -FilePath .\matematik_static_client.exe -Wait
            } else {
                Write-ColoredText "❌ Hata: matematik_static_client.exe bulunamadı!" "Red"
                Write-ColoredText "💡 Önce 'cmake --build . --config Debug' komutunu çalıştırın" "Yellow"
            }
        } else {
            Write-ColoredText "❌ Hata: explicit_dll_loader.exe bulunamadı!" "Red"
            Write-ColoredText "💡 Önce 'cmake --build . --config Debug' komutunu çalıştırın" "Yellow"
        }
    } else {
        Write-ColoredText "❌ Hata: matematik_client.exe bulunamadı!" "Red"
        Write-ColoredText "💡 Önce 'cmake --build . --config Debug' komutunu çalıştırın" "Yellow"
    }
} else {
    Write-ColoredText "❌ Hata: Build klasörü bulunamadı: $buildDir" "Red"
    Write-ColoredText "💡 Önce aşağıdaki komutları çalıştırın:" "Yellow"
    Write-ColoredText "   mkdir build-test" "Gray"
    Write-ColoredText "   cd build-test" "Gray"
    Write-ColoredText "   cmake .." "Gray"
    Write-ColoredText "   cmake --build . --config Debug" "Gray"
}

Show-Header -Title "🎉 SİMÜLASYON TAMAMLANDI"
Write-Host "📚 Bu simülasyon boyunca, dinamik ve statik kütüphanelerin farklı"
Write-Host "   yükleme mekanizmalarını ve DLL değişiminin etkilerini gördünüz."
Write-Host ""
Write-Host "📋 Özetlersek:"
Write-Host "   1️⃣  İmplisit Yükleme: Program başladığında otomatik DLL yükleme"
Write-Host "   2️⃣  Eksplisit Yükleme: Programın LoadLibrary/FreeLibrary API'lerini kullanması"
Write-Host "   3️⃣  DLL Değişimi: Kötü niyetli DLL değiştirildiğinde güvenlik riskleri"
Write-Host "   4️⃣  Statik Bağlama: Kodun doğrudan programa dahil edilmesi, DLL değişiminden etkilenmez"
Write-Host ""
Write-ColoredText "🚪 Simülasyonu sonlandırmak için bir tuşa basın..." "Green"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 