# bai-gjc-starter installer (Windows).
# Places the B.AI profile at %USERPROFILE%\.gjc-bai\agent and bai-gjc.cmd on PATH.
# Installs NO keys — you provide BAI_API_KEY yourself (see README).
#
#   powershell -ExecutionPolicy Bypass -File .\install.ps1          # 기존 설정 유지
#   powershell -ExecutionPolicy Bypass -File .\install.ps1 -Force   # 백업 후 새 설정으로 교체
param([switch]$Force)
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

if (-not (Get-Command gjc -ErrorAction SilentlyContinue)) {
    Write-Host "gjc 가 없습니다. 먼저 설치하세요:" -ForegroundColor Yellow
    Write-Host '  powershell -c "irm bun.sh/install.ps1|iex"'
    Write-Host "  bun install -g gajae-code"
    exit 1
}

$agent = Join-Path $env:USERPROFILE ".gjc-bai\agent"
New-Item -ItemType Directory -Force -Path $agent | Out-Null
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$script:kept = $false

# 대상이 있으면 유지(-Force면 .bak-<시각> 백업 후 교체)
function Place($src, $dst) {
    if ((Test-Path $dst) -and -not $Force) {
        Write-Host "기존 설정 유지: $dst"
        $script:kept = $true
        return
    }
    if (Test-Path $dst) {
        Move-Item $dst "$dst.bak-$stamp"
        Write-Host "백업: $dst.bak-$stamp"
    }
    Copy-Item $src $dst
}

Place (Join-Path $here "agent\config.yml") (Join-Path $agent "config.yml")
Place (Join-Path $here "agent\models.yml") (Join-Path $agent "models.yml")

$cfgs = @((Join-Path $agent "config.yml"), (Join-Path $agent "models.yml")) | Where-Object { Test-Path $_ }
if ($cfgs -and (Select-String -Path $cfgs -Pattern 'fallbackChains|deepseek-v4-flash|qwen3\.8-max|minimax-m3' -Quiet)) {
    Write-Host "  예전 버전 설정입니다(옛 할인율/폴백 형식). install.ps1 -Force 로 교체하세요." -ForegroundColor Yellow
} elseif ($script:kept) {
    Write-Host "  (새 설정으로 바꾸려면 -Force)"
}

$binDst = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps"
Copy-Item (Join-Path $here "bin\bai-gjc.cmd") (Join-Path $binDst "bai-gjc.cmd") -Force

Write-Host ""
Write-Host "설치 완료. B.AI 프로필 -> $agent, 런처 -> bai-gjc.cmd" -ForegroundColor Green
Write-Host "남은 건 키 하나:"
Write-Host '  1) https://chat.b.ai/chat?invite_code=9MVP9L 가입 -> 충전 -> API Key 발급'
Write-Host '  2) setx BAI_API_KEY "sk-..."   (그리고 터미널 새로 열기)'
Write-Host '  3) bai-gjc -p --no-session "누구니?"'
