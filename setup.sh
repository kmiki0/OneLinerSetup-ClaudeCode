#!/bin/bash
# ============================================================
# Claude Code 実行環境 ワンコマンドセットアップ
# podman / docker 両対応
# ============================================================

set -e

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ログ関数
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================================
# 変数初期化
# ============================================================

CONTAINER_NAME="claude-code-env"
IMAGE_NAME="claude-code-env:latest"
VOLUME_NAME="claude-code-env-data"
NETWORK_NAME="claude-code-env-network"

CONTAINER_ENGINE=""
USE_SUDO=""
SELECT_ENGINE=false

# ============================================================
# 引数解析
# ============================================================

while [[ $# -gt 0 ]]; do
    case $1 in
        --engine=*)
            CONTAINER_ENGINE="${1#*=}"
            shift
            ;;
        --select-engine)
            SELECT_ENGINE=true
            shift
            ;;
        --api-key=*)
            ANTHROPIC_API_KEY="${1#*=}"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --engine=podman|docker    エンジンを明示的に指定"
            echo "  --select-engine           対話式でエンジンを選択"
            echo "  --api-key=KEY             Anthropic API Key を指定"
            echo "  --help, -h                このヘルプを表示"
            echo ""
            echo "Examples:"
            echo "  $0                              # 自動検出"
            echo "  $0 --engine=podman              # podman を使用"
            echo "  $0 --engine=docker              # docker を使用"
            echo "  $0 --select-engine              # 対話式選択"
            echo "  export ANTHROPIC_API_KEY=xxx"
            echo "  $0 --engine=docker              # 環境変数でAPIキー指定"
            exit 0
            ;;
        *)
            log_error "不明な引数: $1"
            echo "使い方: $0 --help"
            exit 1
            ;;
    esac
done

# ============================================================
# エンジン検出・選択
# ============================================================

detect_engine() {
    if [ -n "$CONTAINER_ENGINE" ]; then
        log_info "指定されたエンジン: $CONTAINER_ENGINE"
    elif [ "$SELECT_ENGINE" = true ]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  コンテナエンジンを選択してください"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "  1) podman (推奨)"
        echo "  2) docker"
        echo ""
        read -p "選択 [1-2]: " choice
        case $choice in
            1) CONTAINER_ENGINE="podman" ;;
            2) CONTAINER_ENGINE="docker" ;;
            *) log_error "無効な選択"; exit 1 ;;
        esac
    else
        # 自動検出
        if command -v podman &> /dev/null; then
            CONTAINER_ENGINE="podman"
            log_success "podman を検出しました"
        elif command -v docker &> /dev/null; then
            CONTAINER_ENGINE="docker"
            log_success "docker を検出しました"
        else
            log_warn "podman も docker も見つかりません"
            echo ""
            echo "どちらをインストールしますか？"
            echo "  1) podman（推奨・rootless対応）"
            echo "  2) docker（Docker Desktop等）"
            echo ""
            read -p "選択 [1-2]: " choice
            case $choice in
                1) CONTAINER_ENGINE="podman" ;;
                2) CONTAINER_ENGINE="docker" ;;
                *) log_error "無効な選択"; exit 1 ;;
            esac
        fi
    fi
}

# ============================================================
# sudo の要否判定
# ============================================================

check_sudo() {
    if [ "$CONTAINER_ENGINE" = "podman" ]; then
        if podman info &> /dev/null; then
            USE_SUDO=""
            log_success "rootless podman を使用"
        else
            USE_SUDO="sudo"
            log_warn "root権限が必要です"
        fi
    elif [ "$CONTAINER_ENGINE" = "docker" ]; then
        if docker info &> /dev/null 2>&1; then
            USE_SUDO=""
            log_success "docker を権限なしで使用"
        else
            USE_SUDO="sudo"
            log_warn "root権限が必要です"
            log_info "推奨: sudo usermod -aG docker \$USER でグループに追加"
        fi
    fi
}

# ============================================================
# エンジンのインストール
# ============================================================

install_engine() {
    if ! command -v "$CONTAINER_ENGINE" &> /dev/null; then
        log_info "$CONTAINER_ENGINE をインストール中..."

        if [ "$CONTAINER_ENGINE" = "podman" ]; then
            sudo apt update
            sudo apt install -y podman
            log_success "podman インストール完了"

        elif [ "$CONTAINER_ENGINE" = "docker" ]; then
            log_info "Docker 公式インストールスクリプトをダウンロード中..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            rm get-docker.sh

            sudo usermod -aG docker $USER
            log_success "docker インストール完了"
            log_warn "docker グループに追加しました"
            log_warn "ログアウト→ログインで反映されます"
            echo ""
            read -p "今すぐログアウトしますか？ [y/N]: " logout_now
            if [[ "$logout_now" =~ ^[Yy]$ ]]; then
                echo "ログアウト後、再度このスクリプトを実行してください"
                exit 0
            fi
        fi
    fi
}

