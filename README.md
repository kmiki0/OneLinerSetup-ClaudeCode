# 🏯 multi-agent-shogun - Podman / Docker セットアップ

**WSL2 + podman/docker 環境で multi-agent-shogun を動かすワンコマンドセットアップ**

---

## 📋 概要

このリポジトリは、[multi-agent-shogun](https://github.com/yohey-w/multi-agent-shogun) を WSL2 + podman/docker 環境で簡単にセットアップするためのツールです。

**特徴:**
- ✅ ワンコマンドでセットアップ完了
- ✅ podman / docker 両対応（自動検出）
- ✅ rootless podman 対応
- ✅ APIキーの安全な管理
- ✅ データ永続化（ボリューム使用）

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
curl -fsSL https://raw.githubusercontent.com/kmiki0/OneLinerSetup-MultiAgentShogun/main/install.sh | bash
```

---

### 手動インストール

```bash
# WSL2 に入る
wsl

# リポジトリをクローン
git clone https://github.com/kmiki0/OneLinerSetup-MultiAgentShogun.git
cd OneLinerSetup-MultiAgentShogun

# セットアップ実行
./setup.sh
```

**インストールが完了したら、すぐに使えます！** 🎉

```bash
# コンテナに入る
sudo podman exec -it multi-agent-shogun bash
# または docker の場合
sudo docker exec -it multi-agent-shogun bash

# コンテナ内で起動（作業ディレクトリに自動で入ります）
./shutsujin_departure.sh

# 将軍に接続（命令を出す）
tmux attach -t shogun
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
sudo podman exec -it multi-agent-shogun bash

# docker の場合
sudo docker exec -it multi-agent-shogun bash
# または（docker グループに所属している場合）
docker exec -it multi-agent-shogun bash
```

### multi-agent-shogun を起動

```bash
# コンテナ内で（作業ディレクトリに自動で入ります）
./shutsujin_departure.sh
```

### 将軍に接続

```bash
# コンテナ内で
tmux attach -t shogun
```

### 家老・足軽を確認

```bash
# コンテナ内で
tmux attach -t multiagent
```

### デタッチ（セッションから抜ける）

```
Ctrl+B → d
```

---

## 🔧 管理コマンド

### コンテナの操作

```bash
# 停止
sudo podman stop multi-agent-shogun

# 再起動
sudo podman restart multi-agent-shogun

# ログ確認
sudo podman logs multi-agent-shogun

# リアルタイムログ
sudo podman logs -f multi-agent-shogun

# コンテナ情報
sudo podman inspect multi-agent-shogun
```

### 更新

```bash
# multi-agent-shogun を最新版に更新
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
OneLinerSetup-MultiAgentShogun/
├── Dockerfile           # コンテナイメージ定義
├── entrypoint.sh        # コンテナ起動スクリプト
├── setup.sh             # ワンコマンドセットアップ
├── uninstall.sh         # アンインストールスクリプト
├── update.sh            # 更新スクリプト
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
sudo podman exec -it multi-agent-shogun bash
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
sudo podman rm -f multi-agent-shogun

# APIキーを指定して再作成
export ANTHROPIC_API_KEY="新しいキー"
./setup.sh
```

---

### Q4: コンテナが起動しない

**A:** ログを確認してください:

```bash
sudo podman logs multi-agent-shogun
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
sudo podman rmi multi-agent-shogun:latest

# 再ビルド
./setup.sh
```

---

### Q6: tmux が動かない

**A:** コンテナ内で確認:

```bash
sudo podman exec -it multi-agent-shogun bash
tmux -V
tmux ls
```

セッションを再作成:

```bash
./shutsujin_departure.sh
```

---

### Q7: Claude Code CLI が動かない

**A:** バージョン確認:

```bash
sudo podman exec -it multi-agent-shogun bash
claude --version
node --version
```

手動で再インストール:

```bash
sudo podman exec -it multi-agent-shogun bash
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

- データは `shogun-data` ボリュームに永続化されます
- アンインストール時に完全に削除されます

---

## 🤝 コントリビューション

Issue や Pull Request を歓迎します。

---

## 📜 ライセンス

MIT License

---

## 🔗 関連リンク

- [multi-agent-shogun 本家](https://github.com/yohey-w/multi-agent-shogun)
- [Anthropic Console](https://console.anthropic.com/)
- [Podman](https://podman.io/)
- [Docker](https://www.docker.com/)

---

## 💡 ヒント

### エイリアスの設定

WSL の `.bashrc` に追加すると便利:

```bash
# ~/.bashrc に追加
alias shogun-enter='sudo podman exec -it multi-agent-shogun bash'
alias shogun-logs='sudo podman logs -f multi-agent-shogun'
alias shogun-restart='sudo podman restart multi-agent-shogun'
```

反映:

```bash
source ~/.bashrc
```

使用例:

```bash
shogun-enter
shogun-logs
shogun-restart
```

---

**以上で完了です 🏯💚**

何か問題があれば Issue を作成してください。
