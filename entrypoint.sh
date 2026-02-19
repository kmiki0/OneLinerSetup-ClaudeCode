#!/bin/bash
# ============================================================
# entrypoint.sh - コンテナ起動時の初期化スクリプト
# ============================================================

set -e

echo "🤖 Claude Code 実行環境 起動中..."

# Anthropic API キーの確認
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "⚠️  警告: ANTHROPIC_API_KEY が設定されていません"
    echo "   コンテナ起動時に -e ANTHROPIC_API_KEY=your-key を指定してください"
fi

# tmux 確認
tmux -V
echo "✅ tmux 準備完了"

# Node.js と Claude Code CLI の確認
node --version
claude --version
echo "✅ Claude Code CLI 準備完了"

echo "✅ 作業ディレクトリ: $(pwd)"

# 起動完了メッセージ
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 Claude Code 実行環境 準備完了"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📌 コンテナに入る方法:"
echo "   podman exec -it claude-code-env bash"
echo ""
echo "📌 Claude Code を起動:"
echo "   claude"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# コンテナを永続化
exec "$@"
