すみません、こちらの読み違いです。
聞きたいのは **「WSL内の作業パス」ではなく、Windows側で `ext4.vhdx` をどこに置くか** ですね。

結論：

# 教材用の推奨配置

```text
C:\WSL\Ubuntu\
```

または容量を考えるなら：

```text
D:\WSL\Ubuntu\
```

WSL2の実体は通常 `ext4.vhdx` という仮想ディスクで、既定では以下のような場所に置かれます。

```text
C:\Users\<Windowsユーザー名>\AppData\Local\Packages\<Ubuntuパッケージ名>\LocalState\ext4.vhdx
```

Microsoft公式にも、WSL distro の `.vhdx` は `%LOCALAPPDATA%\Packages\...\LocalState\ext4.vhdx` のようなパスにあると説明されています。([Microsoft Learn][1])

ただ、教材としてブレなくするなら、**Microsoft Store任せの既定パスにしない方がよい**です。

# 推奨方針

```text
C:\WSL\Ubuntu\
  └── ext4.vhdx
```

この形に固定する。

理由は単純で、

```text
AppData配下は深すぎる
ユーザー名に依存する
Package名が長くて教材向きではない
場所を説明しにくい
```

からです。

# 作成方法

今のWSLでは、インストール時に配置場所を指定できる `--location` オプションがあります。Microsoft公式の基本コマンドにも `--location` は「WSLディストリビューションをインストールするフォルダーを指定する」と説明されています。([Microsoft Learn][2])

例：

```powershell
wsl --install Ubuntu --location C:\WSL\Ubuntu
```

既に標準インストール済みなら、`export / import` で移動する方法もあります。Microsoft公式FAQでも、`wsl --export` でtarに出し、`wsl --import` で新しい場所を指定できると説明されています。([Microsoft Learn][3])

# 教材としての固定ルール

```text
WSL本体の保存場所：
C:\WSL\Ubuntu\

WSL内の作業場所：
/home/<user>/work/
```

これが一番ブレません。

[1]: https://learn.microsoft.com/en-us/windows/wsl/disk-space?utm_source=chatgpt.com "How to manage WSL disk space"
[2]: https://learn.microsoft.com/en-us/windows/wsl/basic-commands?utm_source=chatgpt.com "Basic commands for WSL"
[3]: https://learn.microsoft.com/ja-jp/windows/wsl/faq?utm_source=chatgpt.com "Linux 用 Windows サブシステムに関する FAQ"


承知しました。
前提は「WSL＋VSCode」「コマンド最小」「Gitはcloneのみ」なので、**操作を“必要最小限かつ固定パターン”に絞ります。**

---

# 結論（覚える操作はこれだけ）

👉 **「開く → 編集 → 実行 → 確認」だけに集約**

---

# VSCode（WSL前提）必須操作リスト

## 1. WSLでフォルダを開く

### 操作

* VSCode起動
* 左下「><」または「WSL」表示クリック
* 「WSLに接続」
* フォルダを開く

👉 到達状態

```text
左下に「WSL: Ubuntu」と表示される
```

👉 これが最重要確認ポイント

---

## 2. フォルダを開く（固定）

### 操作

```text
File → Open Folder
```

開く場所：

```text
/home/<user>/work/
```

👉 ここ以外は開かない

---

## 3. ファイル作成

### 操作

* Explorer（左のファイル一覧）
* 「新規ファイル」

例：

```text
main.py
```

---

## 4. ファイル編集

### 操作

* エディタにコードを書く
* 保存

ショートカット：

```text
Ctrl + S
```

👉 保存しない事故を防ぐため強調

---

## 5. ターミナルを開く

### 操作

