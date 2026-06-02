# Self-elevate to Administrator if not already running as Admin
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $myWindowsPrincipal.IsInRole($adminRole)) {
    Write-Host "Membuka jendela PowerShell Administrator baru..." -ForegroundColor Yellow
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $newProcess.Verb = "runas"
    [System.Diagnostics.Process]::Start($newProcess) | Out-Null
    Exit
}

Clear-Host
Write-Host "===================================================" -ForegroundColor Green
Write-Host "   PENGATURAN OTOMATIS CLOUDFLARE TUNNEL E-RAPOR   " -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
Write-Host ""

# 1. Cek / Download cloudflared.exe
$cloudflaredPath = "cloudflared"
try {
    Get-Command "cloudflared" -ErrorAction Stop | Out-Null
    Write-Host "[OK] cloudflared terdeteksi di system PATH." -ForegroundColor Green
} catch {
    $cloudflaredPath = "$PSScriptRoot\cloudflared.exe"
    if (-not (Test-Path $cloudflaredPath)) {
        Write-Host "Mengunduh cloudflared.exe dari repository resmi Cloudflare..." -ForegroundColor Cyan
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        try {
            Invoke-WebRequest -Uri "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe" -OutFile $cloudflaredPath
            Write-Host "[OK] Berhasil mengunduh cloudflared.exe." -ForegroundColor Green
        } catch {
            Write-Host "[ERROR] Gagal mengunduh cloudflared.exe secara otomatis." -ForegroundColor Red
            Write-Host "Silakan unduh manual dari: https://github.com/cloudflare/cloudflared/releases" -ForegroundColor Yellow
            Write-Host "Dan simpan file cloudflared.exe ke: $PSScriptRoot" -ForegroundColor Yellow
            Read-Host "Tekan Enter untuk keluar..."
            Exit
        }
    }
}

# 2. Input Token dari User
Write-Host ""
$token = Read-Host "Masukkan Token Cloudflare Tunnel Anda (dapatkan dari Dashboard Cloudflare)"
$token = $token.Trim()

if ([string]::IsNullOrEmpty($token)) {
    Write-Host "[ERROR] Token tidak boleh kosong!" -ForegroundColor Red
    Read-Host "Tekan Enter untuk keluar..."
    Exit
}

# 3. Hapus service lama jika ada (agar tidak konflik)
Write-Host ""
Write-Host "Memeriksa service lama..." -ForegroundColor Cyan
$oldService = Get-Service -Name "cloudflared" -ErrorAction SilentlyContinue
if ($oldService) {
    Write-Host "Menghentikan dan menghapus service lama..." -ForegroundColor Yellow
    Stop-Service -Name "cloudflared" -Force -ErrorAction SilentlyContinue
    sc.exe delete "cloudflared" | Out-Null
    Start-Sleep -Seconds 2
}

# 4. Instal Service Baru
Write-Host "Menginstal service Cloudflare Tunnel dengan token baru..." -ForegroundColor Cyan
if ($cloudflaredPath -eq "cloudflared") {
    $cmd = "cloudflared service install $token"
} else {
    $cmd = "& `"$cloudflaredPath`" service install $token"
}

Invoke-Expression $cmd

# 5. Jalankan Service
Write-Host "Menjalankan service..." -ForegroundColor Cyan
Start-Sleep -Seconds 2
Start-Service -Name "cloudflared" -ErrorAction SilentlyContinue

# 6. Verifikasi
$serviceStatus = Get-Service -Name "cloudflared" -ErrorAction SilentlyContinue
if ($serviceStatus -and $serviceStatus.Status -eq "Running") {
    Write-Host ""
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "  SUKSES: Cloudflare Tunnel Berhasil Dijalankan!   " -ForegroundColor Green
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "Silakan periksa halaman Dashboard Cloudflare Anda," -ForegroundColor White
    Write-Host "status tunnel harus berubah menjadi 'Healthy' (Hijau)." -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[ERROR] Service berhasil diinstal tapi gagal berjalan secara otomatis." -ForegroundColor Red
    Write-Host "Silakan jalankan manual lewat 'services.msc' atau ketik: Start-Service cloudflared" -ForegroundColor Yellow
    Write-Host ""
}

Read-Host "Tekan Enter untuk selesai..."
