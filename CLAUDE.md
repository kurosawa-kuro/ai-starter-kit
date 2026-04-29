# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## このリポジトリの位置づけ

非ITエンジニア（Windows ユーザー）が **WSL + VSCode + AI コーディングツール（Claude Code / Codex CLI）** を使って **事務処理の自動化** と **プログラミング学習・自動化** を行うための、環境構築ガイド + プロンプト・データ一式。

中身は実コードではなく **「セットアップシェル + 学習用プロンプトメモ + サンプルデータ」** の集合体。実装作業は基本的にユーザーが Claude Code を起動してプロンプトメモに沿って依頼する流れで発生する。

## ディレクトリ構成（実体）

- `AIによる事務処理・プログラミング自動化_環境構築ガイド.md` — 非エンジニア向けの WSL + VSCode + Git 導入手順書（一次情報）
- `src/scripts/*.sh` — WSL Ubuntu 上で AI ツール環境を整える **冪等なセットアップシェル**（命名規則 `setup-*.sh`）
  - `setup-python.sh`: Python 3 + 開発用 apt パッケージ
  - `setup-claude-code.sh`: nvm + Node.js LTS + `@anthropic-ai/claude-code`
  - `setup-codex.sh`: nvm + Node.js LTS + `@openai/codex`
  - `setup-docker.sh`: Docker Engine + Compose plugin（Docker Desktop 不使用、WSL 内 systemd 有効化込み）
  - `setup-vscode-extensions.sh`: VSCode 推奨拡張（日本語化 / Python / Markdown / GitLens / Docker / Jupyter ほか）の一括導入
- `src/pg/` — Python プログラミング学習タスクのプロンプトメモ + サンプルデータ（`README.md` にプロンプトを保管）
- `src/office-task/` — 事務処理タスクのプロンプトメモ + サンプルデータ（同上）
- `docs/01_仕様と設計.md` 〜 `05_運用.md` — 仕様 / backlog / 実体目録 / 動作確認 / 利用者フロー。権威順位と更新ルールは `docs/README.md` 参照

## セットアップシェルの設計ルール（変更時の遵守事項）

`src/scripts/*.sh` を編集・追加する場合は、既存スクリプトと同じ設計に揃える：

- `set -euo pipefail` 必須
- `require_linux` / `require_non_root` チェックを冒頭に置く（root 実行禁止、必要箇所で `sudo` を内部から呼ぶ）
- `log` / `warn` / `err` の色付き出力ヘルパを再利用
- **冪等性**: 既にインストール済みなら検出してスキップ。再実行で壊れないこと
- 完了時に `print_next_steps` で日本語の次手順を表示
- apt 系は `--no-install-recommends` を付ける
- Node.js 系（`setup-claude-code.sh` / `setup-codex.sh`）は **nvm 経由**で導入し、グローバル npm install で CLI を入れる構成を踏襲
- 新規シェルは `setup-<対象>.sh` の命名で揃える

## プロンプトメモ（`src/*/README.md`）の編集ルール

`src/pg/README.md` `src/office-task/README.md` などのプロンプトメモは、利用者がそのままコピペして AI に渡す前提のドキュメント。以下の規約を守る：

- **共通項目を上部に集約して DRY 化しない**。各プロンプトセクションは自己完結（同じ要件を重複して書く）させる。利用者が単独でコピペしたいため
- フォーマットは `## プロンプトN: <概要>` 見出し + `- **項目名**: 内容` 箇条書き
- `src/pg/` のプロンプトは以下を前提として明記する：
  - 言語: Python 3
  - **Python 3 は `/home/ubuntu/repos/ai-starter-kit/src/scripts/setup-python.sh` で事前インストール済み**
  - 仮想環境（uv / venv 等）は **使わない**。学習者がプログラム本体に集中できるようにする意図的な選択
  - 回答は日本語、必要に応じて環境構築・起動方法も日本語で案内
- `src/office-task/` のプロンプトでファイル操作を扱う場合、**元ファイルは絶対に変更・移動・削除しない**。コピーして新しい名前を付けて同ディレクトリに保存する方式が既定

## 作業時の言語・スタイル

- ドキュメント・回答・コミットメッセージは **日本語**（本リポジトリの読者は日本語話者の非エンジニア）
- 既存スクリプト・README が日本語コメント / 日本語見出しを使っている箇所は同じスタイルを維持する
