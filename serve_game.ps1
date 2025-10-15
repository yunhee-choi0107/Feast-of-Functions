<#
serve_game.ps1
Starts a simple HTTP server (Python) and prints URLs other players can use on the same local network.
Usage: Run this from the project folder in PowerShell:
  .\serve_game.ps1
Optional: pass a port number: .\serve_game.ps1 -Port 8000

Notes:
- Requires Python to be installed and on PATH.
- If you want to share publicly, use ngrok (https://ngrok.com)
#>

param(
    [int]$Port = 8000
)

# Ensure we're running from the script's folder
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $root

Write-Host "Serving folder: $root"
Write-Host "Port: $Port"

# Try to get IPv4 addresses
$ips = @()
try {
    $ips = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike '169.*' -and $_.IPAddress -ne '127.0.0.1' } | Select-Object -ExpandProperty IPAddress
} catch {
    # fallback to ipconfig parsing
    $ips = (ipconfig) | Select-String 'IPv4' | ForEach-Object { ($_ -split ':')[-1].Trim() }
}

# Filter out empty and loopback
$ips = $ips | Where-Object { $_ -and $_ -ne '127.0.0.1' } | Sort-Object -Unique

$escapedFile = [uri]::EscapeDataString('FINAL VERSION 2.0.html')

Write-Host "\nOpen these URLs from other devices on your local network:" -ForegroundColor Cyan
Write-Host "  http://localhost:$Port/$escapedFile"
foreach ($ip in $ips) {
    Write-Host "  http://$ip:$Port/$escapedFile"
}

Write-Host "\nIf you want to share this publicly over the Internet, install ngrok and run: ngrok http $Port" -ForegroundColor Yellow
Write-Host "Starting Python HTTP server... (Press Ctrl+C to stop)\n" -ForegroundColor Green

# Start Python's simple HTTP server binding to all interfaces
# This will run in the foreground; use Ctrl+C to stop.
python -m http.server $Port --bind 0.0.0.0

# Restore original location when server stops
Pop-Location
