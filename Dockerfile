# ============================================================
# Claude Code 実行環境 Dockerfile
# Ubuntu 24.04 + tmux + Node.js 18+ + Claude Code CLI
# ============================================================

FROM ubuntu:24.04

# 環境変数設定
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8

# 基本パッケージ + tmux + Node.js 依存関係
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    tmux \
    locales \
    ca-certificates \
    gnupg \
    && locale-gen ja_JP.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Node.js 18.x インストール（公式リポジトリから）
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Claude Code CLI インストール（グローバル）
RUN npm install -g @anthropic-ai/claude-code

# tmux 設定（マウス有効化）
RUN echo "set -g mouse on" > /root/.tmux.conf

# 作業ディレクトリ
WORKDIR /workspace

# エントリーポイント
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sleep", "infinity"]
