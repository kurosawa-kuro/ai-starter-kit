以下の形に整理すると、目的がかなり明確になります。

# AI時代のファイル処理・Python入門チュートリアル

## 基本方針

この教材は、いきなりプログラミングを教える教材ではない。

主眼は、

**非プログラミング作業を Claude Code で一括処理できるようにし、その後 Python に橋渡しすること**

です。

対象作業は以下。

* 事務作業の自動化
* ファイル加工
* ファイルデータ修正
* CSV / JSON / TXT の一括変換
* データの整形・検証・出力

---

# 全体構成

```text
非プログラミング学習
  ↓
AIによるファイル処理
  ↓
橋渡しフェーズ
  ↓
Python基礎
  ↓
Python Batch Job Pipeline
  ↓
SQLite
  ↓
FastAPI
  ↓
Jinja + Ajax
  ↓
Docker Compose
```

---

# Phase 1：非プログラミング学習

## 目的

まずはコードを書かずに、AIで作業を置き換える。

## 学習項目

* Windowsのファイル操作
* VSCodeの基本操作
* WSLの基本理解
* Claude Codeの基本操作
* Cursor / Codexの位置づけ
* CSV / JSON / TXT の違い
* AIへの作業指示の出し方

## 到達点

```text
人力でやっていたファイル加工作業を
Claude Codeに依頼できる
```

---

# Phase 2：Claude Codeによる一括処理

## 目的

非プログラミング作業をAIで実務的に処理する。

## 学習項目

* 複数ファイルの一括変換
* CSVの列削除
* カラム名変更
* 値の置換
* 欠損データ修正
* JSON整形
* TXTログの整形
* 出力ファイルの生成
* 変更前後の差分確認

## 到達点

```text
Claude Codeを使って
ファイル加工・修正・変換を一括処理できる
```

---

# Phase 3：橋渡しフェーズ

ここが最重要。

## 目的

AIがやっていた処理を、プログラム構造として理解する。

## 学習項目

```text
入力
↓
読み込み
↓
変換
↓
検証
↓
出力
```

## 重要概念

```text
load
↓
transform
↓
validate
↓
save
```

## 到達点

```text
Claude Codeが生成した処理を
「何をしているコードか」読める
```

---

# Phase 4：Python基礎

## 方針

Python基礎は深掘りしない。

テーマは **偶数チェッカー程度で十分**。

ただし、単なるおもちゃではなく、ファイル処理の最小モデルとして扱う。

## 学習項目

* print
* 変数
* if
* for
* list
* dict
* 関数

## 教材テーマ

```text
偶数チェッカー
```

## 発展形

```text
数字を読む
↓
偶数か判定する
↓
結果を出力する
```

## 到達点

```text
入力 → 判定 → 出力
```

を理解する。

---

# Phase 5：Python Batch Job Pipeline

## 目的

偶数チェッカーを、実務ファイル処理へ拡張する。

## 学習項目

* main.py
* loader.py
* transformer.py
* validator.py
* exporter.py
* logging
* try / except
* 実行引数
* エラー時のログ確認

## 構成例

```text
batch/
  ├── main.py
  ├── loader.py
  ├── transformer.py
  ├── validator.py
  └── exporter.py
```

## 到達点

```text
CSV / JSON / TXT を読み込み
加工して
別ファイルへ出力できる
```

---

# Phase 6：SQLite

## 位置づけ

SQLiteは主役ではなく、処理結果の保存先。

## 学習項目

* DBとは何か
* SQLiteとは何か
* テーブル
* insert
* select
* update
* delete
* PythonからSQLite操作

## 到達点

```text
加工結果をDBに保存できる
```

---

# Phase 7：FastAPI

## 位置づけ

APIは主役ではなく、処理結果確認用。

## 学習項目

* APIとは何か
* GET
* POST
* JSONレスポンス
* SQLiteから取得
* 処理結果の取得API

## 到達点

```text
保存済みデータをAPI経由で確認できる
```

---

# Phase 8：Web UI Jinja + Ajax

## 位置づけ

UIは確認・修正用。

## 学習項目

* Jinja
* HTMLテンプレート
* Ajax / fetch
* 一覧表示
* 手動修正
* 再送信

## 到達点

```text
ファイル処理結果を画面で確認・修正できる
```

---

# Phase 9：Docker Compose

## 目的

環境依存を減らす。

## 学習項目

* Dockerとは何か
* Dockerfile
* docker-compose.yml
* batchコンテナ
* apiコンテナ
* SQLiteファイル永続化

## 到達点

```bash
docker compose up
```

で一式動く。

---

# 最終成果物

## 作るもの

**Claude Code + Python によるファイル加工支援アプリ**

## 処理の流れ

```text
inputファイル
↓
Claude Code / Python Batch
↓
データ加工
↓
SQLite保存
↓
FastAPIで確認
↓
Jinja + Ajaxで表示・修正
↓
Docker Composeで起動
```

---

# 設計上の結論

この教材の主役はWebアプリではない。

主役は、

```text
ファイル処理
データ加工
一括修正
Claude Codeによる作業自動化
Pythonへの橋渡し
```

です。

そのため、Python基礎は偶数チェッカー程度で十分。
ただし、偶数チェッカーを

```text
入力 → 判定 → 出力
```

として扱い、後続のBatch Pipelineへ接続するのが重要です。
