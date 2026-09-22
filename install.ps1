# bai-gjc-starter installer (Windows).
# Places the B.AI profile at %USERPROFILE%\.gjc-bai and bai-gjc.cmd on PATH.
# Installs NO keys — you provide BAI_API_KEY yourself (see README).
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$U = $env:USERPROFILE

if (-not (Get-Command gjc -ErrorAction SilentlyContinue)) {
    Write-Host "gjc 가 없습니다. 먼저 설치하세요:" -ForegroundColor Yellow
    Write-Host '  powershell -c "irm bun.sh/install.ps1|iex"'
    Write-Host "  bun install -g gajae-code"
    exit 1
}

New-Item -ItemType Directory -Force -Path "$U\.gjc-bai\agent" | Out-Null
Copy-Item "$here\agent\config.yml" "$U\.gjc-bai\agent\config.yml" -Force
Copy-Item "$here\agent\models.yml" "$U\.gjc-bai\agent\models.yml" -Force

$binDst = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
Copy-Item "$here\bin\bai-gjc.cmd" "$binDst\bai-gjc.cmd" -Force

Write-Host ""
Write-Host "설치 완료. B.AI 프로필 -> ~/.gjc-bai, 런처 -> bai-gjc.cmd" -ForegroundColor Green
Write-Host "남은 건 키 하나:"
Write-Host '  1) https://chat.b.ai/chat?invite_code=9MVP9L 가입 -> 충전 -> API Key 발급'
Write-Host '  2) setx BAI_API_KEY "sk-..."   (그리고 터미널 새로 열기)'
Write-Host '  3) bai-gjc -p --no-session "누구니?"'
