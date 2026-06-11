# SUBVERTER local launcher
# Serves this folder on http://localhost so Chrome grants the Web MIDI permission
# (the DDJ-200 doesn't work from file://), then opens your default browser.
# No Python, no install, no admin rights — a plain TCP listener on 127.0.0.1.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# find a free port starting at 8421
$port = 8421
$listener = $null
while (-not $listener) {
  try {
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $port)
    $listener.Start()
  } catch {
    $listener = $null; $port++
    if ($port -gt 8470) { Write-Host 'No free port found (tried 8421-8470).'; exit 1 }
  }
}
$url = "http://localhost:$port/"
Write-Host ''
Write-Host "  SUBVERTER is live at $url" -ForegroundColor Green
Write-Host '  Web MIDI (DDJ-200) works on this address — click "Connect MIDI" in the app.'
Write-Host '  Keep this window open while you play. Close it to stop the server.'
Write-Host ''
Start-Process $url

$mime = @{
  '.html'='text/html; charset=utf-8'; '.htm'='text/html; charset=utf-8'
  '.js'='text/javascript'; '.css'='text/css'; '.json'='application/json'
  '.png'='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.gif'='image/gif'
  '.svg'='image/svg+xml'; '.ico'='image/x-icon'; '.md'='text/plain; charset=utf-8'; '.txt'='text/plain; charset=utf-8'
  '.mp3'='audio/mpeg'; '.wav'='audio/wav'; '.ogg'='audio/ogg'; '.oga'='audio/ogg'; '.opus'='audio/ogg'
  '.m4a'='audio/mp4'; '.aac'='audio/aac'; '.flac'='audio/flac'; '.webm'='audio/webm'
}

while ($true) {
  try {
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    $reader = New-Object System.IO.StreamReader($stream)
    $req = $reader.ReadLine()
    while (($l = $reader.ReadLine()) -and $l -ne '') { }   # drain request headers

    $path = '/'
    if ($req -match '^GET\s+(\S+)') { $path = [Uri]::UnescapeDataString(($Matches[1] -split '\?')[0]) }
    if ($path -eq '/') { $path = '/index.html' }
    $file = Join-Path $root ($path -replace '/', '\')
    $full = [IO.Path]::GetFullPath($file)
    $rootFull = [IO.Path]::GetFullPath($root)

    if ($full.StartsWith($rootFull, [StringComparison]::OrdinalIgnoreCase) -and (Test-Path $full -PathType Leaf)) {
      $bytes = [IO.File]::ReadAllBytes($full)
      $ext = [IO.Path]::GetExtension($full).ToLower()
      $ct = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' }
      $hdr = "HTTP/1.1 200 OK`r`nContent-Type: $ct`r`nContent-Length: $($bytes.Length)`r`nCache-Control: no-cache`r`nConnection: close`r`n`r`n"
      $hb = [Text.Encoding]::ASCII.GetBytes($hdr)
      $stream.Write($hb, 0, $hb.Length); $stream.Write($bytes, 0, $bytes.Length)
    } else {
      $body = [Text.Encoding]::UTF8.GetBytes('404 — not found')
      $hdr = "HTTP/1.1 404 Not Found`r`nContent-Type: text/plain`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
      $hb = [Text.Encoding]::ASCII.GetBytes($hdr)
      $stream.Write($hb, 0, $hb.Length); $stream.Write($body, 0, $body.Length)
    }
    $stream.Flush(); $client.Close()
  } catch { }
}
