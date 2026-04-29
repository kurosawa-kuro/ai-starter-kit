# プログラム作成プロンプトメモ

> 各プロンプトは **コピペで AI に渡せる自己完結型** です。共通項目はあえて DRY 化していません。

> 📂 **作成先フォルダの規約**: 各プロンプトには「作成先フォルダ」を明示しています。AI に依頼する前に、対応するフォルダを `src/pg/` 配下に作っても、AI に作らせても OK です。プロンプトごとに 1 つのフォルダにファイルが収まる構成です。

## プロンプト1: 偶数判定 CLI

- **依頼内容**: 偶数判定を行うコマンドラインプログラムを作成
- **言語**: Python 3
- **前提**: Python 3 は事前に本リポジトリの `src/scripts/setup-python.sh` でインストール済みであること
- **作成先フォルダ**: 本リポジトリの `src/pg/01_even-judge-cli/`（無ければ作成）
- **回答**: 日本語で、日本人にわかりやすい説明
- **手順説明**: 必要に応じて環境構築・起動方法を案内
- **仮想環境**: 不要（uv 等は使わない。学習者がプログラム自体に集中できるようにするため）

---

## プロンプト2: 偶数判定 Web アプリ

- **依頼内容**: 偶数判定を行う Web アプリを作成
- **言語**: Python 3
- **前提**: Python 3 は事前に本リポジトリの `src/scripts/setup-python.sh` でインストール済みであること
- **使用技術**: FastAPI + Jinja
- **作成先フォルダ**: 本リポジトリの `src/pg/02_even-judge-web/`（無ければ作成）
- **UI**: 日本語で、日本人にわかりやすい表記
- **手順説明**: 必要に応じて環境構築・起動方法を案内
- **仮想環境**: 不要（uv 等は使わない。学習者がプログラム自体に集中できるようにするため）

---

## プロンプト3: FizzBuzz CLI

- **依頼内容**: 1 から N までの整数を順に出力する CLI を作成。3 の倍数で `Fizz`、5 の倍数で `Buzz`、両方の倍数で `FizzBuzz` を表示する
- **言語**: Python 3
- **前提**: Python 3 は事前に本リポジトリの `src/scripts/setup-python.sh` でインストール済みであること
- **作成先フォルダ**: 本リポジトリの `src/pg/03_fizzbuzz-cli/`（無ければ作成）
- **入力**: コマンドライン引数で N を受け取る（省略時は N=20）
- **学習ポイント**: 条件分岐 / ループ / 標準出力の基礎
- **回答**: 日本語で、日本人にわかりやすい説明
- **手順説明**: 必要に応じて環境構築・起動方法を案内
- **仮想環境**: 不要（uv 等は使わない。学習者がプログラム自体に集中できるようにするため）

---

## プロンプト4: 簡易家計簿 CLI

- **依頼内容**: 日付・カテゴリ・金額を CSV ファイルに追記し、月次合計とカテゴリ別合計を表示できる家計簿 CLI を作成
- **言語**: Python 3
- **前提**: Python 3 は事前に本リポジトリの `src/scripts/setup-python.sh` でインストール済みであること
- **作成先フォルダ**: 本リポジトリの `src/pg/04_kakeibo-cli/`（無ければ作成）
- **使用ライブラリ**: 標準ライブラリ（`csv` / `argparse` / `datetime`）のみ
- **データ保存先**: 作成先フォルダ直下に `kakeibo.csv`（無ければ作成）
- **コマンド例**:
  - 追加: `python3 kakeibo.py add 2026-04-15 食費 1200`
  - 月次合計: `python3 kakeibo.py month 2026-04`
  - カテゴリ別合計: `python3 kakeibo.py by-category 2026-04`
- **学習ポイント**: ファイル I/O / CSV モジュール / 辞書集計 / argparse の基本
- **回答**: 日本語で、日本人にわかりやすい説明
- **手順説明**: 必要に応じて環境構築・起動方法を案内
- **仮想環境**: 不要（uv 等は使わない。学習者がプログラム自体に集中できるようにするため）

---

## プロンプト5: Markdown → HTML 変換 CLI

- **依頼内容**: Markdown ファイルを HTML ファイルに変換する CLI を作成
- **言語**: Python 3
- **前提**: Python 3 は事前に本リポジトリの `src/scripts/setup-python.sh` でインストール済みであること
- **作成先フォルダ**: 本リポジトリの `src/pg/05_markdown-to-html-cli/`（無ければ作成）
- **入出力**: コマンドライン引数で `input.md` を受け取り、同フォルダに `input.html` として出力
- **使用ライブラリ**: `markdown`（`pip install --user markdown` で導入。本キットは仮想環境を使わない方針）
- **HTML 出力**: `<html><head><meta charset="utf-8"></head><body>...</body></html>` の最小レイアウト
- **学習ポイント**: ファイル I/O / 外部ライブラリの利用 / 文字エンコーディング
- **回答**: 日本語で、日本人にわかりやすい説明
- **手順説明**: 必要に応じて環境構築・起動方法を案内
- **仮想環境**: 不要（uv 等は使わない。学習者がプログラム自体に集中できるようにするため）

---

## プロンプト6: 天気情報 Web アプリ（FastAPI + Jinja + Open-Meteo）

