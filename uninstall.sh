#!/bin/bash
# ============================================================
# Claude Code 実行環境 アンインストールスクリプト
# podman / docker 両対応
# ============================================================

set -e

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================================
# 定数
# ============================================================

CONTAINER_NAME="claude-code-env"
IMAGE_NAME="claude-code-env:latest"
VOLUME_NAME="claude-code-env-data"
NETWORK_NAME="claude-code-env-network"

# ============================================================
# エンジン検出
# ============================================================

detect_engine() {
    if command -v podman &> /dev/null; then
        ENGINE="podman"
        if podman info &> /dev/null; then
            SUDO=""
        else
            SUDO="sudo"
        fi
    elif command -v docker &> /dev/null; then
        ENGINE="docker"
        if docker info &> /dev/null 2>&1; then
            SUDO=""
        else
            SUDO="sudo"
        fi
    else
        log_error "podman も docker も見つかりません"
        exit 1
    fi
}

# ============================================================
# メイン処理
# ============================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🗑️  Claude Code 実行環境 アンインストール"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

detect_engine

log_info "使用エンジン: $ENGINE"
log_info "sudo: ${SUDO:-不要}"
echo ""

log_warn "以下を削除します:"
echo "  - コンテナ: $CONTAINER_NAME"
echo "  - ボリューム: $VOLUME_NAME（全データが削除されます）"
echo "  - ネットワーク: $NETWORK_NAME"
echo "  - イメージ: $IMAGE_NAME"
echo ""

read -p "本当に削除しますか？ [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_info "キャンセルしました"
    exit 0
fi

echo ""
log_info "削除中..."

# コンテナ停止・削除
if $SUDO $ENGINE ps -a 2>/dev/null | grep -q "$CONTAINER_NAME"; then
    log_info "コンテナを停止・削除中..."
    $SUDO $ENGINE stop "$CONTAINER_NAME" 2>/dev/null || true
    $SUDO $ENGINE rm -f "$CONTAINER_NAME"
else
    log_warn "コンテナが見つかりません（スキップ）"
fi

# ボリューム削除
if $SUDO $ENGINE volume ls 2>/dev/null | grep -q "$VOLUME_NAME"; then
    log_info "ボリュームを削除中..."
    $SUDO $ENGINE volume rm "$VOLUME_NAME"
else
    log_warn "ボリュームが見つかりません（スキップ）"
fi

# ネットワーク削除
if $SUDO $ENGINE network ls 2>/dev/null | grep -q "$NETWORK_NAME"; then
    log_info "ネットワークを削除中..."
    $SUDO $ENGINE network rm "$NETWORK_NAME"
else
    log_warn "ネットワークが見つかりません（スキップ）"
fi

# イメージ削除
if $SUDO $ENGINE images 2>/dev/null | grep -q claude-code-env; then
    log_info "イメージを削除中..."
    $SUDO $ENGINE rmi "$IMAGE_NAME"
else
    log_warn "イメージが見つかりません（スキップ）"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ アンインストール完了"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
log_info "セットアップファイルは削除されていません"
log_info "再インストール: ./setup.sh"
echo ""
