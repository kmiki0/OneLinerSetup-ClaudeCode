#!/bin/bash
# ============================================================
# entrypoint.sh - コンテナ起動時の初期化スクリプト
# tmux セッションの準備とコンテナの永続化
# ============================================================

set -e

echo "🏯 multi-agent-shogun コンテナ起動中..."

# Anthropic API キーの確認
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "⚠️  警告: ANTHROPIC_API_KEY が設定されていません"
    echo "   コンテナ起動時に -e ANTHROPIC_API_KEY=your-key を指定してください"
fi

# tmux サーバーの起動確認
tmux -V
echo "✅ tmux 準備完了"

# Node.js と Claude Code CLI の確認
node --version
claude --version
echo "✅ Claude Code CLI 準備完了"

# 作業ディレクトリの確認
cd /workspace/multi-agent-shogun
echo "✅ 作業ディレクトリ: $(pwd)"

# 起動完了メッセージ
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏯 multi-agent-shogun 準備完了"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📌 コンテナに入る方法:"
echo "   podman exec -it multi-agent-shogun bash"
echo ""
echo "📌 起動方法:"
echo "   cd /workspace/multi-agent-shogun"
echo "   ./shutsujin_departure.sh"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# コンテナを永続化（無限ループ）
exec "$@"
