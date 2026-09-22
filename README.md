# bai-gjc-starter

**B.AI 키 하나로 gjc(gajae-code) 메인 + 서브에이전트 전부 돌리는 저가 세팅.**
DeepSeek-V4.1-Flash · GLM-5.3-Flash · Qwen3.8-Flash **90% 할인** 이벤트 모델이 기본값.

👉 **그림 포함 왕초보 가이드: <https://yazzang-homelab.github.io/bai-gjc-starter/guide.html>**

> 🤖 이 repo와 가이드는 **전부 무료 AI가 작성**했습니다 — 형제 프로젝트 [free-gjc-starter](https://github.com/yazzang-homelab/free-gjc-starter)(무료 Gemini + 무료 서브에이전트) 세팅의 gjc가 B.AI 공식 문서를 읽고 설정·런처·문서를 만들었습니다.

## 지금 B.AI 이벤트 (2026-09-22 기준)

| | |
|---|---|
| 토큰 **1+1** 충전 | **BNB Chain** 결제 시 +100%. 카드 등 일반 충전은 **1+0.5**. (보너스 30일 유효) |
| **90% 할인** | DeepSeek-V4.1-Flash, GLM-5.3-Flash, Qwen3.8-Flash가 표준가의 10%. GLM-5.3 풀은 10% 할인, GLM-5.2는 40% 할인 |
| 속도 | 서브에이전트까지 물려도 **100 tok/s 이상**. 무료 티어 429·대기열 없음 |

가입: **<https://chat.b.ai/chat?invite_code=9MVP9L>** (작성자 레퍼럴 — 가입자 손해 없음. 싫으면 `https://chat.b.ai/chat`)
최신 이벤트: <https://docs.b.ai/llmservice/promotions-and-pricing-notices/>

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

기존 `gjc` / `free-gjc`와 완전히 분리(`~/.gjc-bai`)되어 충돌 없음.

## 기본 모델 배치

| 역할 | 모델 | 할인 |
|---|---|---|
| default · architect | `bai/deepseek-v4.1-flash` (552B MoE, 1M ctx, 이미지 입력) | 90% |
| executor | `bai/glm-5.3-flash` (1M ctx) | 90% |
| planner · critic | `bai/qwen3.8-flash` (1M ctx) | 90% |

`~/.gjc-bai/agent/config.yml`의 `modelRoles:` 한 줄만 바꾸면 교체. `models.yml`에 `glm-5.3`, `qwen3.8-max`, `minimax-m3`도 미리 등록돼 있음. 다른 모델 id는
`curl https://api.b.ai/v1/models -H "Authorization: Bearer $BAI_API_KEY"`.

## 파일 구성

| 파일 | 설치 위치 | 역할 |
|---|---|---|
| `agent/config.yml` | `~/.gjc-bai/agent/config.yml` | 역할 매핑 + 폴백 |
| `agent/models.yml` | `~/.gjc-bai/agent/models.yml` | B.AI provider 정의 (키는 env 이름만) |
| `bin/bai-gjc`, `.cmd`, `.ps1` | PATH | `bai-gjc` 런처 (프로필 격리, 유료 키 스크럽) |
| `install.sh` / `install.ps1` | — | 설치 스크립트 |
| `guide.html` | GitHub Pages | 초보자 가이드 |

## 보안

- 이 repo 어디에도 API 키·개인정보 없음. 키는 `BAI_API_KEY` 환경변수로만 참조.
- 런처가 `ANTHROPIC_*`, `OPENAI_API_KEY`, `OPENROUTER_API_KEY`를 지우고 실행 → 유료 키 실수 청구 방지.
- 충전은 공식 주소(`chat.b.ai`, `chat.bankofai.io`)에서만.

## 크레딧

- gjc 원작: [Yeachan-Heo/gajae-code](https://github.com/Yeachan-Heo/gajae-code)
- 무료 버전: [free-gjc-starter](https://github.com/yazzang-homelab/free-gjc-starter)
- 질문: 오픈카톡 <https://open.kakao.com/o/pW7JOXDi>

비공식 세팅. gjc 원작자·B.AI와 제휴 관계 없음(레퍼럴 코드만).
