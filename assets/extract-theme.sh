#!/usr/bin/env bash
# proto-gen · 主题抽取脚本
# 用法：
#   ./extract-theme.sh <tweakcn-url-or-theme-id> [output-path]
# 例：
#   ./extract-theme.sh https://tweakcn.com/themes/cmpm3t0xk000104jq47h88i1g
#   ./extract-theme.sh cmpm3t0xk000104jq47h88i1g
#   ./extract-theme.sh cmpm3t0xk000104jq47h88i1g ./my-project/theme.css
#
# 输出：theme.css（含 19 个 shadcn 核心 token + 字体声明）
# 警告：
#   ① Sidebar 子 token（8 个 hsl）tweakcn 不提供，本脚本填占位提示，
#      必须手工从目标项目 src/_app/index.css（或 globals.css）抽真值覆盖。
#   ② 状态色派生（success/warning/info 各 -muted/-border/-foreground 共 12 个）同上需补。
#   ③ 字体 family 需匹配 tweakcn 主题给的 font-sans / font-mono；
#      本脚本读 cssVars.theme.light.font-sans / font-mono 字段，未给时回退 Inter / JetBrains Mono。

set -euo pipefail

if [[ $# -lt 1 ]]; then
  cat >&2 <<EOF
用法：$0 <tweakcn-url-or-theme-id> [output-path]
例：  $0 cmpm3t0xk000104jq47h88i1g
EOF
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  cat >&2 <<EOF
错误：未找到 jq。
  macOS：brew install jq
  Linux：apt-get install jq / yum install jq
EOF
  exit 2
fi

INPUT="$1"
OUTPUT="${2:-$(dirname "$0")/theme.css}"

# 接受完整 URL 或纯 theme id
if [[ "$INPUT" =~ ^https?:// ]]; then
  THEME_ID=$(echo "$INPUT" | sed -E 's|.*/(r/themes/|themes/)?([a-z0-9]+)/?$|\2|')
else
  THEME_ID="$INPUT"
fi
THEME_JSON_URL="https://tweakcn.com/r/themes/${THEME_ID}"

echo "→ Fetching ${THEME_JSON_URL}"
JSON=$(curl -fsSL "$THEME_JSON_URL") || {
  echo "错误：无法获取主题 JSON" >&2
  exit 3
}

# 抽取 light vars
get() { echo "$JSON" | jq -r ".cssVars.theme.light[\"$1\"] // empty"; }
get_default() { echo "$JSON" | jq -r ".cssVars[\"$1\"] // empty"; }

BACKGROUND=$(get background)
FOREGROUND=$(get foreground)
CARD=$(get card)
CARD_FG=$(get card-foreground)
POPOVER=$(get popover)
POPOVER_FG=$(get popover-foreground)
PRIMARY=$(get primary)
PRIMARY_FG=$(get primary-foreground)
SECONDARY=$(get secondary)
SECONDARY_FG=$(get secondary-foreground)
MUTED=$(get muted)
MUTED_FG=$(get muted-foreground)
ACCENT=$(get accent)
ACCENT_FG=$(get accent-foreground)
DESTRUCTIVE=$(get destructive)
DESTRUCTIVE_FG=$(get destructive-foreground)
BORDER=$(get border)
INPUT_BG=$(get input)
RING=$(get ring)
RADIUS=$(get_default radius)
FONT_SANS=$(get_default font-sans)
FONT_MONO=$(get_default font-mono)

# fallback
RADIUS=${RADIUS:-0.5rem}
FONT_SANS=${FONT_SANS:-Inter, ui-sans-serif, system-ui, sans-serif}
FONT_MONO=${FONT_MONO:-'JetBrains Mono', ui-monospace, monospace}

# 字体名（第一段）用于 Google Fonts URL
FONT_SANS_FAMILY=$(echo "$FONT_SANS" | sed -E "s/[,'].*//" | xargs)
FONT_MONO_FAMILY=$(echo "$FONT_MONO" | sed -E "s/[,'].*//" | xargs)
FONT_SANS_PARAM=$(echo "$FONT_SANS_FAMILY" | tr ' ' '+')
FONT_MONO_PARAM=$(echo "$FONT_MONO_FAMILY" | tr ' ' '+')

cat > "$OUTPUT" <<EOF
/*
 * proto-gen 主题：${THEME_ID}
 * 来源：${THEME_JSON_URL}
 * 由 extract-theme.sh 生成，勿手改；切换主题请重跑脚本。
 *
 * ⚠ Sidebar 子 token + 状态色派生 tweakcn 不给，请手工补：
 *   1. 从目标项目 src/_app/index.css（或 globals.css）抽 --sidebar-* 8 个
 *   2. 状态色按 PR 真值覆盖 --success/--warning/--info 三套 12 个
 */

/* 字体 CDN */
@import url('https://fonts.googleapis.com/css2?family=${FONT_SANS_PARAM}:wght@400;500;600;700&family=${FONT_MONO_PARAM}:wght@400;500&display=swap');

:root {
  /* === 19 个 shadcn 核心 token === */
  --background: ${BACKGROUND};
  --foreground: ${FOREGROUND};
  --card: ${CARD};
  --card-foreground: ${CARD_FG};
  --popover: ${POPOVER};
  --popover-foreground: ${POPOVER_FG};
  --primary: ${PRIMARY};
  --primary-foreground: ${PRIMARY_FG};
  --secondary: ${SECONDARY};
  --secondary-foreground: ${SECONDARY_FG};
  --muted: ${MUTED};
  --muted-foreground: ${MUTED_FG};
  --accent: ${ACCENT};
  --accent-foreground: ${ACCENT_FG};
  --destructive: ${DESTRUCTIVE};
  --destructive-foreground: ${DESTRUCTIVE_FG};
  --border: ${BORDER};
  --input: ${INPUT_BG};
  --ring: ${RING};
  --radius: ${RADIUS};

  /* === Sidebar 子 token（占位，须从项目 _app/index.css 抽真值） === */
  --sidebar: var(--background);                       /* TODO 补 */
  --sidebar-foreground: var(--foreground);            /* TODO 补 */
  --sidebar-primary: var(--primary);                  /* TODO 补 */
  --sidebar-primary-foreground: var(--primary-foreground);
  --sidebar-accent: var(--accent);                    /* TODO 补 */
  --sidebar-accent-foreground: var(--accent-foreground);
  --sidebar-border: var(--border);
  --sidebar-ring: var(--ring);

  /* === 状态色派生（占位，按项目 PR _app/index.css 真值补） === */
  --success: hsl(158 64% 41%);
  --success-foreground: hsl(0 0% 100%);
  --success-muted: hsl(152 81% 96%);
  --success-border: hsl(156 72% 67%);

  --warning: hsl(32 95% 44%);
  --warning-foreground: hsl(0 0% 100%);
  --warning-muted: hsl(37 92% 95%);
  --warning-border: hsl(48 96% 77%);

  --info: var(--primary);
  --info-foreground: var(--primary-foreground);
  --info-muted: color-mix(in oklch, var(--primary) 10%, transparent);
  --info-border: color-mix(in oklch, var(--primary) 30%, transparent);

  /* === 字体 === */
  --font-sans: ${FONT_SANS};
  --font-mono: ${FONT_MONO};

  /* === proto-gen 兼容别名（旧 shared.css 用过的 token，逐步淘汰） === */
  --bg: var(--background);
  --surface: var(--card);
  --text: var(--foreground);
  --text-2: color-mix(in oklch, var(--muted-foreground) 65%, transparent);
  --text-3: color-mix(in oklch, var(--muted-foreground) 45%, transparent);
  --border-2: color-mix(in oklch, var(--border) 70%, var(--foreground));
  --primary-hover: color-mix(in oklch, var(--primary) 88%, black);
  --primary-light: color-mix(in oklch, var(--primary) 10%, transparent);
  --error: var(--destructive);

  /* radius 阶梯（shadcn 标准 cascade） */
  --radius-chip: calc(var(--radius) - 24px);
  --radius-btn:  calc(var(--radius) - 2px);
  --radius-panel: calc(var(--radius) - 4px);
  --radius-card: calc(var(--radius) + 4px);
  --radius-full: 9999px;
}
EOF

echo "✓ Wrote ${OUTPUT}"
echo
echo "⚠ 待手工补："
echo "  ① --sidebar-* 8 个 token（从项目 _app/index.css 抽）"
echo "  ② 状态色真值（如项目有定制 success/warning/info HSL）"
echo "  ③ 字体确认：${FONT_SANS_FAMILY} / ${FONT_MONO_FAMILY}"
