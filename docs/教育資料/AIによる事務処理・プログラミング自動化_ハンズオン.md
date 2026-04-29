# AIによる事務処理・プログラミング自動化 ハンズオン

～ git clone から AI ツール起動まで（Phase 2：実作業の入口） ～

## 本ハンズオンのスコープ

本ドキュメントは **「`git clone` 以降の手順」** を扱います。Windows / WSL / VSCode / Git / Python の土台が整っていることを前提とし、その上でリポジトリを取得し、同梱の `src/scripts/setup-*.sh` を必要分だけ実行して、AI ツール（Claude Code / Codex CLI）で実作業を始められる状態を作ります。

```
┌─────────────────────────────────────────┐         ┌─────────────────────────────────────┐
│  【Phase 1】 環境構築（前ドキュメント）     │         │  【Phase 2】 ハンズオン ← 本ドキュメント │
│                                          │         │                                      │
│  ・WSL + Ubuntu のインストール             │  ───▶  │  ① git clone でリポジトリ取得         │
│  ・VSCode + WSL拡張のセットアップ          │         │  ② setup-*.sh を必要分だけ実行       │
│  ・Git のインストール                      │         │  ③ 動作確認                         │
│  ・Python の存在確認                       │         │  ④ VSCode でプロジェクトを開き直す   │
│                                          │         │  ⑤ AIツールを起動して運用開始        │
└─────────────────────────────────────────┘         └─────────────────────────────────────┘
   AIによる事務処理・プログラミング自動化_       ここから先（プロンプトメモ活用）の日常運用は
   環境構築ガイド.md                            docs/05_運用.md を参照
```

> 💡 環境構築（Phase 1）が未完了の方は、先に **[`AIによる事務処理・プログラミング自動化_環境構築ガイド.md`](./AIによる事務処理・プログラミング自動化_環境構築ガイド.md)** を完了させてください。

---

## 前提条件（Phase 1 完了確認）

WSL に接続した状態の VSCode ターミナルで、以下が全部通ることを確認してから本ハンズオンに入ってください。

```bash
# WSL 内で動いていること
uname -a            # → Linux ... で始まる文字列

# Git が使えること
git --version       # → git version x.y.z

# Python 3 が存在すること
python3 --version   # → Python 3.x.x
```

ひとつでも通らない場合は **[`環境構築ガイド`](./AIによる事務処理・プログラミング自動化_環境構築ガイド.md)** に戻ってください。

---

## 自動構築されるもの（`src/scripts/` の各シェルの守備範囲）

リポジトリには **目的別に分かれた冪等な setup-*.sh** が同梱されています。必要なものだけを順番に実行します。

| シェル | 役割 | 必須／任意 |
|---|---|---|
| `setup-python.sh` | Python 3 + 開発用 apt パッケージ（`python3-pip` / `python3-venv` / `build-essential` ほか） | 必須 |
| `setup-claude-code.sh` | nvm + Node.js LTS + Claude Code (`@anthropic-ai/claude-code`) | 必須 |
| `setup-codex.sh` | nvm + Node.js LTS + Codex CLI (`@openai/codex`) | 任意（併用したい場合） |
| `setup-vscode-extensions.sh` | VSCode 推奨拡張一括導入（日本語化 / Python / Markdown / GitLens / Docker / Jupyter / DBCode / Rainbow CSV 等） | 任意（推奨） |
| `setup-docker.sh` | Docker Engine + Compose plugin（Docker Desktop 不使用） | 任意（Docker を使う場合のみ） |

同梱されているのは **シェル + プロンプトメモ（`src/pg/README.md` / `src/office-task/README.md`） + サンプルデータ** です。「設計済みコード」は同梱されていません — 実装は AI ツールに依頼して都度生成する設計です。

---

## ハンズオン手順

WSLに接続した状態のVSCodeターミナルで実行します。

### ① 作業フォルダに移動

```bash
cd ~
```

   - WSL内のホーム（`/home/ユーザー名/`）に置くのが基本
   - **Windows側（`/mnt/c/...`）にはcloneしないでください**（ファイル読み書きが遅くなります）

### ② リポジトリを clone

```bash
git clone <配布元から教えてもらったURL>
```

   - 例：`git clone https://github.com/your-org/ai-starter-kit.git`
   - プライベートリポジトリの場合はユーザー名とトークンを求められることがあります（後述のトラブルシューティング参照）

### ③ clone したプロジェクトに移動

```bash
cd ai-starter-kit                 # ← clone したフォルダ名
ls
```

   - フォルダの中身（`README.md`、`CLAUDE.md`、`docs/`、`src/scripts/`、`src/pg/`、`src/office-task/` など）が確認できればOK

### ④ セットアップシェルを順番に実行（AIツール環境が自動インストール）

`src/scripts/` 配下のシェルを **必須 → 任意** の順で実行します。冪等なので、再実行しても安全です。