```text
Ctrl + `
```

または

```text
Terminal → New Terminal
```

👉 必ずVSCode内ターミナルを使う（外部禁止）

---

## 6. Python実行

### 操作

```bash
python main.py
```

👉 これ1パターンのみ

---

## 7. 出力確認

### 操作

* ターミナルを見る
* エラーをそのままコピー

👉 Claude-Codeに貼る

---

## 8. ファイル確認

### 操作

* Explorerで確認
* output.json などを見る

---

## 9. 複数ファイル操作（最低限）

### 操作

* フォルダ作成
* ファイル移動（ドラッグ）

👉 CLI使わせない

---

## 10. Git Clone（初回のみ）

### 操作

ターミナルで：

```bash
git clone <URL>
```

👉 それ以外のGit操作は禁止

---

# あえて除外する操作（重要）

## ❌ 教えない

* Git（add / commit / push）
* デバッグ機能
* 拡張機能の詳細設定
* settings.json
* 仮想環境切替UI
* タスクランナー
* ワークスペース設定

👉 全部ノイズ

---

# 最小操作フロー（これだけ覚えればOK）

```text
① VSCodeでWSL接続
② workフォルダを開く
③ ファイル作成
④ コードを書く
⑤ Ctrl + S
⑥ ターミナルで python 実行
⑦ 結果確認
```

---

# 教材に入れるべき固定ルール

```text
・VSCodeはWSLモードで使う
・作業フォルダは work のみ
・ターミナルはVSCode内のみ使用
・コマンドは python と pip だけ
・Gitは clone だけ
```

---

# この設計の強み

## ① 認知負荷が極小

👉 覚える操作が10個未満

---

## ② Claude-Codeと完全連携

👉 エラー → コピペ → 解決

---

## ③ 環境依存トラブル激減

👉 操作パターンが固定

---

# 一言で

👉
**VSCodeは「高機能エディタ」ではなく「実行ボタン付きメモ帳」として使わせる**

---

この制約で設計すれば、非IT人材でもかなり高確率で突破できます。

結論から言います。
**教材として最も安定する順番はこれです。**

---

# 推奨インストール順（固定）

```text
① WSL（Ubuntu）
↓
② VSCode
↓
③ VSCode Remote - WSL 拡張
↓
④ VSCodeからWSL接続確認
↓
⑤ Python（WSL内）
↓
⑥ Git（WSL内・clone用）
```

---

# なぜこの順番か（重要な理由）

## ① 先にWSLを入れる

👉 ここが土台

* VSCodeは「どこに接続するか」で動作が変わる
* 先にWSLを用意しないと「Windows側Python」に流れる

👉 初心者事故の8割はこれ

---

## ② 次にVSCode

👉 役割はUI

* ここではまだ「普通にインストール」だけ
* 設定は一切教えない

---

## ③ Remote - WSL拡張

👉 これが橋

* VSCodeとWSLを繋ぐ唯一の重要拡張

👉 他の拡張は後回し or 不要

---

## ④ WSL接続確認（超重要）

状態確認：

```text
左下に「WSL: Ubuntu」
```

👉 これが出ないと全て失敗

---

## ⑤ Python（WSL内）

```bash
sudo apt update
sudo apt install python3 python3-pip -y
```

👉 必ずWSL内で入れる

---

## ⑥ Git（最小）

```bash
sudo apt install git -y
```

👉 clone専用

---

# NG順序（やると詰む）

## ❌ ① VSCode → WSL

👉 問題：

* Windows側で開発してしまう
* WSLと混ざる

---

## ❌ ② Python（Windows）→ WSL

👉 問題：

* python / python3 混乱
* パス事故

---

## ❌ ③ 拡張機能先に入れまくる

👉 問題：

* 何が必要か分からなくなる

---

# 教材用：最短手順（実用版）

## Step 1：WSL

```powershell
wsl --install -d Ubuntu --location C:\WSL\Ubuntu
```

---

## Step 2：VSCode

* インストールするだけ

---

## Step 3：WSL接続

* VSCode起動
* 「WSLに接続」

---

## Step 4：Python

```bash
python3 --version
```

（なければ install）

---

## Step 5：Git

```bash
git clone xxx
```

---

# 最終状態（成功条件）

```text
・VSCode左下に「WSL: Ubuntu」
・ターミナルで python 実行できる
・/home/<user>/work が使える
```

---

# 一言で

👉
**「実行環境（WSL）→ 操作UI（VSCode）」の順に作る**

---

この順番に固定すれば、

* Windows側に流れる事故
* Python二重環境
* パス混乱

ほぼ全部潰せます。
