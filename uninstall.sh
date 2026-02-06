#!/bin/bash
# ============================================================
# multi-agent-shogun アンインストールスクリプト
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
# エンジン検出
# ============================================================

detect_engine() {
    if command -v podman &> /dev/null; then
        ENGINE="podman"
        # sudo 要否チェック
        if podman info &> /dev/null; then
            SUDO=""
        else
            SUDO="sudo"
        fi
    elif command -v docker &> /dev/null; then
        ENGINE="docker"
        # sudo 要否チェック
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
echo "🗑️  multi-agent-shogun アンインストール"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

detect_engine

log_info "使用エンジン: $ENGINE"
log_info "sudo: ${SUDO:-不要}"
echo ""

log_warn "以下を削除します:"
echo "  - コンテナ: multi-agent-shogun"
echo "  - ボリューム: shogun-data（全データが削除されます）"
echo "  - ネットワーク: shogun-network"
echo "  - イメージ: multi-agent-shogun:latest"
echo ""

read -p "本当に削除しますか？ [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_info "キャンセルしました"
    exit 0
fi

echo ""
log_info "削除中..."

# コンテナ停止・削除
if $SUDO $ENGINE ps -a 2>/dev/null | grep -q multi-agent-shogun; then
    log_info "コンテナを停止・削除中..."
    $SUDO $ENGINE stop multi-agent-shogun 2>/dev/null || true
    $SUDO $ENGINE rm -f multi-agent-shogun
else
    log_warn "コンテナが見つかりません（スキップ）"
fi

# ボリューム削除
if $SUDO $ENGINE volume ls 2>/dev/null | grep -q shogun-data; then
    log_info "ボリュームを削除中..."
    $SUDO $ENGINE volume rm shogun-data
else
    log_warn "ボリュームが見つかりません（スキップ）"
fi

# ネットワーク削除
if $SUDO $ENGINE network ls 2>/dev/null | grep -q shogun-network; then
    log_info "ネットワークを削除中..."
    $SUDO $ENGINE network rm shogun-network
else
    log_warn "ネットワークが見つかりません（スキップ）"
fi

# イメージ削除
if $SUDO $ENGINE images 2>/dev/null | grep -q multi-agent-shogun; then
    log_info "イメージを削除中..."
    $SUDO $ENGINE rmi multi-agent-shogun:latest
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
