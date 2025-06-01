[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "DLL Events Monitor"

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
    Write-ColoredText "===== $Title =====" "Cyan"
    Write-Host ""
}

function Remove-LogFile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    if (Test-Path $FilePath) {
        Remove-Item $FilePath -Force
        Write-ColoredText "Log dosyasi silindi: $FilePath" "Gray"
    }
}

function Wait-ForUser {
    Write-Host ""
    Write-ColoredText "Devam etmek icin bir tusa basin..." "Yellow"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host ""
}

# Root klasörüne göre yol
$rootDir = $PSScriptRoot | Split-Path -Parent
$buildDir = Join-Path -Path $rootDir -ChildPath "build\bin\Debug"

# Log dosyalarını temizle
if (Test-Path $buildDir) {
    Set-Location -Path $buildDir
    Remove-LogFile -FilePath "matematik_dll_events.log"
    Remove-LogFile -FilePath "malicious_dll_events.log"

    Clear-Host
    Write-ColoredText "DLL YASAM DONGUSU VE OLAY IZLEME SIMULASYONU" "Green"
    Write-ColoredText "------------------------------------------------" "Green"
    Write-Host ""
    Write-Host "Bu simulasyon, DLL'lerin nasil yuklendigini, kullanildigini ve kaldirildigini gosterir."
    Write-Host "Implisit ve explisit DLL yukleme teknikleri gosterilecektir."
    Write-Host "Ayrica kotuye kullanim ornegi icin DLL degistirme de gosterilecektir."
    Write-Host ""

    # BÖLÜM 1: İmplisit (Otomatik) DLL Yükleme
    Show-Header -Title "BOLUM 1: IMPLISIT (OTOMATIK) DLL YUKLEME"
    Write-Host "Implisit DLL yuklemede, program basladiginda DLL otomatik olarak yuklenir."
    Write-Host "Bu, Windows'un import table kullanarak yaptigi standart yontemdir."
    Write-Host ""
    Write-ColoredText "matematik_client.exe uygulamasi calistiriliyor..." "Yellow"
    Write-ColoredText "(Bu uygulama calismasi icin DLL'i otomatik olarak yukleyecek)" "Yellow"
    Wait-ForUser

    # Dosya kontrolü
    if (Test-Path "matematik_client.exe") {
        # matematik_client.exe çalıştır
        Start-Process -FilePath .\matematik_client.exe -Wait

        # Log dosyasını oku ve göster
        if (Test-Path "matematik_dll_events.log") {
            Show-Header -Title "matematik_dll_events.log ICERIGI"
            Get-Content "matematik_dll_events.log" | ForEach-Object {
                Write-ColoredText $_ "Magenta"
            }
        } else {
            Write-ColoredText "matematik_dll_events.log dosyasi bulunamadi!" "Red"
        }

        Wait-ForUser

        # BÖLÜM 2: Explisit (Programatik) DLL Yükleme
        Show-Header -Title "BOLUM 2: EXPLISIT (PROGRAMATIK) DLL YUKLEME"
        Write-Host "Explisit DLL yuklemede, uygulama LoadLibrary API'sini kullanarak"
        Write-Host "DLL'i istege bagli olarak yukler ve kaldirir."
        Write-Host ""
        Write-ColoredText "explicit_dll_loader.exe uygulamasi calistiriliyor..." "Yellow"
        Write-ColoredText "(Bu uygulama, DLL'i programatik olarak yukleyip kaldiracak)" "Yellow"
        Wait-ForUser

        # Dosya kontrolü
        if (Test-Path "explicit_dll_loader.exe") {
            # explicit_dll_loader.exe çalıştır
            Remove-LogFile -FilePath "matematik_dll_events.log"
            Start-Process -FilePath .\explicit_dll_loader.exe -Wait

            # Log dosyasını oku ve göster
            if (Test-Path "matematik_dll_events.log") {
                Show-Header -Title "matematik_dll_events.log ICERIGI"
                Get-Content "matematik_dll_events.log" | ForEach-Object {
                    Write-ColoredText $_ "Magenta"
                }
            } else {
                Write-ColoredText "matematik_dll_events.log dosyasi bulunamadi!" "Red"
            }

            Wait-ForUser

            # BÖLÜM 3: DLL Değişimi (Saldırı Simulasyonu)
            Show-Header -Title "BOLUM 3: DLL DEGISIMI (SALDIRI SIMULASYONU)"
            Write-Host "Bu bolumde, orijinal DLL'in kotu niyetli bir DLL ile degistirilmesi"
            Write-Host "durumunda ne olacagini gosterecegiz."
            Write-Host ""

            # Dosya kontrolü
            if (Test-Path "matematik.dll" -and Test-Path "malicious_matematik.dll") {
                Write-ColoredText "Orijinal DLL yedekleniyor..." "Yellow"
                Copy-Item -Path .\matematik.dll -Destination .\matematik.dll.original

                Write-ColoredText "DLL kotu niyetli versiyonu ile degistiriliyor..." "Red"
                Copy-Item -Path .\malicious_matematik.dll -Destination .\matematik.dll -Force

                Write-ColoredText "matematik_client.exe uygulamasi kotu niyetli DLL ile calistiriliyor..." "Red"
                Write-ColoredText "DİKKAT: Mesaj kutulari acilacaktir!" "Red"
                Wait-ForUser

                # matematik_client.exe tekrar çalıştır (kötü niyetli DLL ile)
                Remove-LogFile -FilePath "malicious_dll_events.log"
                Start-Process -FilePath .\matematik_client.exe -Wait

                # Log dosyasını oku ve göster
                if (Test-Path "malicious_dll_events.log") {
                    Show-Header -Title "malicious_dll_events.log ICERIGI"
                    Get-Content "malicious_dll_events.log" | ForEach-Object {
                        Write-ColoredText $_ "Red"
                    }
                } else {
                    Write-ColoredText "malicious_dll_events.log dosyasi bulunamadi!" "Red"
                }

                # Orijinal DLL'i geri yükle
                Write-ColoredText "Orijinal DLL geri yukleniyor..." "Green"
                Copy-Item -Path .\matematik.dll.original -Destination .\matematik.dll -Force
                Remove-Item -Path .\matematik.dll.original -Force
            } else {
                Write-ColoredText "Hata: matematik.dll veya malicious_matematik.dll bulunamadi!" "Red"
            }

            Wait-ForUser

            # BÖLÜM 4: Statik Bağlama (İmplisit vs Explisit Yükleme Karşılaştırması)
            Show-Header -Title "BOLUM 4: STATIK BAGLAMA VS DLL KARSILASTIRMASI"
            Write-Host "Statik baglama durumunda, kod dogrudan uygulamaya dahil edilir,"
            Write-Host "bu nedenle DLL degisimi gibi saldirilardan etkilenmez."
            Write-Host ""
            Write-ColoredText "matematik_static_client.exe uygulamasi calistiriliyor..." "Yellow"
            Write-ColoredText "(Bu uygulama, statik bagli kutuphaneleri kullandigi icin DLL yukleme eventi olmaz)" "Yellow"
            Wait-ForUser

            # Dosya kontrolü
            if (Test-Path "matematik_static_client.exe") {
                # matematik_static_client.exe çalıştır
                Start-Process -FilePath .\matematik_static_client.exe -Wait
            } else {
                Write-ColoredText "Hata: matematik_static_client.exe bulunamadi!" "Red"
            }
        } else {
            Write-ColoredText "Hata: explicit_dll_loader.exe bulunamadi!" "Red"
        }
    } else {
        Write-ColoredText "Hata: matematik_client.exe bulunamadi!" "Red"
    }
} else {
    Write-ColoredText "Hata: Build klasörü bulunamadı: $buildDir" "Red"
}

Show-Header -Title "SIMULASYON TAMAMLANDI"
Write-Host "Bu simulasyon boyunca, dinamik ve statik kutuphanelerin farkli"
Write-Host "yukleme mekanizmalarini ve DLL degisiminin etkilerini gordunuz."
Write-Host ""
Write-Host "Ozetlersek:"
Write-Host "1. Implisit Yukleme: Program basladiginda otomatik DLL yukleme"
Write-Host "2. Explisit Yukleme: Programin LoadLibrary/FreeLibrary API'lerini kullanmasi"
Write-Host "3. DLL Degisimi: Kotu niyetli DLL degistirildiginde guvenlik riskleri"
Write-Host "4. Statik Baglama: Kodun dogrudan programa dahil edilmesi, DLL degisiminden etkilenmez"
Write-Host ""
Write-ColoredText "Simulasyonu sonlandirmak icin bir tusa basin..." "Green"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 