import { useState } from "react";

const colors = {
  win: { bg: "#1e1b2e", border: "#6366f1", text: "#c7c4f0" },
  wsl: { bg: "#16213e", border: "#38bdf8", text: "#7dd3fc" },
  setup: { bg: "#1a1a2e", border: "#10b981", text: "#6ee7b7" },
  engine: { bg: "#1e293b", border: "#f59e0b", text: "#fbbf24" },
  container: { bg: "#1e293b", border: "#f472b6", text: "#f9a8d4" },
  claude: { bg: "#2d1b3d", border: "#c084fc", text: "#e9d5ff" },
  management: { bg: "#1a1a2e", border: "#facc15", text: "#fde047" },
  anthropic: { bg: "#1a1a2e", border: "#10b981", text: "#6ee7b7" },
  arrow: "#64748b",
  arrowActive: "#38bdf8",
};

const Arrow = ({ label }) => (
  <div className="flex flex-col items-center my-1">
    {label && (
      <span style={{ color: colors.arrowActive, fontSize: 9, fontFamily: "'JetBrains Mono', monospace", letterSpacing: 0.5 }}>
        {label}
      </span>
    )}
    <div style={{ color: colors.arrow, fontSize: 16, lineHeight: 1 }}>↓</div>
  </div>
);

const Box = ({ color, title, subtitle, children, style, className = "" }) => (
  <div
    className={`rounded-lg border ${className}`}
    style={{
      background: color.bg,
      borderColor: color.border,
      borderWidth: 1.5,
      padding: "8px 10px",
      ...style,
    }}
  >
    <div className="flex items-center gap-2 mb-1">
      <div style={{ width: 6, height: 6, borderRadius: "50%", background: color.border, boxShadow: `0 0 5px ${color.border}55` }} />
      <span style={{ color: color.text, fontSize: 11, fontWeight: 700, fontFamily: "'JetBrains Mono', monospace" }}>{title}</span>
    </div>
    {subtitle && (
      <span style={{ color: color.text + "99", fontSize: 8, fontFamily: "'JetBrains Mono', monospace" }}>{subtitle}</span>
    )}
    {children}
  </div>
);

