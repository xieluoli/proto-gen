# proto-gen 默认主题（724-1）

proto-gen 默认主题装在 `assets/theme.css`，所有原型 HTML 通过 `<link rel="stylesheet" href="theme.css">` 引用。换主题 = 重写 `theme.css`，本目录下所有原型自动跟随，无需逐文件改。

## 当前默认

| 维度 | 值 |
|---|---|
| 主题 ID | `cmpm3t0xk000104jq47h88i1g`（tweakcn 标识：**724-1**） |
| tweakcn URL | `https://tweakcn.com/themes/cmpm3t0xk000104jq47h88i1g` |
| 主色 | `oklch(0.5554 0.2460 273.0245)`（紫） |
| 圆角 `--radius` | `1.3rem` |
| 字体 sans | Google Sans Flex |
| 字体 mono | IBM Plex Mono |
| 来源项目 | 724AIManager（dev 副本 v0.0.3 ai-store.html 已实测对齐） |

可视效果直接打开 `assets/components.html`（Token 速查段会实时显示当前 `theme.css` 注入的真值）。

## 切换主题（新业务接入）

```bash
# 1. 拿到 tweakcn 主题 ID（URL 尾段那串）
#    例：https://tweakcn.com/themes/abc123 → abc123

# 2. 跑抽取脚本（在 proto-gen/assets/ 目录下执行）
./extract-theme.sh abc123

# 也支持完整 URL
./extract-theme.sh https://tweakcn.com/themes/abc123

# 也支持指定输出位置（如目标项目内）
./extract-theme.sh abc123 /path/to/project/prototypes/theme.css
```

脚本会自动：

- fetch tweakcn JSON
- 抽 `cssVars.theme.light` 的 19 个 shadcn 核心 token
- 抽 `cssVars.radius / font-sans / font-mono`
- 生成 `theme.css`（含字体 Google Fonts `@import`）
- 写入兼容别名段（`--bg / --surface / --text-2 / --primary-light / --radius-chip ...` 等旧 token 软迁移）

## 切换后必须手工补的 3 项

tweakcn 只提供 19 个核心 token，下面这些不给，脚本会写占位 + TODO 标记，切换主题后**必须**对照目标项目源码补真值：

### ① Sidebar 子 token（8 个，必补）

```css
--sidebar
--sidebar-foreground
--sidebar-primary
--sidebar-primary-foreground
--sidebar-accent           /* active 项底 */
--sidebar-accent-foreground /* active 项文字 + icon */
--sidebar-border
--sidebar-ring
```

来源：目标项目 `src/_app/index.css` 或 `globals.css`（shadcn init 时写入）。**不要** fallback 到 `var(--muted)` / `var(--foreground)` —— 激活态会错。

详细规则与陷阱见 [`shadcn-tweakcn-theme.md`](./shadcn-tweakcn-theme.md)。

### ② 状态色派生（12 个，按需）

```css
--success / --success-foreground / --success-muted / --success-border
--warning / --warning-foreground / --warning-muted / --warning-border
--info    / --info-foreground    / --info-muted    / --info-border
```

脚本默认填了一组通用 HSL 真值（绿 / 橙 / 主色）；目标项目若有定制（如绿色饱和度不同）按项目 `_app/index.css` 覆盖。

`--info` 通常 = `var(--primary)` —— shadcn 习惯。

### ③ 字体确认

脚本抽 `cssVars.font-sans / font-mono` 并按字段首段拼 Google Fonts URL。若：

- tweakcn 主题没显式给字体 → 回退 `Inter / JetBrains Mono`
- 项目用了非 Google Fonts 来源（Fontshare / 自托管）→ 手工改 `theme.css` 头部 `@import` 行

## token 完整清单（默认 724-1 真值）

