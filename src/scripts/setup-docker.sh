#!/usr/bin/env bash
#
# docker.sh
#   WSL (Ubuntu) のクリーンインストール直後の状態から
#   Docker Engine と Docker Compose (plugin) を導入するためのセットアップスクリプト。
#
#   Docker Desktop を使わずに、WSL 内に直接 Docker Engine をインストールする構成です。
#
#   実行内容:
#     1. 競合する旧 docker パッケージを除去
#     2. apt 必須パッケージ (ca-certificates / curl / gnupg / lsb-release) の導入
#     3. Docker 公式 GPG キーと apt リポジトリの登録
#     4. docker-ce / docker-ce-cli / containerd.io
#        / docker-buildx-plugin / docker-compose-plugin の導入
#     5. 現在のユーザーを docker グループに追加
#     6. WSL2 で systemd を有効化 (/etc/wsl.conf)
#
#   使い方:
#     bash docker.sh
#
#   実行後、Windows 側 PowerShell で `wsl --shutdown` を実行し、
#   再度 WSL に入り直すと docker / docker compose が利用できるようになります。

set -euo pipefail

DOCKER_GPG_KEY_URL="https://download.docker.com/linux/ubuntu/gpg"
DOCKER_APT_KEYRING="/etc/apt/keyrings/docker.gpg"
DOCKER_APT_LIST="/etc/apt/sources.list.d/docker.list"

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

require_ubuntu() {
  if [[ ! -r /etc/os-release ]]; then
    err "/etc/os-release が読めません。Ubuntu 環境かを確認してください。"
    exit 1
  fi
  # shellcheck disable=SC1091
  . /etc/os-release
  if [[ "${ID:-}" != "ubuntu" ]]; then
    warn "Ubuntu 以外のディストリビューション (${ID:-unknown}) を検出しました。"
    warn "本スクリプトは Ubuntu を前提としています。続行しますが失敗する可能性があります。"
  fi
  UBUNTU_CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
  if [[ -z "$UBUNTU_CODENAME" ]]; then
    err "Ubuntu のコードネーム (UBUNTU_CODENAME) を取得できませんでした。"
    exit 1
  fi
  log "Ubuntu コードネーム: $UBUNTU_CODENAME"
}

remove_old_docker() {
  log "競合する旧 docker パッケージがあれば除去します。"
  local pkgs=(docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc)
  for p in "${pkgs[@]}"; do
    if dpkg -l | awk '{print $2}' | grep -qx "$p"; then
      sudo apt-get remove -y "$p" || true
    fi
  done
}

install_prereqs() {
  log "apt パッケージリストを更新し、必須パッケージを導入します。"
  sudo apt-get update -y
  sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
}

setup_docker_repo() {
  log "Docker 公式 GPG キーと apt リポジトリを登録します。"
  sudo install -m 0755 -d /etc/apt/keyrings

  # 鍵が無ければ取得
  if [[ ! -s "$DOCKER_APT_KEYRING" ]]; then
    curl -fsSL "$DOCKER_GPG_KEY_URL" | sudo gpg --dearmor -o "$DOCKER_APT_KEYRING"
    sudo chmod a+r "$DOCKER_APT_KEYRING"
  fi

  local arch
  arch="$(dpkg --print-architecture)"
  echo "deb [arch=${arch} signed-by=${DOCKER_APT_KEYRING}] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" \
    | sudo tee "$DOCKER_APT_LIST" >/dev/null

  sudo apt-get update -y
}

install_docker() {
  log "Docker Engine と Compose plugin を導入します。"
  sudo apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
}

add_user_to_docker_group() {
  if ! getent group docker >/dev/null; then
    sudo groupadd docker
  fi
  if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    log "ユーザー $USER は既に docker グループに所属しています。"
  else
    log "ユーザー $USER を docker グループに追加します。"
    sudo usermod -aG docker "$USER"
    NEED_RELOGIN=1
  fi
}

enable_systemd_in_wsl() {
  # WSL2 で systemd を有効化（/etc/wsl.conf）
  local conf=/etc/wsl.conf

  if grep -qiE '^\s*systemd\s*=\s*true' "$conf" 2>/dev/null; then
    log "/etc/wsl.conf で systemd は既に有効化されています。"
    return
  fi

  log "/etc/wsl.conf に systemd 有効化設定を追加します。"
  if [[ ! -f "$conf" ]]; then
    sudo tee "$conf" >/dev/null <<'EOF'
[boot]
systemd=true
EOF
  else
    # [boot] セクションがあれば systemd=true を補い、無ければ追記
    if grep -qE '^\[boot\]' "$conf"; then
      # systemd= 行が無いセクションに追加（雑になりすぎないよう、ファイル末尾に追記して案内）
      sudo sh -c "printf '\n# Added by docker.sh\n[boot]\nsystemd=true\n' >> '$conf'"
    else
      sudo sh -c "printf '\n[boot]\nsystemd=true\n' >> '$conf'"
    fi
  fi
  NEED_WSL_SHUTDOWN=1
}

enable_and_verify() {
  # systemd が現セッションで有効ならサービスを起動／自動起動設定
  if [[ -d /run/systemd/system ]]; then
    log "systemd 検出済み。docker サービスを有効化・起動します。"
    sudo systemctl enable docker.service containerd.service || true
    sudo systemctl start  docker.service containerd.service || true
  else
    warn "現在のセッションでは systemd が動作していません。"
    warn "後述の手順で 'wsl --shutdown' して WSL を再起動してください。"
  fi

  log "バージョン確認:"
  docker --version || true
  docker compose version || true
}

print_next_steps() {
  cat <<EOF

============================================================
 Docker / Docker Compose のセットアップが完了しました 🐳
============================================================

【次にやること】

EOF

  if [[ "${NEED_WSL_SHUTDOWN:-0}" == "1" ]]; then
    cat <<'EOF'
 1. ★重要★ Windows 側の PowerShell (または コマンドプロンプト) で
    一度 WSL を停止してください。これで systemd と docker グループの
    変更が反映されます。

       wsl --shutdown

    その後、改めて WSL を起動し直してください。

EOF
  else
    cat <<'EOF'
 1. 反映のため、ターミナルを開き直すか、以下のいずれかを実行してください。

       newgrp docker            # 現在のシェルで docker グループを有効化
       # または Windows 側で:  wsl --shutdown

EOF
  fi

  cat <<'EOF'
 2. 動作確認:

       docker --version
       docker compose version
       docker run --rm hello-world

 ※ 'permission denied while trying to connect to the Docker daemon'
    と表示される場合、docker グループ反映前か、systemd 起動前です。
    上記 1 の手順を実施してから再度お試しください。

============================================================
EOF
}

main() {
  NEED_RELOGIN=0
  NEED_WSL_SHUTDOWN=0

  require_linux
  require_non_root
  require_ubuntu
  remove_old_docker
  install_prereqs
  setup_docker_repo
  install_docker
  add_user_to_docker_group
  enable_systemd_in_wsl
  enable_and_verify
  print_next_steps
}

main "$@"
