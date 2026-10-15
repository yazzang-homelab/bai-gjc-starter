# bai-gjc-starter

**B.AI 키 하나로 gjc(gajae-code) 메인 + 서브에이전트 전부 돌리는 저가 세팅.**
기본값은 2026-10-15 기준 할인 모델(MiMo-V2.6-Flash 90%·Qwen3.8-Flash 70%·MiMo-V2.6-Pro 50%·DeepSeek-V4.1-Flash 40%).

👉 **그림 포함 왕초보 가이드: <https://yazzang-homelab.github.io/bai-gjc-starter/guide.html>**

> 🤖 이 repo와 가이드는 **전부 무료 AI가 작성**했습니다 — 형제 프로젝트 [free-gjc-starter](https://github.com/yazzang-homelab/free-gjc-starter)(무료 Gemini + 무료 서브에이전트) 세팅의 gjc가 B.AI 공식 문서를 읽고 설정·런처·문서를 만들었습니다.

## 지금 B.AI 할인 (2026-10-15 기준)

9월 말~10월 초에 할인율이 크게 바뀌었습니다. **예전 "3종 전부 90% 할인"은 끝났습니다.**

| 모델 | 지금 할인 | 예전(9/22) | 할인 후 단가 (입력 / 출력, USD·1M 토큰) |
|---|---|---|---|
| MiMo-V2.6-Flash | **90%** (9/25~) | — | $0.014 / $0.028 |
| Qwen3.8-Flash | **70%** (9/25~) | 90% | $0.048 / $0.141 |
| MiMo-V2.6-Pro | **50%** (9/25~) | — | $0.2175 / $0.435 |
| DeepSeek-V4.1-Flash | **40%** (10/4~) | 90% | $0.18 / $0.72 (피크) · 비피크는 절반 |
| GLM-5.3-Flash | **30%** (10/4~) | 90% | $0.105 / $0.35 |
| GLM-5.3 | 10% | 10% | $1.26 / $3.96 |

출처: <https://docs.b.ai/llmservice/promotions-and-pricing-notices/> · 실제 청구는 B.AI 화면 기준. 사이트 배너 기준 충전 보너스 이벤트(최대 $100)가 진행 중이며 조건은 **Top up** 화면에서 확인하세요.

가입: **<https://chat.b.ai/chat?invite_code=9MVP9L>** (작성자 레퍼럴 — 가입자 손해 없음. 싫으면 `https://chat.b.ai/chat`)

## 빠른 설치

```bash
# 1) gjc 없으면
curl -fsSL https://bun.sh/install | bash && bun install -g gajae-code
# 2) 이 세팅
git clone https://github.com/yazzang-homelab/bai-gjc-starter.git
cd bai-gjc-starter && bash install.sh            # Windows: powershell -ExecutionPolicy Bypass -File .\install.ps1
# 3) 키 (B.AI 웹 → API Key → Create)
export BAI_API_KEY="sk-..."                      # Windows: setx BAI_API_KEY "sk-..."
# 4) 확인
bai-gjc -p --no-session "누구니?"
```

기존 `gjc` / `free-gjc`와 완전히 분리(`~/.gjc-bai/agent`)되어 충돌 없음. 프로젝트 폴더의 `.gjc/` 스킬·설정은 그대로 읽습니다.

### 예전에 설치한 분 (업데이트)

설치 스크립트는 이미 있는 `config.yml`·`models.yml`을 **덮어쓰지 않습니다.** 새 할인율 배치로 바꾸려면:

```bash
cd bai-gjc-starter && git pull
bash install.sh --force                          # Windows: powershell -ExecutionPolicy Bypass -File .\install.ps1 -Force
```

기존 파일은 `*.bak-<날짜시각>`으로 백업됩니다. 예전 설정을 그대로 두면 90% 할인이 끝난 모델(DeepSeek·GLM-5.3-Flash·Qwen)을 계속 씁니다. gjc 본체는 평소대로 `gjc update`로 올리면 `bai-gjc`도 같이 올라갑니다.

## 기본 모델 배치

| 역할 | 1순위 | 막히면 → |
|---|---|---|
| default · architect | `bai/mimo-v2.6-pro` (50%) | `bai/deepseek-v4.1-flash` (40%) → `bai/mimo-v2.6-flash` (default만) |
| executor | `bai/mimo-v2.6-flash` (90%) | `bai/qwen3.8-flash` (70%) → `bai/glm-5.3-flash` (30%) |
| planner · critic | `bai/qwen3.8-flash` (70%) | `bai/mimo-v2.6-flash` (90%) |

목록이 곧 폴백 순서입니다. 1순위가 오류·과부하면 다음 모델로 자동 전환됩니다. 메인을 DeepSeek으로 쓰고 싶으면 `~/.gjc-bai/agent/config.yml`의 `default:` 목록에서 순서만 바꾸세요. DeepSeek은 **비피크 시간(한국 평일 10–13시·15–19시 외, 주말)** 에 쓰면 위 단가의 절반입니다.

`models.yml`에 넣은 6개 외의 B.AI 모델(GPT·Claude·Gemini 등)도 gjc가 자동으로 목록에 불러옵니다. 이 모델들은 **할인이 없고 훨씬 비쌉니다.** 고를 때 주의하세요. 현재 id 확인: `curl https://api.b.ai/v1/models -H "Authorization: Bearer $BAI_API_KEY"`.

## 파일 구성

| 파일 | 설치 위치 | 역할 |
|---|---|---|
| `agent/config.yml` | `~/.gjc-bai/agent/config.yml` | 역할별 폴백 체인 (기존 파일은 `--force` 없이 안 덮음) |
| `agent/models.yml` | `~/.gjc-bai/agent/models.yml` | B.AI provider 정의 (키는 env 이름만) |
| `bin/bai-gjc`, `.cmd`, `.ps1` | PATH | `bai-gjc` 런처. `GJC_CODING_AGENT_DIR=~/.gjc-bai/agent`로 사용자 설정·세션만 분리, 유료 키 스크럽 |
| `install.sh` / `install.ps1` | — | 설치 스크립트 (`--force` / `-Force` = 백업 후 교체) |
| `guide.html` | GitHub Pages | 초보자 가이드 |

## 보안

- 이 repo 어디에도 API 키·개인정보 없음. 키는 `BAI_API_KEY` 환경변수로만 참조.
- 런처가 `ANTHROPIC_*`, `OPENAI_API_KEY`, `OPENAI_BASE_URL`, `OPENROUTER_API_KEY`를 지우고 실행 → 유료 키 실수 청구 방지.
- 충전은 공식 주소(`chat.b.ai`, `chat.bankofai.io`)에서만.

## 크레딧

- gjc 원작: [Yeachan-Heo/gajae-code](https://github.com/Yeachan-Heo/gajae-code)
- 무료 버전: [free-gjc-starter](https://github.com/yazzang-homelab/free-gjc-starter)
- 질문: 오픈카톡 <https://open.kakao.com/o/pW7JOXDi>

비공식 세팅. gjc 원작자·B.AI와 제휴 관계 없음(레퍼럴 코드만).
