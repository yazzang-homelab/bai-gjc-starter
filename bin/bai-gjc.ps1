# bai-gjc.ps1 - Windows PowerShell: run gjc with the B.AI starter profile (~/.gjc-bai).
# main + subagents = B.AI (one key: BAI_API_KEY). Bare `gjc` keeps using your normal profile.
if (-not $env:BAI_API_KEY) {
  Write-Host 'BAI_API_KEY 가 비어 있습니다. https://chat.b.ai/chat 에서 키 발급 후:' -ForegroundColor Yellow
  Write-Host '  setx BAI_API_KEY "sk-..."   (그리고 터미널 새로 열기)'
  exit 1
}
$env:GJC_CONFIG_DIR = ".gjc-bai"
Remove-Item Env:GJC_CODING_AGENT_DIR,Env:PI_CODING_AGENT_DIR,Env:PI_CONFIG_DIR -ErrorAction SilentlyContinue
if (-not $env:PI_STREAM_FIRST_EVENT_TIMEOUT_MS) { $env:PI_STREAM_FIRST_EVENT_TIMEOUT_MS = "300000" }
if (-not $env:PI_STREAM_IDLE_TIMEOUT_MS) { $env:PI_STREAM_IDLE_TIMEOUT_MS = "180000" }
Remove-Item Env:ANTHROPIC_API_KEY,Env:ANTHROPIC_AUTH_TOKEN,Env:ANTHROPIC_OAUTH_TOKEN,Env:ANTHROPIC_BASE_URL,Env:OPENAI_API_KEY,Env:OPENROUTER_API_KEY -ErrorAction SilentlyContinue
gjc @args