- **依頼内容**: 緯度経度を指定すると、外部 API（Open-Meteo）から現在の天気情報を取得して Web 画面に表示するアプリを作成
- **言語**: Python 3
- **前提**: Python 3 は事前に本リポジトリの `src/scripts/setup-python.sh` でインストール済みであること
- **使用技術**: FastAPI + Jinja2 テンプレート
- **作成先フォルダ**: 本リポジトリの `src/pg/06_weather-web/`（無ければ作成）
- **使用 API**: [Open-Meteo](https://open-meteo.com/)（**API キー不要・登録不要・無料**）
  - エンドポイント例: `https://api.open-meteo.com/v1/forecast?latitude=35.69&longitude=139.69&current=temperature_2m,weather_code,wind_speed_10m&timezone=Asia/Tokyo`
- **入力フォーム**:
  - 緯度（数値、初期値: `35.69`）
  - 経度（数値、初期値: `139.69`）
  - 「取得」ボタン
- **表示内容**:
  - 取得時刻（日本時間）
  - 現在の気温（°C）
  - 天気コードを日本語ラベルに変換して表示（例: 0=快晴 / 1〜3=晴れ／曇り / 51〜67=雨 / 71〜77=雪 など、Open-Meteo の Weather Code 表に基づく簡易マッピング）
  - 風速（m/s）
- **使用ライブラリ**: `fastapi` / `uvicorn` / `jinja2` / `httpx`（すべて `pip install --user` で導入。本キットは仮想環境を使わない方針）
  - もしくは `httpx` の代わりに標準ライブラリの `urllib.request` でも可
- **エラーハンドリング**: API がエラーを返した／ネットワーク失敗時は、画面に分かりやすいメッセージを表示（スタックトレースをそのまま見せない）
- **UI**: 日本語で、日本人にわかりやすい表記
- **学習ポイント**: 外部 API 呼び出し（HTTP GET）／JSON パース／フォーム入力／コード→ラベル変換／簡易エラーハンドリング
- **手順説明**: 必要に応じて環境構築・起動方法を案内（`uvicorn main:app --reload` の使い方含む）
- **仮想環境**: 不要（uv 等は使わない。学習者がプログラム自体に集中できるようにするため）

---

## プロンプト7: TODO リスト Web アプリ（FastAPI + Jinja + SQLite）

- **依頼内容**: TODO の追加・一覧表示・完了状態の切替・削除ができる Web アプリを作成。データは SQLite で永続化する
- **言語**: Python 3
- **前提**: Python 3 は事前に本リポジトリの `src/scripts/setup-python.sh` でインストール済みであること
- **使用技術**: FastAPI + Jinja2 テンプレート + SQLite
- **作成先フォルダ**: 本リポジトリの `src/pg/07_todo-web/`（無ければ作成）
- **DB ライブラリ**: 標準ライブラリの `sqlite3`（追加インストール不要）
- **DB ファイル**: 作成先フォルダ直下に `todos.db`（起動時に存在しなければテーブルを自動作成）
- **テーブル設計（最低限）**:
  ```sql
  CREATE TABLE IF NOT EXISTS todos (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    title     TEXT    NOT NULL,
    done      INTEGER NOT NULL DEFAULT 0,   -- 0=未完了 / 1=完了
    created_at TEXT   NOT NULL DEFAULT (datetime('now', 'localtime'))
  );
  ```
- **画面要素**:
  - **追加フォーム**: タイトル入力 + 「追加」ボタン
  - **一覧**: 各行に「完了チェックボックス」「タイトル（完了は取り消し線）」「削除ボタン」
  - 件数サマリー（合計 / 未完了 / 完了）
- **使用ライブラリ**: `fastapi` / `uvicorn` / `jinja2` / `python-multipart`（フォーム受信用、すべて `pip install --user` で導入。本キットは仮想環境を使わない方針）
- **セキュリティ**: SQL は **プレースホルダ（`?`）を必ず使う**（SQL インジェクション対策）。文字列連結禁止
- **学習ポイント**: SQLite 接続 / 基本 4 操作（INSERT / SELECT / UPDATE / DELETE）/ フォーム受信 / POST → リダイレクト → GET（PRG パターン）/ Jinja で一覧描画
- **UI**: 日本語で、日本人にわかりやすい表記
- **手順説明**: 必要に応じて環境構築・起動方法を案内（`uvicorn main:app --reload` の使い方含む）
- **仮想環境**: 不要（uv 等は使わない。学習者がプログラム自体に集中できるようにするため）

> 💡 補足: `setup-vscode-extensions.sh` で導入される **DBCode 拡張**を使うと、生成された `todos.db` を VSCode 上で直接開いて中身を確認できます。学習中の「実際にデータが入っているか」を可視化するのにおすすめ。

---

## 作成先フォルダ一覧（早見）

```
src/pg/
├── README.md                       ← 本ファイル
├── data/                            ← サンプルデータ置き場（必要に応じて）
├── 01_even-judge-cli/              ← プロンプト1: 偶数判定 CLI
├── 02_even-judge-web/              ← プロンプト2: 偶数判定 Web
├── 03_fizzbuzz-cli/                ← プロンプト3: FizzBuzz CLI
├── 04_kakeibo-cli/                 ← プロンプト4: 家計簿 CLI
├── 05_markdown-to-html-cli/        ← プロンプト5: MD→HTML 変換 CLI
├── 06_weather-web/                 ← プロンプト6: 天気 Web（Open-Meteo）
└── 07_todo-web/                    ← プロンプト7: TODO Web（SQLite）
```

各フォルダはプロンプト実行時に AI が作成します（既に存在する場合はそのまま利用）。