| 类别 | Token | 值 |
|---|---|---|
| 表面 | `--background` | `oklch(1.0000 0 0)` |
| 表面 | `--foreground` | `oklch(0.2722 0.0494 286.0078)` |
| 卡片 | `--card` | `oklch(0.9885 0.0054 274.9676)` |
| 卡片 | `--card-foreground` | `oklch(0.2722 0.0494 286.0078)` |
| 浮层 | `--popover` | `oklch(1.0000 0 0)` |
| 浮层 | `--popover-foreground` | `oklch(0.2722 0.0494 286.0078)` |
| 主色 | `--primary` | `oklch(0.5554 0.2460 273.0245)` 紫 |
| 主色 | `--primary-foreground` | `oklch(1.0000 0 0)` |
| 次色 | `--secondary` | `oklch(0.2722 0.0494 286.0078)` |
| 次色 | `--secondary-foreground` | `oklch(1.0000 0 0)` |
| 弱化 | `--muted` | `oklch(0.9769 0.0109 274.8971)` |
| 弱化 | `--muted-foreground` | `oklch(0.2722 0.0494 286.0078)`（= foreground，靠 opacity 区分） |
| 强调 | `--accent` | `oklch(0.9221 0.0381 280.7675)` |
| 强调 | `--accent-foreground` | `oklch(0.4805 0.2921 264.2112)` |
| 危险 | `--destructive` | `oklch(0.6526 0.2348 32.3008)` |
| 危险 | `--destructive-foreground` | `oklch(1.0000 0 0)` |
| 描边 | `--border` | `oklch(0.9224 0.0184 258.3541)` |
| 输入 | `--input` | `oklch(0.9809 0.0025 228.7836)` |
| 焦点 | `--ring` | `oklch(0.6081 0.2114 266.2130)` |
| 圆角 | `--radius` | `1.3rem` |
| sidebar | `--sidebar` | `hsl(228 100% 98.04%)` |
| sidebar | `--sidebar-foreground` | `hsl(244.44 27.84% 19.02%)` |
| sidebar | `--sidebar-primary` | `hsl(237.30 100% 65.10%)` |
| sidebar | `--sidebar-primary-foreground` | `hsl(0 0% 100%)` |
| sidebar | `--sidebar-accent` | `hsl(234.19 100% 93.92%)` |
| sidebar | `--sidebar-accent-foreground` | `hsl(228.85 99.22% 50%)` |
| sidebar | `--sidebar-border` | `hsl(216 43.48% 90.98%)` |
| sidebar | `--sidebar-ring` | `hsl(225 100% 63.92%)` |
| success | `--success` | `hsl(158.11 64.37% 40.98%)` |
| success | `--success-muted` | `hsl(151.76 81% 95.88%)` |
| success | `--success-border` | `hsl(156.22 71.65% 66.86%)` |
| warning | `--warning` | `hsl(32.13 94.62% 43.73%)` |
| warning | `--warning-muted` | `hsl(36.52 92% 95.10%)` |
| warning | `--warning-border` | `hsl(48 96.49% 76.67%)` |
| info | `--info` | `var(--primary)` |
| info | `--info-muted` | `hsl(234.19 100% 96.47%)` |
| info | `--info-border` | `hsl(234.19 100% 88%)` |
| 字体 | `--font-sans` | `Google Sans Flex, ...` |
| 字体 | `--font-mono` | `IBM Plex Mono, ...` |

## 圆角阶梯速查（**写组件时严格按此查表**）

`theme.css` 把 shadcn 圆角 cascade 落成 6 个 token + 装饰例外区。**默认主题 `--radius = 1.3rem (20.8px)`** 是大圆角风格，所以下表实测像素整体偏大；切换主题后 token 自动跟随 `--radius` 重算。

| Token | 公式 | 默认主题实测 | 何时用 |
|---|---|---|---|
| `--radius-chip` | `calc(--radius - 16px)` | **≈ 5px** | kbd 键帽 · scrollbar thumb · 状态圆点 · 小 icon button 内 hover 高亮（**装饰区**，**不**用于 menu option） |
| `--radius-sm` | `calc(--radius - 4px)` | **≈ 17px** | **menu / dropdown / popover 内 option**（与容器圆角呼应的"贴边圆"，1.3rem 大圆角主题下的关键档） · 输入框小元素备选 |
| `--radius-btn` | `calc(--radius - 2px)` | **≈ 19px** | button · input · select · combobox 输入框 · 信息卡内嵌按钮 |
| `var(--radius)` | — | **20.8px** | 通用容器 · `.info-card` · `.empty-card` · drawer 面板 · sidebar item |
| `--radius-panel` | `calc(--radius - 4px)` | **≈ 17px** | 小面板（= sm；语义"内嵌面板"，与 `--radius-sm` 取值一致但语义层级不同） |
| `--radius-card` | `calc(--radius + 4px)` | **≈ 25px** | 大型卡片 · Card · Dialog · Sheet 整块外壳 |
| `--radius-full` | `9999px` | — | pill · 头像 · badge 胶囊 · loading dot · 进度条端头 |

