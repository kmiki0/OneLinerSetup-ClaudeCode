#!/bin/bash
# ============================================================
# Claude Code CLI 更新スクリプト
# podman / docker 両対応
# ============================================================

set -e

# 色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================================
# 定数
# ============================================================

CONTAINER_NAME="claude-code-env"

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
echo "🔄 Claude Code CLI 更新"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

detect_engine

log_info "使用エンジン: $ENGINE"
echo ""

# コンテナが起動しているか確認
if ! $SUDO $ENGINE ps 2>/dev/null | grep -q "$CONTAINER_NAME"; then
    log_error "コンテナが起動していません"
    log_info "起動: $SUDO $ENGINE start $CONTAINER_NAME"
    exit 1
fi

log_info "Claude Code CLI を更新中..."
echo ""

$SUDO $ENGINE exec -it "$CONTAINER_NAME" bash -c "
echo '📥 Claude Code CLI を最新版に更新中...'
npm install -g @anthropic-ai/claude-code
echo ''
echo '📌 更新後のバージョン:'
claude --version
"

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ 更新完了"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
else
    log_error "更新に失敗しました"
    exit 1
fi
