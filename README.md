# AI スターターキット

Windows ユーザー（特に非 IT エンジニア）が **WSL + VSCode + AI コーディングツール（Claude Code / Codex CLI）** を使って **事務処理の自動化** と **プログラミング学習・自動化** に取り組むための、環境構築シェル + プロンプトメモ + サンプルデータの一式。

---

## できるようになること

| 自動化対象 | 例 |
|---|---|
| ① 事務処理の自動化 | Excel 集計、ファイル整理・リネーム、PDF 処理、メール作成、Web 情報の収集 など |
| ② プログラミングの自動化／学習 | Python スクリプトの設計・実装・修正、Git 操作、ライブラリ導入 など |

「コードが書けなくても、日本語で AI に指示すれば動く」を目指している。

---

## はじめかた

セットアップは 2 段階に分かれる。

### Phase 1: 手動の土台づくり

WSL / VSCode / Git を Windows 上に手動でセットアップする。

→ [`AIによる事務処理・プログラミング自動化_環境構築ガイド.md`](./AIによる事務処理・プログラミング自動化_環境構築ガイド.md)

### Phase 2: AI 環境の自動セットアップ + 実作業の開始

このリポジトリを WSL に `git clone` して、`src/scripts/setup-*.sh` を実行する。詳細な手順は **ハンズオンドキュメント** にまとめてある。

→ [`AIによる事務処理・プログラミング自動化_ハンズオン.md`](./AIによる事務処理・プログラミング自動化_ハンズオン.md)

最短実行の例:

```bash
cd ~
git clone <配布元から指定された URL> ai-starter-kit
cd ai-starter-kit

bash src/scripts/setup-python.sh        # Python 3
bash src/scripts/setup-claude-code.sh   # Claude Code CLI
# 任意:
# bash src/scripts/setup-codex.sh
# bash src/scripts/setup-vscode-extensions.sh
# bash src/scripts/setup-docker.sh
```

詳細な手順・動作確認は [`docs/05_運用.md`](./docs/05_運用.md) と [`docs/04_検証.md`](./docs/04_検証.md) 参照。

---

## ディレクトリ

```
ai-starter-kit/
├── AIによる事務処理・プログラミング自動化_環境構築ガイド.md   ← Phase 1（手動）
├── CLAUDE.md                                                ← Claude Code 向け作業ガイド
├── docs/                                                    ← 仕様・運用・検証ドキュメント
└── src/
    ├── scripts/                                             ← Phase 2 セットアップシェル群
    ├── pg/                                                  ← Python 学習タスク（プロンプトメモ + データ）
    └── office-task/                                         ← 事務処理タスク（プロンプトメモ + データ）
```

実体ファイルの目録は [`docs/03_実装カタログ.md`](./docs/03_実装カタログ.md) に集約。

---

## ドキュメント

| ファイル | 役割 |
|---|---|
| [`AIによる事務処理・プログラミング自動化_環境構築ガイド.md`](./AIによる事務処理・プログラミング自動化_環境構築ガイド.md) | Phase 1 の WSL + VSCode + Git 手動セットアップ手順書（git clone 直前まで） |
| [`AIによる事務処理・プログラミング自動化_ハンズオン.md`](./AIによる事務処理・プログラミング自動化_ハンズオン.md) | Phase 2 のハンズオン手順書（git clone → setup-*.sh → AI 起動） |
| [`docs/01_仕様と設計.md`](./docs/01_仕様と設計.md) | ユーザー像・ゴール・全体構成・設計上の決め事 |
| [`docs/02_移行ロードマップ.md`](./docs/02_移行ロードマップ.md) | 今後追加したいシェル／プロンプト／ドキュメントの backlog |
| [`docs/03_実装カタログ.md`](./docs/03_実装カタログ.md) | 実体ファイル目録 |
| [`docs/04_検証.md`](./docs/04_検証.md) | 各セットアップシェルの動作確認手順とよくある問題 |
| [`docs/05_運用.md`](./docs/05_運用.md) | 利用者の作業フロー（git clone → setup → AI 起動） |
| [`docs/README.md`](./docs/README.md) | docs 群の運用ルール・権威順位 |
| [`CLAUDE.md`](./CLAUDE.md) | Claude Code 向け作業ガイド（設計ルール・編集規約） |

---

## 設計上の前提（要点）

- 仮想環境（`venv` / `uv` 等）は `src/pg/` の学習タスクでは **使わない**（学習者がプログラム本体に集中するための意図的な選択）
- `src/office-task/` のファイル操作タスクでは **元ファイルは変更・移動・削除しない**（コピーを作って新しい名前で同じ場所に保存する）
- プロンプトメモ（`src/{pg,office-task}/README.md`）は **共通項目を上部に DRY 化せず**、各セクションを自己完結させる（利用者が単独でコピペ可能にする）
- ドキュメント・シェル出力・コミットメッセージはすべて **日本語**