**决策原则（写新组件时按这个流程走）**：

1. 这个元素是 shadcn 原语（Button / Input / Card / Dialog / Sheet）吗？→ 跟阶梯（`btn` / `card` 等）
2. 是 menu/popover 内嵌套的小子项（option / item）吗？→ `--radius-sm`（**关键**：在 1.3rem 大圆角主题下，menu 容器圆角已达 19px，option 必须用 sm 才能跟容器圆边"贴合"；chip 太小会变成"圆菜单里塞方块"）
3. 是 pill / 胶囊 / 圆形（badge / 头像 / loading dot / 进度条端）吗？→ `--radius-full`
4. 是大型容器/卡片整体外壳吗？→ `--radius-card`
5. 都不是，是通用容器？→ `var(--radius)` 直接用

### 装饰例外（**不**走阶梯）

下列场景跟随 token 反而会显得"过分圆润"，固定 **4–6px**（或更小）：

| 元素 | 固定值 | 原因 |
|---|---|---|
| 小型品牌图标 tile（BrandIcon 44px / 卡片 brand-icon 32-36px） | 4–6px | 块本身小，大圆角会吃掉视觉重量 |
| `kbd` 键盘提示 | 4px | 拟物键帽风格固定值 |
| scrollbar thumb | 4–6px | 极细条不需要大圆角 |
| 状态栏圆点 / 趋势胶囊 | 固定 4px 或 `--radius-full` | 装饰元素 |
| icon button 内部背景 hover 高亮 ≤ 6px | 4–5px | 视觉与 svg 形状对齐 |

**判断标准（一句话）**：该元素是 shadcn 原语 → 跟阶梯；纯装饰 / 极小块 → 4–6px 固定。

### ❌ 反例（已踩过的坑）

- `combobox-option { border-radius: 4px; }` 写死硬值 → menu 19px 圆角配 option 4px 方角脱节，视觉成"圆菜单里塞方块"。修法：改 `var(--radius-sm)` ≈ 17px，跟 menu 容器圆边呼应（注意：**不要**用 `--radius-chip`，chip 5px 跟 menu 19px 比例 ≈ 1:4，方角感反而更重）。
- `form-chevron { position: absolute; top: 50%; padding: 6px; }` + 给 menu 加 `position: static; display: block` inline 让父盒子被撑高 → chevron 的 `top: 50%` 跟着新盒子重算，跑到菜单中央去了。修法：①menu 走 shared.css 默认的 `absolute`，不挤占父盒子；②demo 容器加 `overflow: visible` 让浮出的 menu 可见；③chevron button 顺手缩到 20×20 紧贴 svg、rotate 只动 `> svg` 子元素（外层 transform 永远稳定 `translateY(-50%)`）。
- 组件库 `border-radius: 6px;` 这类**赤裸像素**散落 → 切换主题时圆角不跟随 `--radius` 重算，视觉断层。修法：能套阶梯一律套，装饰例外段单独列条。

## 兼容别名（旧 shared.css token 软迁移）

为不让旧原型立即报错，`theme.css` 末尾保留：

```css
--bg = var(--background)
--surface = var(--card)
--text = var(--foreground)
--text-2 / --text-3       /* mix muted-foreground 不同百分比 */
--border-2                /* mix border + foreground */
--primary-hover           /* mix primary + black */
--primary-light           /* mix primary 10% */
--error = var(--destructive)
--radius-chip/btn/panel/card/full   /* shadcn cascade */
```

新写原型直接用 shadcn 19 token + sidebar 子 token + 状态色派生即可，不依赖兼容别名。
