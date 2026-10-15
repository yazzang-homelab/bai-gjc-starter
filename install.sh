#!/usr/bin/env bash
# bai-gjc-starter installer (Linux / macOS / Git-Bash).
# Places the B.AI profile at ~/.gjc-bai/agent and the `bai-gjc` launcher on PATH.
# Installs NO keys — you provide BAI_API_KEY yourself (see README).
#
#   bash install.sh           # 기존 ~/.gjc-bai/agent/{config,models}.yml 이 있으면 그대로 둔다
#   bash install.sh --force   # 기존 설정을 *.bak-<시각> 으로 백업한 뒤 새 설정으로 교체
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

force=0
for arg in "$@"; do
  case "$arg" in
    --force|-f) force=1 ;;
    *) echo "알 수 없는 옵션: $arg  (사용법: bash install.sh [--force])" >&2; exit 2 ;;
  esac
done

if ! command -v gjc >/dev/null 2>&1; then
  echo "gjc 가 없습니다. 먼저 설치하세요:"
  echo "  curl -fsSL https://bun.sh/install | bash   # bun 없으면"
  echo "  bun install -g gajae-code"
  exit 1
fi

agent="$HOME/.gjc-bai/agent"
mkdir -p "$agent"
stamp="$(date +%Y%m%d-%H%M%S)"
kept=0

# place SRC DST: DST가 있으면 유지(--force면 .bak-<시각> 백업 후 교체)
place() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ "$force" -eq 0 ]; then
    echo "기존 설정 유지: $dst"
    kept=1
    return
  fi
  if [ -e "$dst" ]; then
    mv "$dst" "$dst.bak-$stamp"
    echo "백업: $dst.bak-$stamp"
  fi
  install -m644 "$src" "$dst"
}

place "$here/agent/config.yml" "$agent/config.yml"
place "$here/agent/models.yml" "$agent/models.yml"

if grep -qsE 'fallbackChains|deepseek-v4-flash|qwen3\.8-max|minimax-m3' "$agent/config.yml" "$agent/models.yml"; then
  echo "  ⚠ 예전 버전 설정입니다(옛 할인율·폴백 형식). bash install.sh --force 로 교체하세요."
elif [ "$kept" -eq 1 ]; then
  echo "  (새 설정으로 바꾸려면: bash install.sh --force)"
fi

bindir="$HOME/.local/bin"
mkdir -p "$bindir"
install -m755 "$here/bin/bai-gjc" "$bindir/bai-gjc"

cat <<MSG

설치 완료. B.AI 프로필 -> $agent, 런처 -> $bindir/bai-gjc
($bindir 가 PATH에 없으면 추가하세요: export PATH="\$HOME/.local/bin:\$PATH")

남은 건 키 하나:
  1) https://chat.b.ai/chat?invite_code=9MVP9L 가입 → 충전 → API Key 발급
  2) export BAI_API_KEY="sk-..."      (~/.zshrc 또는 ~/.bashrc 에 추가)
  3) 확인:
       bai-gjc config get modelRoles
       bai-gjc -p --no-session "누구니?"
MSG
