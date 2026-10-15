# bai-gjc.ps1 - Windows PowerShell: run gjc with the B.AI starter profile (~/.gjc-bai/agent).
# main + subagents = B.AI (one key: BAI_API_KEY). Bare `gjc` keeps using your normal profile.
# GJC_CODING_AGENT_DIR moves only the user agent dir; project `.gjc/` folders still load.
if (-not $env:BAI_API_KEY) {
  Write-Host 'BAI_API_KEY 가 비어 있습니다. https://chat.b.ai/chat 에서 키 발급 후:' -ForegroundColor Yellow
  Write-Host '  setx BAI_API_KEY "sk-..."   (그리고 터미널 새로 열기)'
  exit 1
}
$env:GJC_CODING_AGENT_DIR = if ($env:GJC_BAI_AGENT_DIR) { $env:GJC_BAI_AGENT_DIR } else { Join-Path $env:USERPROFILE ".gjc-bai\agent" }
Remove-Item Env:PI_CODING_AGENT_DIR,Env:GJC_CONFIG_DIR,Env:PI_CONFIG_DIR -ErrorAction SilentlyContinue
if (-not $env:PI_STREAM_FIRST_EVENT_TIMEOUT_MS) { $env:PI_STREAM_FIRST_EVENT_TIMEOUT_MS = "300000" }
if (-not $env:PI_STREAM_IDLE_TIMEOUT_MS) { $env:PI_STREAM_IDLE_TIMEOUT_MS = "180000" }
Get-ChildItem Env: | Where-Object { $_.Name -like "ANTHROPIC_*" } | ForEach-Object { Remove-Item "Env:$($_.Name)" }
Remove-Item Env:OPENAI_API_KEY,Env:OPENAI_BASE_URL,Env:OPENROUTER_API_KEY -ErrorAction SilentlyContinue
gjc @args
exit $LASTEXITCODE
