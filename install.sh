#!/bin/bash
# ============================================================
# multi-agent-shogun ワンライナーインストール
# curl -fsSL https://raw.githubusercontent.com/USERNAME/multi-agent-shogun-podman/main/install.sh | bash
# ============================================================

set -e

# 色定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================================
# 設定
# ============================================================

REPO_URL="https://github.com/USERNAME/multi-agent-shogun-podman.git"
INSTALL_DIR="$HOME/multi-agent-shogun-env"

# ============================================================
# メイン処理
# ============================================================

echo ""
echo "  ╔══════════════════════════════════════════════════════════════╗"
echo "  ║  🏯 multi-agent-shogun インストーラー                         ║"
echo "  ║     ワンライナーセットアップ                                  ║"
echo "  ╚══════════════════════════════════════════════════════════════╝"
echo ""

# Git確認
if ! command -v git &> /dev/null; then
    log_error "git がインストールされていません"
    log_info "インストール: sudo apt update && sudo apt install -y git"
    exit 1
fi

# インストール先確認
if [ -d "$INSTALL_DIR" ]; then
    log_warn "インストール先が既に存在します: $INSTALL_DIR"
    read -p "削除して再インストールしますか？ [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        log_info "削除中..."
        rm -rf "$INSTALL_DIR"
    else
        log_info "キャンセルしました"
        exit 0
    fi
fi

# リポジトリをクローン
log_info "リポジトリをクローン中..."
git clone "$REPO_URL" "$INSTALL_DIR"

if [ $? -ne 0 ]; then
    log_error "クローンに失敗しました"
    log_info "リポジトリURL: $REPO_URL"
    exit 1
fi

log_success "クローン完了"

# ディレクトリに移動
cd "$INSTALL_DIR"

# setup.sh に実行権限付与
chmod +x setup.sh uninstall.sh update.sh entrypoint.sh

# setup.sh を実行
echo ""
log_info "セットアップを開始します..."
echo ""

./setup.sh

# 完了メッセージ
if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ インストール完了！"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    log_info "インストール先: $INSTALL_DIR"
    echo ""
else
    log_error "セットアップに失敗しました"
    exit 1
fi
