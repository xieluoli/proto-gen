# 项目接入：对齐业务项目自身的 shadcn / tweakcn 主题

> 本文件是「**目标项目接入**」指引——当原型要严格对齐某个**业务项目自身的主题**（如 724AIManager 的 `_app/index.css`），按本文件覆盖 `theme.css` 中 tweakcn 不给的子 token；
> 如果只是用 proto-gen 默认主题，看 [`default-theme.md`](./default-theme.md) 即可，无需读本文件。

## 何时启用本规范

满足以下任一条件：

- 项目代码用 `npx shadcn@latest init` 初始化过
- 项目 `_app/index.css` 或 `globals.css` 用 HSL/OKLCH 定义 `--background --foreground --primary` 等 shadcn 变量
- 用户提到「按这个项目的主题做原型」 / 「对齐到 src/_app/index.css」
- 需要原型在产品评审 / PR review 时与项目实施视觉对齐

不在范围：纯用 proto-gen 默认主题做新业务原型（看 `default-theme.md`）。

## 接入流程总览

```
1. 跑 extract-theme.sh <tweakcn-url>  →  生成 theme.css 含 19 核心 token
2. 从项目 _app/index.css 抽 sidebar 子 token  →  覆盖 theme.css 对应段
3. 从项目 _app/index.css 抽状态色派生（如有定制）  →  覆盖 theme.css 对应段
4. 字体确认（Google Fonts 引入 / 自托管覆盖 @import）
5. 字体大小逐处对照「字体大小映射表」（见末尾）核对 PR 实施层
```

## ① Sidebar 子 token —— **关键陷阱**

tweakcn 主题 **不会** 给 `--sidebar / --sidebar-accent / --sidebar-accent-foreground / --sidebar-border / --sidebar-ring` 等 sidebar 子 token。

shadcn 自带的 sidebar 子 token 在项目 `_app/index.css` 或 `globals.css` 由 shadcn 初始化模板写入，**与 tweakcn 主色不一定一致**。**必须**从项目源码读取真实的 sidebar token 注入 `theme.css`，不能 fallback 到 `var(--muted)` / `var(--foreground)`，否则激活态背景/文字色会错。

示例（来自 724AIManager `src/_app/index.css`）：

```css
--sidebar: hsl(228 100% 98.04%);
--sidebar-foreground: hsl(244.44 27.84% 19.02%);
--sidebar-primary: hsl(237.30 100% 65.10%);
--sidebar-primary-foreground: hsl(0 0% 100%);
--sidebar-accent: hsl(234.19 100% 93.92%);              /* 激活背景 */
--sidebar-accent-foreground: hsl(228.85 99.22% 50%);    /* 激活文字+icon */
--sidebar-border: hsl(216 43.48% 90.98%);
--sidebar-ring: hsl(225 100% 63.92%);
```

## ② 状态色派生（success / warning / info）

tweakcn 不给。从项目 `_app/index.css` 读取（PR 实施层真值）。若项目也没显式给，按 shadcn 惯例 HSL：

```css
--success: hsl(158.11 64.37% 40.98%);
--success-foreground: hsl(0 0% 100%);
--success-muted: hsl(151.76 81% 95.88%);
--success-border: hsl(156.22 71.65% 66.86%);

--warning: hsl(32.13 94.62% 43.73%);
--warning-foreground: hsl(0 0% 100%);
--warning-muted: hsl(36.52 92% 95.10%);
--warning-border: hsl(48 96.49% 76.67%);

--info: var(--primary);                    /* info 系列 = primary 系列 */
--info-foreground: var(--primary-foreground);
--info-muted: hsl(234.19 100% 96.47%);
--info-border: hsl(234.19 100% 88%);
```

`--muted-foreground` 在 shadcn/tweakcn 中 = `--foreground` 同值（设计上次级文字靠 **font-size + opacity 区分**，不靠颜色变浅）。

## ③ Badge 公式（对齐 shadcn 默认 + 规范加粗）

