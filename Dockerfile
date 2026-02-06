# ============================================================
# multi-agent-shogun Dockerfile
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

# 作業ディレクトリ作成
WORKDIR /workspace

# Claude Code CLI インストール（グローバル）
RUN npm install -g @anthropic-ai/claude-code

# tmux 設定（マウス有効化）
RUN echo "set -g mouse on" > /root/.tmux.conf

# multi-agent-shogun クローン
RUN git clone https://github.com/yohey-w/multi-agent-shogun.git /workspace/multi-agent-shogun

# 作業ディレクトリを multi-agent-shogun に設定
WORKDIR /workspace/multi-agent-shogun

# スクリプトに実行権限付与
RUN chmod +x *.sh

# first_setup.sh を実行（依存関係の初期化）
# ただし対話的な部分はスキップするため、非対話モードで実行
RUN bash -c "yes | ./first_setup.sh" || true

# エントリーポイント: tmux セッションを永続化するためのスクリプト
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# コンテナ起動時のコマンド
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sleep", "infinity"]
