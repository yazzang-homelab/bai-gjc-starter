@echo off
REM bai-gjc.cmd - Windows: run gjc with the B.AI starter profile (%USERPROFILE%\.gjc-bai\agent).
REM main + subagents = B.AI (one key: BAI_API_KEY). Bare `gjc` keeps using your normal profile.
REM GJC_CODING_AGENT_DIR moves only the user agent dir; project .gjc\ folders still load.
setlocal
if not defined BAI_API_KEY (
  echo BAI_API_KEY is not set. Get a key at https://chat.b.ai/chat then: 1>&2
  echo   setx BAI_API_KEY "sk-..."   ^(and open a new terminal^) 1>&2
  exit /b 1
)
if defined GJC_BAI_AGENT_DIR (set "GJC_CODING_AGENT_DIR=%GJC_BAI_AGENT_DIR%") else (set "GJC_CODING_AGENT_DIR=%USERPROFILE%\.gjc-bai\agent")
set "PI_CODING_AGENT_DIR="
set "GJC_CONFIG_DIR="
set "PI_CONFIG_DIR="
if not defined PI_STREAM_FIRST_EVENT_TIMEOUT_MS set "PI_STREAM_FIRST_EVENT_TIMEOUT_MS=300000"
if not defined PI_STREAM_IDLE_TIMEOUT_MS set "PI_STREAM_IDLE_TIMEOUT_MS=180000"
for /f "delims==" %%V in ('set ANTHROPIC_ 2^>nul') do set "%%V="
set "OPENAI_API_KEY="
set "OPENAI_BASE_URL="
set "OPENROUTER_API_KEY="
gjc %*
exit /b %ERRORLEVEL%
