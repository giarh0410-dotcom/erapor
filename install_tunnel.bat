@echo off
echo ===================================================
echo   CLOUDFLARE TUNNEL AUTOMATIC SETUP FOR E-RAPOR
echo ===================================================
echo.
echo Menyiapkan Cloudflare Tunnel...
echo.

:: 1. Download cloudflared.exe jika belum ada
if not exist "%~dp0cloudflared.exe" (
    echo Mengunduh cloudflared.exe dari official repository...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe' -OutFile '%~dp0cloudflared.exe'"
    if errorlevel 1 (
        echo.
        echo Gagal mengunduh cloudflared.exe secara otomatis.
        echo Silakan unduh manual dari: https://github.com/cloudflare/cloudflared/releases
        echo Dan letakkan file cloudflared.exe di folder ini: %~dp0
        pause
        exit /b 1
    )
)

echo cloudflared.exe siap!
echo.

:: 2. Meminta token Cloudflare
set /p TOKEN="Masukkan Token Cloudflare Tunnel Anda: "
if "%TOKEN%"=="" (
    echo Token tidak boleh kosong!
    pause
    exit /b 1
)

:: 3. Menginstal Service (Membutuhkan Administrator)
echo Menginstal service Cloudflare Tunnel...
cd /d "%~dp0"
"%~dp0cloudflared.exe" service install %TOKEN%
if errorlevel 1 (
    echo.
    echo GAGAL menginstal service. 
    echo PASTIKAN Anda menjalankan file batch ini dengan klik kanan -> "Run as Administrator".
    pause
    exit /b 1
)

echo.
echo ===================================================
echo   CLOUDFLARE TUNNEL BERHASIL DIINSTAL!
echo ===================================================
echo.
pause