```bash
# 必須
bash src/scripts/setup-python.sh           # Python 3 + 開発用パッケージ
bash src/scripts/setup-claude-code.sh      # Claude Code（nvm + Node.js + CLI）

# 任意（必要に応じて）
bash src/scripts/setup-codex.sh            # Codex CLI も併用したい場合
bash src/scripts/setup-vscode-extensions.sh # VSCode 拡張一括導入（日本語化含む）
bash src/scripts/setup-docker.sh           # Docker を使うタスクをやる場合
```

   - 各シェル完了後、**ターミナルを一度開き直す** と nvm 等の PATH が反映されます
   - エラーが出た場合は `docs/04_検証.md` の「よくある問題」を参照
   - `setup-docker.sh` を実行した場合は、最後に Windows 側 PowerShell で `wsl --shutdown` してから WSL を再起動してください

### ⑤ 動作確認（推奨）

`docs/04_検証.md §8` の一括チェックリストを上から叩いて、すべて緑になることを確認します。

```bash
python3 --version
claude --version
# （任意）codex --version
# （任意）code --list-extensions
```

### ⑥ VSCode でプロジェクトを開き直す（推奨）

```bash
code .
```

   - VSCode が自動的に WSL接続でこのフォルダを開き直します
   - 以降のAI操作はこのプロジェクト配下が対象になります

### ⑦ AIツールを起動して運用開始

```bash
claude       # 例：Claude Code を起動
```

初回起動時はブラウザで Anthropic アカウントの認証が必要です。Codex を使う場合は `codex` を起動して OpenAI サインイン、または `OPENAI_API_KEY` を設定します。

---

## ハンズオン後の引き継ぎ（日常運用）

ここから先（どのプロンプトを使うか、AIに何を頼むか、結果をどう活用するか）は、以下を参照してください。

- **[`README.md`](../../README.md)** — 入口、各ドキュメントへのリンク
- **[`docs/05_運用.md`](../05_運用.md)** — 利用者の作業フロー（git clone → setup → AI 起動 → 日常運用）
- **[`docs/01_仕様と設計.md`](../01_仕様と設計.md)** — このリポジトリの位置づけと設計上の決め事
- **[`src/pg/README.md`](../../src/pg/README.md)** — Python 学習タスク用のプロンプトメモ（コピペ前提）
- **[`src/office-task/README.md`](../../src/office-task/README.md)** — 事務処理タスク用のプロンプトメモ（コピペ前提）

> 💡 環境構築は **一度やればOK**。今後は新しい業務が増えたら ① の `git clone` を別のリポジトリに対して繰り返すだけで、すぐに運用に入れます。

---

## トラブルシューティング（ハンズオンフェーズ）

| 症状 | 対処法 |
| --- | --- |
| `git clone` で `Authentication failed` が出る | プライベートリポジトリ。配布元から **HTTPSのURL+トークン** または **SSH鍵** の方法を確認。HTTPSの場合はユーザー名と Personal Access Token を入力 |
| `git clone` で `Permission denied (publickey)` が出る | SSH方式の場合、SSH鍵が未設定／未登録。`ssh-keygen -t ed25519` で鍵作成 → `~/.ssh/id_ed25519.pub` の中身をGitHub等に登録 |
| `setup-claude-code.sh` / `setup-codex.sh` 実行後に `claude` / `codex` コマンドが見つからない | nvm の PATH が現セッションに反映されていない。一度ターミナルを閉じて開き直す。または `export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh"` で手動ロード |
| `setup-vscode-extensions.sh` で `code: command not found` | WSL 接続済みの VSCode ターミナルで実行する必要あり。素の WSL ターミナルではなく、VSCode の WSL 接続セッションから開いたターミナルを使う |
| `setup-docker.sh` 実行後に `permission denied while trying to connect to the Docker daemon` | `docker` グループ反映前か systemd 起動前。Windows 側 PowerShell で `wsl --shutdown` → WSL を再起動 |
| `setup-*.sh` がそれ以外で失敗する | `docs/04_検証.md` の各シェル節「よくある問題」を参照 |
| clone はできたがAIから読めない／動作が遅い | clone先が `/mnt/c/...`（Windows側）になっていないか確認。WSL内のホーム（`/home/...`）に置き直す |

> 💡 WSL / VSCode / Git の環境構築自体のトラブルは **[`環境構築ガイド`](./AIによる事務処理・プログラミング自動化_環境構築ガイド.md)** 末尾のトラブルシューティングを参照してください。

---

## 参考リンク

> ⚠️ 以下のツールは `setup-*.sh` が自動で導入します。詳細手順を知りたい場合の参考リンクとして掲載しています。

- Claude Code 公式：https://docs.claude.com/ja/docs/claude-code/overview
- Codex CLI（GitHub）：https://github.com/openai/codex
- nvm（Node Version Manager）：https://github.com/nvm-sh/nvm
- 参考記事（Qiita @teraco）：claude codeをWindows環境(WSL2)にインストールする
- 参考記事（Qiita @fusnail）：WSL2にCodex CLIを導入して、Windows側VS Codeからvenv固定で使う手順