# ============================================================
# メイン処理
# ============================================================

echo ""
echo "  ╔══════════════════════════════════════════════════════════════╗"
echo "  ║  🤖 Claude Code 実行環境 セットアップ                       ║"
echo "  ║     podman / docker 両対応                                   ║"
echo "  ╚══════════════════════════════════════════════════════════════╝"
echo ""

# エンジン検出・選択・インストール
detect_engine
install_engine
check_sudo

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📌 使用するエンジン: $CONTAINER_ENGINE"
echo "📌 sudo: ${USE_SUDO:-不要}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# APIキー確認
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "🔑 Anthropic API Key を入力してください:"
    echo "   (取得先: https://console.anthropic.com/)"
    read -s ANTHROPIC_API_KEY
    echo ""

    if [ -z "$ANTHROPIC_API_KEY" ]; then
        log_error "API Key が入力されていません"
        exit 1
    fi
fi

# APIキーの形式確認
if [[ ! "$ANTHROPIC_API_KEY" =~ ^sk-ant- ]]; then
    log_warn "API Key の形式が正しくない可能性があります"
    log_warn "通常は 'sk-ant-' で始まります"
    read -p "このまま続行しますか？ [y/N]: " continue_anyway
    if [[ ! "$continue_anyway" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 既存コンテナの確認
if $USE_SUDO $CONTAINER_ENGINE ps -a 2>/dev/null | grep -q "$CONTAINER_NAME"; then
    log_warn "既存のコンテナが見つかりました"
    echo "   削除して再作成しますか？ [y/N]"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        log_info "既存コンテナを削除中..."
        $USE_SUDO $CONTAINER_ENGINE rm -f "$CONTAINER_NAME"
        log_success "削除完了"
    else
        log_info "セットアップを中断しました"
        exit 0
    fi
fi

# ネットワーク作成
log_info "ネットワークを作成中..."
$USE_SUDO $CONTAINER_ENGINE network create "$NETWORK_NAME" 2>/dev/null || true

# ボリューム作成
log_info "ボリュームを作成中..."
$USE_SUDO $CONTAINER_ENGINE volume create "$VOLUME_NAME" 2>/dev/null || true

# ビルド
echo ""
log_info "イメージをビルド中... (数分かかります)"
echo ""
$USE_SUDO $CONTAINER_ENGINE build -t "$IMAGE_NAME" .

if [ $? -ne 0 ]; then
    log_error "ビルドに失敗しました"
    exit 1
fi

# 起動
echo ""
log_info "コンテナを起動中..."
$USE_SUDO $CONTAINER_ENGINE run -d \
  --name "$CONTAINER_NAME" \
  --network "$NETWORK_NAME" \
  -v "$VOLUME_NAME":/workspace \
  -e ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}" \
  --restart unless-stopped \
  -it \
  "$IMAGE_NAME"

if [ $? -ne 0 ]; then
    log_error "起動に失敗しました"
    log_info "ログを確認: $USE_SUDO $CONTAINER_ENGINE logs $CONTAINER_NAME"
    exit 1
fi

# ヘルスチェック
log_info "動作確認中..."
sleep 5

if $USE_SUDO $CONTAINER_ENGINE exec "$CONTAINER_NAME" claude --version &> /dev/null; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ セットアップ完了！"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📌 コンテナに入る:"
    echo "   $USE_SUDO $CONTAINER_ENGINE exec -it $CONTAINER_NAME bash"
    echo ""
    echo "📌 Claude Code を起動:"
    echo "   claude"
    echo ""
    echo "📌 エンジン情報:"
    echo "   使用中: $CONTAINER_ENGINE"
    echo "   sudo: ${USE_SUDO:-不要}"
    echo ""
    echo "📌 その他のコマンド:"
    echo "   停止:       $USE_SUDO $CONTAINER_ENGINE stop $CONTAINER_NAME"
    echo "   再起動:     $USE_SUDO $CONTAINER_ENGINE restart $CONTAINER_NAME"
    echo "   ログ確認:   $USE_SUDO $CONTAINER_ENGINE logs $CONTAINER_NAME"
    echo "   削除:       ./uninstall.sh"
    echo ""
else
    log_error "Claude Code CLI が動作していません"
    log_info "ログを確認: $USE_SUDO $CONTAINER_ENGINE logs $CONTAINER_NAME"
    exit 1
fi