```css
border-radius: 9999px; height: 22px; padding: 0 8px;
border: 1px solid var(--<tone>-border);
background: var(--<tone>-muted);
color: var(--<tone>);
font-size: 12px; font-weight: 600;   /* 一律 font-semibold 加粗 */
```

字重 600 是硬规范。PR 实施层若写成 medium (500) / normal (400) 视为偏差，原型不跟随。

例外：
- 内容卡片 / 详情头部 badge **纯文字无 icon**（仅 detecting/installing 等代码态显式带 spinner 时原型才加 spinner）
- 必要依赖行状态徽标 **含 icon**：healthy→CircleCheck、broken/missing→CircleAlert、warning→TriangleAlert、info→Info、checking/installing/updating/repairing/pending→Loader2、not_installed/queued→null

## ④ tailwind 圆角层级

**以 tweakcn 主题的 `--radius` 为准**（设计规范的来源），shadcn 标准 cascade：

```
sm: calc(var(--radius) - 4px)  // 输入框等小元素备选
md: calc(var(--radius) - 2px)  // Button、Input、Card-like 容器
lg: var(--radius)               // 大型容器
xl: calc(var(--radius) + 4px)   // Card 默认（CardHeader/CardContent 整块）
```

⚠️ **常见陷阱**：项目 `tailwind.config.cjs` 可能把 borderRadius 硬写成固定 px（如 724AI: sm/md/lg/xl = 6/8/12/14 px）——这是**实施层对设计规范的偏离**，原型**不要**跟随该偏差。原型严格按 tweakcn 主题渲染，PR review 时把 tailwind 偏差作为一项缺陷指出。

**装饰例外**：小型品牌图标 tile（BrandIcon 44px / 卡片 32–36px brand-icon / kbd / scrollbar / 状态栏圆点）用固定 4–6 px，**不走 shadcn 阶梯**——避免 44px 块挤进 ~19px 圆角时视觉过分圆润。判断标准：该元素是 shadcn 原语（Button/Input/Card/Dialog/Sheet）则跟随阶梯；纯装饰则任意 4–6 px。

## ⑤ hover / focus 视觉规则

| 元素 | hover 边框 | hover 阴影 |
|---|---|---|
| 卡片 | `color-mix(in oklch, var(--primary) 35%, var(--border))` ← **品牌色 tint** | `color-mix(in oklch, var(--primary) 12%, transparent)` |
| 输入框 focus | `var(--ring)` + `box-shadow: 0 0 0 2px color-mix(in oklch, var(--ring) 30%, transparent)` | — |
| 按钮 ghost hover | `var(--muted)` | — |
| Sidebar nav hover | `color-mix(in oklch, var(--sidebar-accent) 60%, transparent)` | — |

**禁忌**：hover 边框不要 mix `var(--foreground)` —— 会变成深灰，跟品牌色脱节。

## ⑥ lucide icon 关键踩坑

`lucide.createIcons()` 把 `<i data-lucide="...">` **替换**为 `<svg>` 元素，原 `<i>` 不存在。所以 `.xxx i { ... }` CSS 选择器全部失效。

正确做法 — 用 `> svg` 选择器 + `!important`（SVG 的 width/height 是 HTML attribute 优先级高，必须 `!important` 覆盖）：

```css
.nav-btn > svg {
  width: 16px !important;
  height: 16px !important;
  stroke-width: 1.5 !important;
}
```

stroke-width 是数字，**不要**当字符串带引号；color 走 CSS `color` 属性继承（svg 默认 `stroke="currentColor"`）。

## ⑦ Agent / 品牌图标 SVG

走 lobehub CDN：

```
https://unpkg.com/@lobehub/icons-static-svg@latest/icons/<slug>-color.svg
```

常用 slug：`claude` / `openai` / `gemini` / `qwen` / `anthropic` / `openrouter` / `cursor`。

无对应 slug 时用 lucide icon + 紫色 tile（`background: color-mix(in oklch, var(--primary) 15%, transparent)`）兜底。

