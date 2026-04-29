#!/usr/bin/env bash
#
# setup-claude-code.sh
#   WSL (Ubuntu) のクリーンインストール直後（Node.js 未導入）の状態から
#   Claude Code を導入するためのセットアップスクリプト。
#
#   実行内容:
#     1. apt パッケージの更新と必須コマンド (curl / git / ca-certificates) の導入
#     2. nvm (Node Version Manager) のインストール
#     3. Node.js LTS のインストール
#     4. Claude Code (@anthropic-ai/claude-code) のグローバルインストール
#
#   使い方:
#     bash setup-claude-code.sh
#
#   再実行しても安全（既にインストール済みのものはスキップ／更新されます）。

set -euo pipefail

NVM_VERSION="v0.40.1"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

log()  { printf '\n\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
warn() { printf '\n\033[1;33m[WARN]\033[0m  %s\n' "$*"; }
err()  { printf '\n\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; }

require_linux() {
  if [[ "$(uname -s)" != "Linux" ]]; then
    err "このスクリプトは Linux (WSL の Ubuntu 等) 上で実行してください。"
    exit 1
  fi
}

require_non_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    err "root ユーザーでの実行は推奨されません。一般ユーザーで実行してください。"
    err "（sudo は必要な箇所でスクリプト内から呼び出します）"
    exit 1
  fi
}

apt_install_prereqs() {
  log "apt パッケージリストを更新し、必須パッケージを導入します。"
  sudo apt-get update -y
  sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential
}

install_nvm() {
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    log "nvm は既にインストール済みです ($NVM_DIR)。スキップします。"
    return
  fi

  log "nvm ${NVM_VERSION} をインストールします。"
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
}

load_nvm() {
  # 現在のシェルに nvm を読み込む
  export NVM_DIR
  # shellcheck disable=SC1091
  [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
  # shellcheck disable=SC1091
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

  if ! command -v nvm >/dev/null 2>&1; then
    err "nvm の読み込みに失敗しました。ターミナルを開き直してから再実行してください。"
    exit 1
  fi
}

install_node_lts() {
  log "Node.js (LTS) をインストールします。"
  nvm install --lts
  nvm alias default 'lts/*'
  nvm use default

  log "インストール結果: node $(node -v) / npm $(npm -v)"
}

install_claude_code() {
  log "Claude Code (@anthropic-ai/claude-code) をグローバルインストールします。"
  npm install -g @anthropic-ai/claude-code

  if command -v claude >/dev/null 2>&1; then
    log "claude コマンドが利用可能になりました: $(command -v claude)"
    claude --version || true
  else
    warn "claude コマンドが PATH に見つかりません。ターミナルを開き直してから再度確認してください。"
  fi
}

print_next_steps() {
  cat <<'EOF'

============================================================
 Claude Code のセットアップが完了しました 🎉
============================================================

【次にやること】

 1. 一度 WSL のターミナルを開き直してください。
    （nvm / node / claude のパスを反映するため）

 2. 動作確認:
       node -v
       npm  -v
       claude --version

 3. 起動:
       claude

    初回起動時はブラウザでのログインが求められます。
    画面の指示に従って Anthropic アカウントで認証してください。

 ※ 既存のシェルでそのまま使いたい場合は、以下を実行してから
    claude コマンドを利用してください:

       export NVM_DIR="$HOME/.nvm"
       [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

============================================================
EOF
}

main() {
  require_linux
  require_non_root
  apt_install_prereqs
  install_nvm
  load_nvm
  install_node_lts
  install_claude_code
  print_next_steps
}

main "$@"
