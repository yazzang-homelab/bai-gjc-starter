#!/usr/bin/env bash
# bai-gjc-starter installer (Linux / macOS / Git-Bash).
# Places the B.AI profile at ~/.gjc-bai and the `bai-gjc` launcher on PATH.
# Idempotent. Installs NO keys — you provide BAI_API_KEY yourself (see README).
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v gjc >/dev/null 2>&1; then
  echo "gjc 가 없습니다. 먼저 설치하세요:"
  echo "  curl -fsSL https://bun.sh/install | bash   # bun 없으면"
  echo "  bun install -g gajae-code"
  exit 1
fi

install -Dm644 "$here/agent/config.yml" "$HOME/.gjc-bai/agent/config.yml"
install -Dm644 "$here/agent/models.yml" "$HOME/.gjc-bai/agent/models.yml"

bindir="$HOME/.local/bin"
mkdir -p "$bindir"
install -Dm755 "$here/bin/bai-gjc" "$bindir/bai-gjc"

cat <<MSG

설치 완료. B.AI 프로필 -> ~/.gjc-bai, 런처 -> $bindir/bai-gjc
($bindir 가 PATH에 없으면 추가하세요: export PATH="\$HOME/.local/bin:\$PATH")

남은 건 키 하나:
  1) https://chat.b.ai/chat?invite_code=9MVP9L 가입 → 충전 → API Key 발급
  2) export BAI_API_KEY="sk-..."      (~/.zshrc 또는 ~/.bashrc 에 추가)
  3) 확인:
       bai-gjc config get modelRoles
       bai-gjc -p --no-session "누구니?"
MSG
