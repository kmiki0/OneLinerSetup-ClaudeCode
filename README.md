# 🤖 Claude Code 実行環境 - Podman / Docker セットアップ

**WSL2 + podman/docker 環境で Claude Code をワンコマンドでセットアップ**

---

## 📋 概要

このリポジトリは、[Claude Code](https://docs.anthropic.com/en/docs/claude-code) を WSL2 + podman/docker のコンテナ環境で簡単にセットアップするためのツールです。

**特徴:**
- ✅ ワンコマンドでセットアップ完了
- ✅ podman / docker 両対応（自動検出）
- ✅ rootless podman 対応
- ✅ APIキーの安全な管理
- ✅ データ永続化（ボリューム使用）
- ✅ tmux によるターミナル分割対応

---

## 🚀 クイックスタート

### 前提条件

- Windows 11 または Windows 10（WSL2対応版）
- WSL2 がインストール済み
- Anthropic API Key（[取得先](https://console.anthropic.com/)）

---

### 超簡単インストール（推奨）✨

```bash
# 1. WSL2 に入る
wsl

# 2. ワンライナー実行（これだけ！）
curl -fsSL https://raw.githubusercontent.com/kmiki0/OneLinerSetup-ClaudeCode/main/install.sh | bash
```

---

### 手動インストール

```bash
# WSL2 に入る
wsl

# リポジトリをクローン
git clone https://github.com/kmiki0/OneLinerSetup-ClaudeCode.git
cd OneLinerSetup-ClaudeCode

# セットアップ実行
./setup.sh
```

**インストールが完了したら、すぐに使えます！** 🎉

```bash
# コンテナに入る
sudo podman exec -it claude-code-env bash
# または docker の場合
sudo docker exec -it claude-code-env bash

# Claude Code を起動
claude
```

---

### セットアップ時の選択肢

#### 自動検出（デフォルト）

```bash
./setup.sh
# → podman または docker を自動検出
```

#### エンジンを明示的に指定

```bash
# podman を使用
./setup.sh --engine=podman

# docker を使用
./setup.sh --engine=docker
```

#### 対話式で選択

```bash
./setup.sh --select-engine
```

#### APIキーを引数で渡す

```bash
./setup.sh --api-key="sk-ant-api03-xxxxx"
```

#### 環境変数で渡す

```bash
export ANTHROPIC_API_KEY="sk-ant-api03-xxxxx"
./setup.sh
```

---

## 📚 使い方

### コンテナに入る

```bash
# podman の場合
sudo podman exec -it claude-code-env bash

# docker の場合
sudo docker exec -it claude-code-env bash
# または（docker グループに所属している場合）
docker exec -it claude-code-env bash
```

### Claude Code を起動

```bash
# コンテナ内で
claude
```

### tmux を使う（ターミナル分割）

```bash
# コンテナ内で新しい tmux セッションを作成
tmux new -s work

# セッション内でウィンドウを分割
# 水平分割: Ctrl+B → %
# 垂直分割: Ctrl+B → "

# セッションからデタッチ
# Ctrl+B → d

# セッションに再接続
tmux attach -t work
```

---

## 🔧 管理コマンド

### コンテナの操作

```bash
# 停止
sudo podman stop claude-code-env

# 再起動
sudo podman restart claude-code-env

# ログ確認
sudo podman logs claude-code-env

# リアルタイムログ
sudo podman logs -f claude-code-env

# コンテナ情報
sudo podman inspect claude-code-env
```

### Claude Code CLI の更新

```bash
./update.sh
```

### アンインストール

```bash
# 完全削除（データも消える）
./uninstall.sh
```

---

## 🗂️ ファイル構成

```
OneLinerSetup-ClaudeCode/
├── Dockerfile           # コンテナイメージ定義
├── entrypoint.sh        # コンテナ起動スクリプト
├── setup.sh             # ワンコマンドセットアップ
├── install.sh           # ワンライナーインストール
├── uninstall.sh         # アンインストールスクリプト
├── update.sh            # Claude Code CLI 更新スクリプト
└── README.md            # このファイル
```

---

## 🛠️ トラブルシューティング

### Q1: `podman: command not found`

**A:** setup.sh が自動でインストールします。手動でインストールする場合:

```bash
sudo apt update
sudo apt install -y podman
```

---

### Q2: `permission denied` エラー

**A:** sudo を使ってください:

```bash
sudo podman exec -it claude-code-env bash
```

または、docker グループに追加（docker の場合）:

```bash
sudo usermod -aG docker $USER
# ログアウト→ログインで反映
```

---

### Q3: API Key を変更したい

**A:** コンテナを再作成します:

```bash
# 既存コンテナを削除
sudo podman rm -f claude-code-env

# APIキーを指定して再作成
export ANTHROPIC_API_KEY="新しいキー"
./setup.sh
```

---

### Q4: コンテナが起動しない

**A:** ログを確認してください:

```bash
sudo podman logs claude-code-env
```

よくある原因:
- API Key が間違っている
- ポートが使用中
- ボリュームのマウントに失敗

---

### Q5: ビルドに失敗する

**A:** キャッシュをクリアして再ビルド:

```bash
# イメージを削除
sudo podman rmi claude-code-env:latest

# 再ビルド
./setup.sh
```

---

### Q6: Claude Code CLI が動かない

**A:** バージョン確認:

```bash
sudo podman exec -it claude-code-env bash
claude --version
node --version
```

手動で再インストール:

```bash
sudo podman exec -it claude-code-env bash
npm install -g @anthropic-ai/claude-code
```

---

## 📊 システム要件

| 項目 | 要件 |
|------|------|
| OS | Windows 11 / Windows 10 |
| WSL2 | バージョン 2.0.0 以上 |
| メモリ | 4GB 以上推奨 |
| ディスク | 10GB 以上の空き容量 |
| コンテナエンジン | podman または docker |

---

## 🔐 セキュリティ

### API Key の保護

- API Key は環境変数として渡され、コンテナ内でのみ使用されます
- ホスト側のファイルには保存されません
- コンテナを削除すると API Key も削除されます

### ボリュームの管理

- データは `claude-code-env-data` ボリュームに永続化されます
- アンインストール時に完全に削除されます

---

## 🤝 コントリビューション

Issue や Pull Request を歓迎します。

---

## 📜 ライセンス

MIT License

---

## 🔗 関連リンク

- [Claude Code ドキュメント](https://docs.anthropic.com/en/docs/claude-code)
- [Anthropic Console](https://console.anthropic.com/)
- [Podman](https://podman.io/)
- [Docker](https://www.docker.com/)

---

## 💡 ヒント

### エイリアスの設定

WSL の `.bashrc` に追加すると便利:

```bash
# ~/.bashrc に追加
alias claude-enter='sudo podman exec -it claude-code-env bash'
alias claude-logs='sudo podman logs -f claude-code-env'
alias claude-restart='sudo podman restart claude-code-env'
```

反映:

```bash
source ~/.bashrc
```

使用例:

```bash
claude-enter
claude-logs
claude-restart
```
