@echo off
REM bai-gjc.cmd - Windows: run gjc with the B.AI starter profile (%USERPROFILE%\.gjc-bai).
REM main + subagents = B.AI (one key: BAI_API_KEY). Bare `gjc` keeps using your normal profile.
setlocal
if not defined BAI_API_KEY (
  echo BAI_API_KEY 가 비어 있습니다. https://chat.b.ai/chat 에서 키 발급 후:
  echo   setx BAI_API_KEY "sk-..."   ^(그리고 터미널 새로 열기^)
  exit /b 1
)
set "GJC_CONFIG_DIR=.gjc-bai"
set "GJC_CODING_AGENT_DIR="
set "PI_CODING_AGENT_DIR="
set "PI_CONFIG_DIR="
if not defined PI_STREAM_FIRST_EVENT_TIMEOUT_MS set "PI_STREAM_FIRST_EVENT_TIMEOUT_MS=300000"
if not defined PI_STREAM_IDLE_TIMEOUT_MS set "PI_STREAM_IDLE_TIMEOUT_MS=180000"
set "ANTHROPIC_API_KEY="
set "ANTHROPIC_AUTH_TOKEN="
set "ANTHROPIC_OAUTH_TOKEN="
set "ANTHROPIC_BASE_URL="
set "OPENAI_API_KEY="
set "OPENROUTER_API_KEY="
gjc %*