## 字体大小映射表（PR 实施层精确对齐）

PRD 真实组件用 tailwind className 控制字号，原型 inline CSS 必须精确对齐：

| 元素 | tailwind className | px 值 | 字重 |
|---|---|---|---|
| 页面 h2 标题 | `text-base font-semibold` | **16** | 600 |
| 副标题 / subtitle | `text-xs text-muted-foreground` | **12** | 400 |
| section h3 分组标题 | `text-sm font-medium` | **14** | 500 |
| 顶栏 stats badge | `text-xs` | **12** | 400 |
| **featured 卡片** title | `text-[13px] font-semibold` | **13** | 600 |
| **agent 卡片** title | `text-xs font-semibold` | **12** | 600 |
| 卡片 version | `text-xs leading-none text-muted-foreground/65` | **12** + opacity 0.65 | 400 |
| 卡片 description | `text-[11px] leading-4 text-muted-foreground` | **11** / lh 16px | 400 |
| 卡片右上 status badge | `text-xs` | **12** | 500 |
| 主按钮 (size=sm) | `text-xs` | **12** | 500 |
| Icon button (size=iconSm) | — h-9 w-9 32×32 | — | — |
| 搜索 input | `text-xs leading-4` | **12** | 400 |
| kbd 快捷键 | `font-mono text-[10px] leading-none` | **10** mono | 400 |
| sidebar nav text | `text-xs` | **12** | 400/500 |
| sidebar section label | `text-xs font-medium text-muted-foreground` | **12** | 500 |
| sidebar brand 文字 | `text-sm font-semibold` | **14** | 600 |

**反例**：subtitle 用 14px、status-badge 用 11px、sidebar nav 用 13px ← 都是常见偏差，会让原型整体"虚胖"。

## 项目维度变量索引

不同项目 tweakcn 主题不同，提到 / 涉及 / 引用时按项目分别记忆：

| 项目 | tweakcn URL | 主色 | 圆角 radius | 字体 sans / mono |
|---|---|---|---|---|
| 724AIManager（proto-gen 默认） | `tweakcn.com/themes/cmpm3t0xk000104jq47h88i1g`（724-1） | `oklch(0.5554 0.246 273)` 紫 | `1.3rem` | Google Sans Flex / IBM Plex Mono |

新项目接入时在表格追加一行，并配套从 `_app/index.css` 读 sidebar 子 token 同步记录到该项目 `theme.css`。

## 接入完成自检

- [ ] `theme.css` 19 个核心 token 全在 `:root`，颜色格式原样保留（OKLCH/HSL/RGB 不强制转换）
- [ ] sidebar 子 token 从项目源码读，**不要** fallback（fallback 到 muted/foreground 是常见错误）
- [ ] 状态色用项目 PR HSL 真值（success 绿 / warning 橙 / info=primary），不要 OKLCH 估值
- [ ] `--muted-foreground` = `--foreground` 同值（次级文字靠 font-size + opacity 区分）
- [ ] 字体 `@import` 引入 + body `font-family: var(--font-sans)`
- [ ] 字体大小逐处对照「字体大小映射表」
- [ ] 卡片 hover 边框用 primary tint（`color-mix(primary 35%, border)`），不 mix foreground
- [ ] Badge 字重 600，4 套 status-badge（installed / update / installing / detecting）齐全
- [ ] lucide `> svg !important` 覆盖（nav / icon-btn / status-badge / btn-enter / brand-mark 等）
- [ ] 圆角用 `calc(var(--radius) ± Npx)` 不写死 px；shadcn 原语跟阶梯（Button/Input md、Card xl），装饰 tile 保持 4–6 px 不跟阶梯
- [ ] sidebar 激活态实际渲染验证：浅色品牌背景 + 品牌色文字/icon
- [ ] PR review：项目 `tailwind.config` 硬编码 px 与本规范不符的，作为偏差指出，原型不跟随
