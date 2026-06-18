$ErrorActionPreference = "Stop"

$BaseUrl = if ($env:BASE_URL) { $env:BASE_URL } else { "http://localhost:4010" }
$AuthHeader = "Authorization: Bearer test-token"

Write-Host "[Lab02] Testing Prism mock server at $BaseUrl"
Write-Host ""

Write-Host "[1/5] Happy path: GET /health"
curl.exe -i "$BaseUrl/health"
Write-Host "`n---"

Write-Host "[2/5] Happy path: POST /auth/login"
$loginBody = '{"username":"admin","password":"Password123!"}'
$loginBodyPath = Join-Path $env:TEMP 'lab02-login-body.json'
Set-Content -Path $loginBodyPath -Value $loginBody -NoNewline
curl.exe -i -X POST "$BaseUrl/auth/login" -H "Content-Type: application/json" --data-binary "@$loginBodyPath"
Remove-Item $loginBodyPath -Force
Write-Host "`n---"

Write-Host "[3/5] Happy path: POST /ingest"
$ingestBody = '{"sourceType":"access","eventId":"0196fb3d-4ad7-7d1e-9f49-5d5148d2babc","gateId":"GATE-01","cardId":"RFID-2026-001","direction":"IN","decision":"ALLOW","occurredAt":"2026-05-10T08:00:00Z"}'
$ingestBodyPath = Join-Path $env:TEMP 'lab02-ingest-body.json'
Set-Content -Path $ingestBodyPath -Value $ingestBody -NoNewline
curl.exe -i -X POST "$BaseUrl/ingest" -H $AuthHeader -H "Content-Type: application/json" --data-binary "@$ingestBodyPath"
Remove-Item $ingestBodyPath -Force
Write-Host "`n---"

Write-Host "[4/5] Happy path: GET /analytics/summary"
curl.exe -i "$BaseUrl/analytics/summary?fromDate=2026-05-01&toDate=2026-05-12&granularity=day" -H $AuthHeader
Write-Host "`n---"

Write-Host "[5/5] Error case: POST /auth/login invalid payload"
$invalidLogin = '{"username":"admin"}'
$invalidLoginPath = Join-Path $env:TEMP 'lab02-login-invalid-body.json'
Set-Content -Path $invalidLoginPath -Value $invalidLogin -NoNewline
curl.exe -i -X POST "$BaseUrl/auth/login" -H "Content-Type: application/json" --data-binary "@$invalidLoginPath"
Remove-Item $invalidLoginPath -Force
Write-Host ""