export default function App() {
  const [showDetails, setShowDetails] = useState(true);
  const [selectedEngine, setSelectedEngine] = useState("auto");

  return (
    <div style={{ background: "#0d0f14", minHeight: "100vh", padding: "20px 14px", fontFamily: "'JetBrains Mono', monospace" }}>
      {/* Title */}
      <div className="text-center mb-3">
        <h1 style={{ color: "#e2e0f0", fontSize: 16, fontWeight: 800, letterSpacing: -0.5 }}>
          🤖 Claude Code 実行環境 ワンライナーセットアップ
        </h1>
        <p style={{ color: "#5c5c7a", fontSize: 9, marginTop: 1 }}>curl 1行で完了 | podman / docker 両対応</p>
      </div>

      {/* Controls */}
      <div className="flex justify-center gap-2 mb-3 flex-wrap">
        <button
          onClick={() => setShowDetails(!showDetails)}
          className="rounded-full px-3 py-1 text-xs font-bold transition-all"
          style={{
            fontFamily: "'JetBrains Mono', monospace",
            background: showDetails ? "#6366f1" : "#1e1b2e",
            color: showDetails ? "#fff" : "#7c7c9c",
            border: `1px solid ${showDetails ? "#6366f1" : "#3a3a5c"}`,
            cursor: "pointer",
            fontSize: 9,
          }}
        >
          {showDetails ? "詳細表示" : "簡易表示"}
        </button>

        <select
          value={selectedEngine}
          onChange={(e) => setSelectedEngine(e.target.value)}
          className="rounded-full px-3 py-1 text-xs font-bold"
          style={{
            fontFamily: "'JetBrains Mono', monospace",
            background: "#1e1b2e",
            color: "#fff",
            border: "1px solid #3a3a5c",
            cursor: "pointer",
            fontSize: 9,
          }}
        >
          <option value="auto">エンジン: 自動検出</option>
          <option value="podman">エンジン: podman</option>
          <option value="docker">エンジン: docker</option>
        </select>
      </div>

      <div className="flex flex-col items-center">
        {/* ============ WINDOWS ============ */}
        <Box color={colors.win} title="Windows" subtitle="PowerShell / Terminal" style={{ width: 520, maxWidth: "100%" }}>
          <div className="flex flex-col gap-1.5 mt-1.5">
            <div className="rounded px-2 py-1" style={{ background: "#2e2b45", border: "1px solid #6366f144" }}>
              <span style={{ color: "#a5a3c4", fontSize: 9 }}>💻 wsl</span>
            </div>
          </div>
        </Box>

        <Arrow label="wsl" />

        {/* ============ WSL2 ============ */}
        <Box color={colors.wsl} title="WSL2" subtitle="Ubuntu" style={{ width: 520, maxWidth: "100%" }}>
          <div className="flex flex-col gap-1.5 mt-1.5">
            <div className="rounded px-2 py-1" style={{ background: "#1a2940", border: "1px solid #38bdf444" }}>
              <span style={{ color: "#7dd3fc", fontSize: 9 }}>
                🚀 curl -fsSL https://raw.../install.sh | bash
              </span>
            </div>
            <div className="text-center" style={{ padding: "4px 0" }}>
              <span style={{ color: "#64748b", fontSize: 8 }}>↓ install.sh が自動実行</span>
            </div>
            <div className="rounded px-2 py-1" style={{ background: "#1a294022", border: "1px solid #38bdf422" }}>
              <span style={{ color: "#7dd3fc88", fontSize: 8 }}>
                📥 git clone → ./setup.sh 実行
              </span>
            </div>
          </div>
        </Box>

        <Arrow label="ワンコマンド実行" />

        {/* ============ SETUP.SH ============ */}
        <Box color={colors.setup} title="setup.sh" subtitle="自動セットアップ" style={{ width: 520, maxWidth: "100%" }}>
          {showDetails && (
            <div className="flex flex-col gap-1 mt-1.5">
              <div className="rounded px-2 py-0.5" style={{ background: "#10b98111", border: "1px solid #10b98133" }}>
                <span style={{ color: "#6ee7b7", fontSize: 8 }}>✅ 1. エンジン検出 ({selectedEngine === "auto" ? "podman/docker" : selectedEngine})</span>
              </div>
              <div className="rounded px-2 py-0.5" style={{ background: "#10b98111", border: "1px solid #10b98133" }}>
                <span style={{ color: "#6ee7b7", fontSize: 8 }}>✅ 2. 必要に応じてインストール</span>
              </div>
              <div className="rounded px-2 py-0.5" style={{ background: "#10b98111", border: "1px solid #10b98133" }}>
                <span style={{ color: "#6ee7b7", fontSize: 8 }}>✅ 3. API Key 入力</span>
              </div>
              <div className="rounded px-2 py-0.5" style={{ background: "#10b98111", border: "1px solid #10b98133" }}>
                <span style={{ color: "#6ee7b7", fontSize: 8 }}>✅ 4. ネットワーク・ボリューム作成</span>
              </div>
              <div className="rounded px-2 py-0.5" style={{ background: "#10b98111", border: "1px solid #10b98133" }}>
                <span style={{ color: "#6ee7b7", fontSize: 8 }}>✅ 5. イメージビルド</span>
              </div>
              <div className="rounded px-2 py-0.5" style={{ background: "#10b98111", border: "1px solid #10b98133" }}>
                <span style={{ color: "#6ee7b7", fontSize: 8 }}>✅ 6. コンテナ起動</span>
              </div>
              <div className="rounded px-2 py-0.5" style={{ background: "#10b98111", border: "1px solid #10b98133" }}>
                <span style={{ color: "#6ee7b7", fontSize: 8 }}>✅ 7. ヘルスチェック</span>
              </div>
            </div>
          )}
        </Box>

        <Arrow />

        {/* ============ ENGINE SELECTION ============ */}
        <Box color={colors.engine} title={selectedEngine === "auto" ? "エンジン自動検出" : `選択: ${selectedEngine}`} subtitle="podman / docker" style={{ width: 520, maxWidth: "100%" }}>
          <div className="flex items-center justify-center gap-2 mt-1.5 flex-wrap">
            <div className="rounded px-2 py-1" style={{ background: selectedEngine === "docker" ? "#1a2940" : "#f59e0b22", border: `1px solid ${selectedEngine === "docker" ? "#38bdf444" : "#f59e0b44"}` }}>
              <span style={{ color: selectedEngine === "docker" ? "#7dd3fc" : "#fbbf24", fontSize: 8 }}>
                🐳 {selectedEngine === "docker" ? "✓ " : ""}podman
              </span>
            </div>
            <div className="rounded px-2 py-1" style={{ background: selectedEngine === "podman" ? "#1a2940" : "#f59e0b22", border: `1px solid ${selectedEngine === "podman" ? "#38bdf444" : "#f59e0b44"}` }}>
              <span style={{ color: selectedEngine === "podman" ? "#7dd3fc" : "#fbbf24", fontSize: 8 }}>
                🐋 {selectedEngine === "podman" ? "✓ " : ""}docker
              </span>
            </div>
          </div>
        </Box>

        <Arrow label="ビルド・起動" />

        {/* ============ CONTAINER ============ */}
        <Box color={colors.container} title="Container: claude-code-env" subtitle="Ubuntu 24.04" style={{ width: 520, maxWidth: "100%" }}>
          {showDetails && (
            <div className="rounded border mb-1.5 mt-1.5" style={{ background: "#1a1a2e", borderColor: "#64748b44", padding: "4px 6px" }}>
              <div className="flex flex-col gap-0.5">
                <div className="flex items-center gap-1">
                  <span style={{ color: "#64748b", fontSize: 7 }}>•</span>
                  <span style={{ color: "#94a3b8", fontSize: 7 }}>tmux</span>
                </div>
                <div className="flex items-center gap-1">
                  <span style={{ color: "#64748b", fontSize: 7 }}>•</span>
                  <span style={{ color: "#94a3b8", fontSize: 7 }}>Node.js 18.x</span>
                </div>
                <div className="flex items-center gap-1">
                  <span style={{ color: "#64748b", fontSize: 7 }}>•</span>
                  <span style={{ color: "#94a3b8", fontSize: 7 }}>Claude Code CLI (latest)</span>
                </div>
              </div>
            </div>
          )}

          {/* Claude Code */}
          <div className="rounded-lg border" style={{ background: "#0f0f1a", borderColor: "#c084fc44", borderWidth: 1, padding: "6px" }}>
            <div className="flex items-center gap-1 mb-1.5">
              <div style={{ width: 4, height: 4, borderRadius: "50%", background: "#c084fc" }} />
              <span style={{ color: "#e9d5ff", fontSize: 8, fontWeight: 600 }}>Claude Code CLI</span>
            </div>
            <div className="flex flex-col items-center gap-1">
              <div
                className="rounded-md border flex flex-col items-center justify-center text-center"
                style={{
                  background: colors.claude.bg,
                  borderColor: colors.claude.border,
                  borderWidth: 1,
                  padding: "6px 12px",
                  minWidth: 120,
                }}
              >
                <span style={{ color: colors.claude.text, fontSize: 10, fontWeight: 700, fontFamily: "'JetBrains Mono', monospace" }}>$ claude</span>
                <span style={{ color: colors.claude.text + "88", fontSize: 7, fontFamily: "'JetBrains Mono', monospace" }}>対話型 AI コーディング</span>
              </div>
            </div>
          </div>
        </Box>

        <Arrow label="API通信" />

        {/* ============ ANTHROPIC ============ */}
        <Box color={colors.anthropic} title="Anthropic" subtitle="外部API" style={{ width: 520, maxWidth: "100%" }}>
          <div className="flex items-center justify-center mt-1.5 gap-2 flex-wrap">
            <div className="rounded px-2 py-0.5" style={{ background: "#1a2a1e", border: "1px solid #10b98144" }}>
              <span style={{ color: "#6ee7b7", fontSize: 9 }}>🤖 Claude</span>
            </div>
            <div className="rounded px-2 py-0.5" style={{ background: "#1a2a1e", border: "1px solid #10b98144" }}>
              <span style={{ color: "#6ee7b7", fontSize: 9 }}>🔑 API Key</span>
            </div>
          </div>
        </Box>

        {/* ============ MANAGEMENT ============ */}
        {showDetails && (
          <>
            <div className="mt-3 w-full flex justify-center">
              <div style={{ width: 520, maxWidth: "100%", height: 1, background: "#2a2a3c" }} />
            </div>

            <div className="mt-3">
              <Box color={colors.management} title="管理コマンド" subtitle="update / uninstall" style={{ width: 520, maxWidth: "100%" }}>
                <div className="flex flex-col gap-1 mt-1.5">
                  <div className="rounded px-2 py-0.5" style={{ background: "#facc1511", border: "1px solid #facc1533" }}>
                    <span style={{ color: "#fde047", fontSize: 8 }}>🔄 ./update.sh - Claude Code CLI を最新版に更新</span>
                  </div>
                  <div className="rounded px-2 py-0.5" style={{ background: "#facc1511", border: "1px solid #facc1533" }}>
                    <span style={{ color: "#fde047", fontSize: 8 }}>🗑️ ./uninstall.sh - 完全削除</span>
                  </div>
                  <div className="rounded px-2 py-0.5" style={{ background: "#facc1511", border: "1px solid #facc1533" }}>
                    <span style={{ color: "#fde047", fontSize: 8 }}>
                      📊 {selectedEngine === "auto" ? "podman/docker" : selectedEngine} logs - ログ確認
                    </span>
                  </div>
                </div>
              </Box>
            </div>
          </>
        )}

        {/* ============ LEGEND ============ */}
        <div className="mt-4 rounded-lg border px-3 py-1.5" style={{ background: "#111318", borderColor: "#2a2a3c", width: 520, maxWidth: "100%" }}>
          <span style={{ color: "#5c5c7a", fontSize: 8, fontWeight: 600 }}>LEGEND</span>
          <div className="flex flex-wrap gap-2 mt-1">
            {[
              { color: colors.win.border, label: "Windows" },
              { color: colors.wsl.border, label: "WSL2" },
              { color: colors.setup.border, label: "Setup" },
              { color: colors.engine.border, label: "Engine" },
              { color: colors.container.border, label: "Container" },
              { color: colors.claude.border, label: "Claude Code" },
              { color: colors.anthropic.border, label: "Anthropic" },
              { color: colors.management.border, label: "Management" },
            ].map((item) => (
              <div key={item.label} className="flex items-center gap-1">
                <div style={{ width: 8, height: 8, borderRadius: 2, background: item.color }} />
                <span style={{ color: "#7c7c9c", fontSize: 7 }}>{item.label}</span>
              </div>
            ))}
          </div>
        </div>

        {/* ============ KEY FEATURES ============ */}
        <div className="mt-3 rounded-lg border px-3 py-1.5" style={{ background: "#111318", borderColor: "#2a2a3c", width: 520, maxWidth: "100%" }}>
          <span style={{ color: "#5c5c7a", fontSize: 8, fontWeight: 600 }}>✨ 特徴</span>
          <div className="flex flex-col gap-0.5 mt-1">
            {[
              "curl 1行でセットアップ完了",
              "podman / docker 自動検出",
              "rootless podman 対応",
              "データ永続化（ボリューム）",
              "tmux によるターミナル分割",
              "簡単な更新・削除",
            ].map((feature, i) => (
              <div key={i} className="flex items-start gap-1">
                <span style={{ color: "#64748b", fontSize: 7 }}>•</span>
                <span style={{ color: "#94a3b8", fontSize: 7 }}>{feature}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
