#!/usr/bin/env bash
#
# setup-python.sh
#   WSL (Ubuntu) のクリーンインストール直後の状態から
#   Python 3 開発環境を導入するためのセットアップスクリプト。
#
#   ⚠️ 設計方針:
#     本スターターキットでは **仮想環境（venv / uv 等）を使いません**。
#     学習者がプログラム本体に集中できるようにするための意図的な選択です
#     （`docs/01_仕様と設計.md §5.1` 参照）。
#     そのため `python3-venv` 等の venv 系パッケージは導入しません。
#
#   実行内容:
#     1. apt パッケージリストの更新
#     2. Python 3 本体および開発に必要な周辺パッケージの導入
#         - python3            : Python 本体
#         - python3-pip        : パッケージマネージャ pip
#         - python3-dev        : C 拡張モジュールのビルドに必要なヘッダ
#         - build-essential    : gcc / make 等のビルドツール一式
#         - ca-certificates    : HTTPS 通信用ルート証明書
#         - curl / git         : 取得・バージョン管理用
#     3. pip のアップグレード（ユーザー領域）
#     4. 動作確認の表示
#
#   使い方:
#     bash setup-python.sh
#
#   再実行しても安全（既にインストール済みのものはスキップされます）。

set -euo pipefail

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

apt_update() {
  log "apt パッケージリストを更新します。"
  sudo apt-get update -y
}

install_python() {
  log "Python 3 と関連パッケージを導入します（venv は使わない方針のため非導入）。"
  sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-dev
}

upgrade_pip() {
  # Ubuntu 23.04+ では PEP 668 により system Python への pip install が
  # 制限されているため、--user でユーザー領域に更新する。
  # 本スターターキットでは venv を使わないため、追加パッケージが必要に
  # なった場合も `pip install --user <pkg>` で導入する運用を想定。
  if command -v python3 >/dev/null 2>&1; then
    log "pip をユーザー領域で最新化します。"
    python3 -m pip install --user --upgrade pip || \
      warn "pip のアップグレードに失敗しました（PEP 668 制約の可能性）。"
  fi
}

verify() {
  log "インストール結果を確認します。"
  python3 --version || true
  python3 -m pip --version || true
}

print_next_steps() {
  cat <<'EOF'

============================================================
 Python 3 のセットアップが完了しました 🐍
============================================================

【次にやること】

 1. 動作確認:
       python3 --version
       python3 -m pip --version

 2. AI ツール（Claude Code 等）に Python ファイルを書いてもらい、
    そのまま実行する:

       python3 your_script.py

 3. 追加パッケージが必要になったら（例: pandas）:

       pip install --user pandas

    ※ 本スターターキットは **仮想環境（venv / uv 等）を使わない方針** です。
       学習者がプログラム本体に集中できるようにするためで、`pip install`
       は `--user` でユーザー領域に入れる運用を想定しています。
       詳細は docs/01_仕様と設計.md §5.1 を参照。

 4. （任意）python コマンドでも呼び出せるようにする:

       sudo apt-get install -y python-is-python3

============================================================
EOF
}

main() {
  require_linux
  require_non_root
  apt_update
  install_python
  upgrade_pip
  verify
  print_next_steps
}

main "$@"
