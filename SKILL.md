---
name: proto-gen
description: >
  生成高保真 HTML 原型文件。触发场景：用户提供某个页面/功能的构思、草稿或 PRD，想要快速生成
  对应的可视化 HTML 原型（含页面索引、macOS 窗口原型、旁注 PRD 面板）。
  关键词：生成原型、新建原型、写原型、画原型、做个原型、出个原型、新增一个 html、新建 html 原型。
  生成的 HTML 复用一套统一的设计系统（shared.css），遵循 references/ 下的内容规范。
---

# proto-gen — 高保真原型生成

本 skill 生成统一风格的高保真 HTML 原型，适合 Web/桌面应用产品 MVP 阶段的方案演示与评审。

## 路径约定

本 skill 同时支持 **Claude Code** 与 **Codex**，可装在**项目级**（推荐，跟仓库走）或**用户级**（多项目共用），共四种位置。下文用 `<SKILL>` 指代它的根目录，跑命令前先探测：

```bash
for d in .claude/skills/proto-gen .codex/skills/proto-gen ~/.claude/skills/proto-gen ~/.codex/skills/proto-gen; do
  [ -d "$d" ] && echo "$d" && break
done
```

| | Claude Code | Codex |
|---|---|---|
| 项目级 | `.claude/skills/proto-gen` | `.codex/skills/proto-gen` |
| 用户级 | `~/.claude/skills/proto-gen` | `~/.codex/skills/proto-gen` |

并存时**项目级优先**（就近覆盖）。

## 前置依赖（首次在一个项目里使用时检查）

proto-gen 本身自包含，不装任何东西也能生成原型。但原型是需求链条的一环——上游要有需求文档承载「为什么做」，下游要有评审把关质量。下面两项**推荐**装上，缺了就提醒用户并协助安装，用户拒绝则跳过、继续生成。

**1. OpenSpec —— 需求文档骨架**

原型要对应到一份变更提案（proposal + spec），否则原型只是一张图，改了什么、为什么改无处可查。

```bash
openspec --version                      # 检测
npm install -g @fission-ai/openspec     # 未安装则装
openspec init                           # 在项目根初始化，生成 openspec/ 目录
```

初始化后原型放在 `openspec/changes/<change-name>/prototypes/` 下，与该变更的 proposal.md / spec.md 同级，形成闭环。项目已有自己的原型目录约定时，尊重现有约定。

**2. superpowers —— 工作流 skill 集**

提供 brainstorming（需求澄清）、writing-plans（方案落地）、verification-before-completion（交付前验证）等流程 skill，补上 proto-gen 不覆盖的「想清楚」与「验收」两端。

```bash
# Claude Code
/plugin install superpowers@claude-plugins-official

# Codex
codex plugin add superpowers@openai-curated
```

两个市场（`claude-plugins-official` / `openai-curated`）都是默认已注册的官方源，无需先 add。装完重启会话生效。检测方式：看 skill 列表里有没有 `superpowers:brainstorming`。

**3. prototype-reviewer —— 原型评审员（本 skill 自带，但需拷贝才生效）**

`agents/prototype-reviewer.md` 随本 skill 分发，但 **Claude Code 只加载 `.claude/agents/` 下的 agent 定义**，skill 目录里的那份不会被自动识别。首次使用时检查 `.claude/agents/prototype-reviewer.md` 是否存在，不存在就拷一份：

```bash
mkdir -p .claude/agents
cp <SKILL>/agents/prototype-reviewer.md .claude/agents/
```

拷完需重启会话才能调用。

**Codex 下没有等价的 agent 注册目录**，跳过拷贝，评审时直接读 `<SKILL>/references/review-checklist.md` 按清单逐项检查，同样只读不改文件。

规则单一源是 [`references/review-checklist.md`](references/review-checklist.md)，agent 文件只是薄壳。项目有特化规则（自有主题 token、外壳结构、版本命名）就在项目的那份里叠加，不要回写本 skill。

## 第一次用：先定设计系统来源

**首次在一个新项目里生成原型前**，先判定主题从哪来。用户没交代就问一句，问完立刻开工——**不要因为「还没有设计系统」就停下**。

| 用户的处境 | 怎么办 |
|---|---|
| **完全没有设计系统**（多数首次使用者） | 直接用自带的默认主题开工，**这是默认选择**，不用问第二遍 |
| **有品牌色 / 视觉倾向，但没成体系** | 去 [tweakcn](https://tweakcn.com) 挑一个接近的主题（或在线调一个），拿 URL 跑 `assets/extract-theme.sh <url>`，再补下面 3 项 |
| **已有产品代码**（shadcn 项目） | 从项目 `src/index.css` / `app/globals.css` 抽 shadcn token 覆盖 `theme.css`，按 [`references/shadcn-tweakcn-theme.md`](references/shadcn-tweakcn-theme.md) 接入 |

**为什么可以先不管设计系统**：主题是可插拔的——`theme.css` 是唯一 token 源，`shared.css` 全部 `var()` 引用它。哪天定下品牌色，跑一次 `extract-theme.sh` + `inject-assets.mjs`，**已生成的所有原型自动换皮**，不用回头改任何一张图。先出图沟通产品逻辑，比先纠结色号更要紧。

换过主题的话，tweakcn 只给 19 个核心 token，下面 3 项它不给、脚本会留 TODO 占位，**必须补**（细节见 [`references/default-theme.md`](references/default-theme.md)）：

1. **sidebar 子 token（8 个）** —— 不补的话侧边栏激活态颜色会错
2. **状态色派生（success / warning / info 各 4 个）** —— 不补的话 badge / 提示条没颜色
3. **字体确认** —— 非 Google Fonts 来源要手工改 `theme.css` 头部 `@import`

## 设备系列

| 系列 | 状态 | 外壳容器 | 适用 reference |
|---|---|---|---|
| **PC · macOS** | ✅ 当前覆盖 | `macos-window` / `macos-titlebar` / `macos-body` + `app-sidebar` / `win-chrome-bar` / `app-main` | 现有 `references/*.md` 全部 |
| **Mobile** | 🚧 规划中 | 拟用 `mobile-frame` / `mobile-statusbar` / `mobile-tabbar`（待落地） | 后续以独立文件扩展（如 `references/html-structure-mobile.md`），不混入现有 |

> 当前所有原型骨架与组件描述均基于 PC · macOS 系列。引入 Mobile 系列时，**新增独立 reference 文件**而不是覆写现有，避免设备形态混淆。

## 三段结构契约

每个原型 HTML 文件由**三段固定结构**组成，任何 section 都必须遵守。骨架类名见 [`references/html-structure.md`](references/html-structure.md)。

```
.proto-layout (灰底桌面，flex 横排，gap 24)
┌──────────────┬──────────────────────────────┬──────────────────┐
│              │                              │                  │
│ toc-sidebar  │   原型图(macos-window)       │  功能概览        │
│ 280px sticky │   1460×910（macOS 桌面感）   │  prd-panel       │
│ 卡片         │                              │  360px sticky    │
│ (全文件共享) │   ←──── 一一对应 ────→       │  卡片            │
│              │                              │                  │
└──────────────┴──────────────────────────────┴──────────────────┘
   toc-sidebar     sections-col (纵向堆叠每个 .proto-stack)
                     │
                     └─ 每个 .proto-stack = section-label + .proto-with-prd
                                                          │
                                                          └─ macos-window + prd-panel
```

**布局规范**（实施于 `assets/shared.css`，原型 HTML 不应覆写）：

| 维度 | 值 | 说明 |
|---|---|---|
| body 背景 | `oklch(0.92 0.005 280)` | macOS 桌面浅灰，让白色窗口悬浮其上 |
| body padding | `32px 24px` | 整体外边距 |
| macos-window 尺寸 | **1460×910** | 对齐 PC macOS 应用常见窗口大小（参 `references/shadcn-tweakcn-theme.md`） |
| toc-sidebar 宽度 | **280px** | sticky top:32px，独立卡片样式 |
| prd-panel 宽度 | **360px** | sticky top:32px，与 macos-window 同高（910px） |
| 列间距 | `24px` | toc / 原型 / prd 三者之间 |

约束：

1. **toc-sidebar 全文件唯一**：所有 section 共用同一个左侧索引，每个 section 一条 toc-item
2. **原型图 ↔ 功能概览 一一对应**：每个 section 内一个 `.proto-with-prd` 包**恰好一个**外壳 + **恰好一个** `.prd-panel`
3. **不允许「一图多 PRD」**（一个外壳塞多个 prd-section 拆给多个状态）
4. **不允许「PRD 拆给多图」**（一个 prd-panel 描述跨多个外壳的内容）
5. 此契约**设备无关**——Mobile 系列引入后仍维持三段结构，只是外壳容器换成 `mobile-frame`

## 设计系统资产

本 skill 自带一套**主题可插拔**的设计系统：

- `assets/theme.css` — **主题 token 单一来源**（19 个 shadcn 核心 + 8 个 sidebar 子 token + 12 个状态色派生 + 字体 CDN）。默认 = tweakcn violet，可通过 `extract-theme.sh` 切换
- `assets/shared.css` — 组件类骨架（按钮 / 卡片 / 弹窗 / 表单 / PRD 面板等）；所有颜色 / 字体 / 圆角通过 `var()` 引用 `theme.css` 的 token
- `assets/components.html` — **人类可视组件清单**（核心交付物）：每个组件含 类名 / 常态 / hover / 禁用 / loading 四态横排 + 应用场景 + Token 速查；产品 / 测试 / AI 浏览器双击查阅
- `assets/extract-theme.sh` — 主题切换脚本：`./extract-theme.sh <tweakcn-url-or-id>` 一键覆盖 `theme.css`
- `assets/inject-assets.mjs` — **资产注入脚本**：把 `theme.css` / `shared.css` / `prd-highlight.js` 的最新内容注入原型 HTML 的标记块之间，产出仍是自包含单文件（见下节）
- `assets/prd-highlight.js` — PRD ↔ 原型 双向 hover 联动运行时
- `assets/example.html` — 最小可运行示例

> **想换主题**：跑 `./extract-theme.sh <new-tweakcn-url>` 覆盖 `theme.css`，再跑一次注入脚本刷新所有原型。
> **想查组件视觉规范**：浏览器打开 `components.html`，左侧 TOC 跳转，点类名复制。

## 自包含注入机制（默认交付方式）

原型 HTML 要求**自包含**（研发 / 评审拿到单文件直接双击打开），但 token 与通用组件样式**不手写副本**，只在本 skill 的 `assets/` 维护一份，通过脚本注入。

**标记格式**：`<head>` 内用一对 HTML 注释包住注入块，脚本只替换标记之间的内容：

```html
<!-- @proto-gen:theme:start -->
<style>/* 脚本注入 theme.css，勿手改 */</style>
<!-- @proto-gen:theme:end -->
<!-- @proto-gen:shared:start -->
<style>/* 脚本注入 shared.css，勿手改 */</style>
<!-- @proto-gen:shared:end -->
<!-- @proto-gen:highlight:start -->
<script>/* 脚本注入 prd-highlight.js，勿手改 */</script>
<!-- @proto-gen:highlight:end -->
<style>/* 页面自有样式写在标记块之外，注入不会碰 */</style>
```

支持的块：`theme`（必备）、`shared`、`highlight`（按需）。每个标记对全文件只允许出现一次。

**注入 / 批量刷新**（同一命令，参数可混填文件与目录，目录递归收集 `*.html`）：

```bash
<SKILL>/assets/inject-assets.mjs path/to/prototypes/
```

改完 `theme.css` / `shared.css` 后跑一次，所有带标记的原型统一换皮。脚本幂等，重复执行结果一致。

**存量原型一次性迁移**：把已有 `<style>` 中的 token 段（`:root { --background: ... }` 等）与通用组件样式删掉，原位放入上面的空标记块对（页面特有样式保留在标记块之外的独立 `<style>` 里），然后跑一次注入脚本回填。迁移后该文件即可参与批量刷新。

## References 总览

| 文件 | 内容 | 设备适用 |
|---|---|---|
| `references/html-structure.md` | 页面骨架 + 三种叠加态（modal / drawer / subpage） | PC · macOS 系列 |
| `references/css-components.md` | **类名 → 用途 → components.html 锚点** 索引表；不再含 hex / px 等具体值 | PC · macOS 系列 |
| `references/default-theme.md` | 默认主题（violet）说明 + 切换流程 + token 全表 + 必须手工补的 3 项；**圆角阶梯与装饰例外的单一源** | 设备无关 |
| `references/shadcn-tweakcn-theme.md` | **对齐外部项目主题**：sidebar 子 token 陷阱 / 状态色真值 / tailwind 圆角映射 / 字体大小映射 / lucide 踩坑 / 自检清单 | 设备无关；项目接入场景 |
| `references/prd-rules.md` | **每条 bullet 怎么写**：元素描述模板、重复内容引用规则、改动型只写增量、产品语言禁代码语言 | 设备无关 |
| `references/prd-document.md` | **整篇 PRD 文档怎么组织**：章节骨架、框架 ASCII 树、配置表 + YAML、格式与命名约定 | 设备无关；需独立 PRD md 时 |
| `references/prd-highlight.md` | PRD ↔ 原型 双向 hover 联动：`data-comp` / `data-target` 命名约定 / scope / 交付剥离须知 | 设备无关 |
| `references/review-checklist.md` | **评审清单**：组件复用 / 基于最新原型迭代 / 结构契约 / PRD 面板 / 风格沉淀建议输出格式 | 设备无关 |

## 工作目录

由用户在调用时指定，例如 `designs/prototype/` 或 `prototypes/`。生成的 HTML 自包含，目录内无需伴随 css / js 文件。

## 执行步骤

### 1. 理解输入

用户的"构思"可以是：

- 自然语言描述（如"做一个数据导入页面，包含列表、上传弹窗"）
- 已有 PRD md 文件路径
- 对某个现有页面的补充/改版

**分析出**：

- 页面/功能名称（用于文件名和标题）
- 包含哪些 section（每个 section = 一个原型状态，如主页 / 弹窗 / 抽屉）
- 每个 section 的页面类型（主页 / 详情页 / 弹窗叠加态 / 抽屉叠加态）

### 2. 规划 sections

每个 section 对应一个 `macos-window` + `prd-panel`，分配：

- `section-id`（kebab-case，如 `section-home`、`section-home-add`）
- `section-label`（如 `Home-01`、`Home-02`）
- `toc` 显示名（如 `Home-01`）

> 默认不拆分文件，所有 section 放在一个 HTML 中，垂直堆叠。

### 3. 为每个 section 构建 UI

参考 `references/css-components.md` 选择合适的 CSS 组件，不要随意 inline 替代或自造未列出的类名。

**UI 构建原则**：

- 使用真实示例数据，不用 `Lorem ipsum` 或空占位
- `app-sidebar` 和 `win-chrome-bar` 是所有主页 section 的标配
- 弹窗叠加态：在主内容上 `position:absolute; inset:0; z-index` 加遮罩 + `.form-dialog` + `.modal-close-x`
- 抽屉叠加态：在主内容上加遮罩 + 右侧抽屉面板
- 详情页：左上角加 `← 返回 {上级页面}` 链接

### 4. 为每个 section 写 PRD bullets

遵循 `references/prd-rules.md` 的规范：

- 按页面从上到下视觉顺序排列
- 一个元素一条 bullet，句式见规范
- **写产品，不写实现**：既不写「紫色 #6366F1 圆角 8px」，也不写类名（`.btn-primary`）。写「展示主按钮」就够——面板的读者是产品与测试，他们不需要知道类名；视觉规范由 `theme.css` 与 `components.html` 沉淀，那才是研发要看的地方。详见 [`references/prd-rules.md`](references/prd-rules.md) 的「面板写产品，不写实现」一节
- **重复内容处理**：第一个 section 完整描述；后续 section 对相同通用结构用引用，只描述差异
- **顺手绑定 highlight**：按 `references/prd-highlight.md` 给 bullet 加 `data-target="<key>"`、给原型组件加 `data-comp="<key>"`，开启 PRD ↔ 原型 双向 hover 联动

### 5. 组装 HTML

参考 `references/html-structure.md` 的页面骨架模板，按顺序填入各 section。

`<head>` 内**必须带注入标记块**（见「自包含注入机制」，标记内先留空即可），页面自有样式写在标记块之外。写入用户指定目录下的 `{filename}.html` 后，跑一次注入脚本回填样式：

```bash
<SKILL>/assets/inject-assets.mjs {user-dir}/{filename}.html
```

### 6. 生成后评审

原型生成或大改后，跑一次 `prototype-reviewer` 拿到批量问题清单，一次性修完再交付——不要逐条发现、逐条改。

```
用 prototype-reviewer 审查 {user-dir}/{filename}.html
```

审查规则见 [`references/review-checklist.md`](references/review-checklist.md)。项目未拷 agent 文件时，直接对照该清单自查也可以。

评审输出末尾的「风格沉淀建议」段是给人看的：本轮新增的组件模式、尚未固化的重复写法、项目规范里已过期的条目。**由用户确认后再落笔**写进设计文档或 `shared.css`，评审本身不改任何文件。

## 输出文件

- **HTML 原型**：`{user-dir}/{name}.html`（包含全部 sections，自包含单文件，token / 通用组件样式由注入脚本回填）
- **（可选）PRD md**：如用户需要，同步生成 `{name}.md`，结构按 [`references/prd-document.md`](references/prd-document.md)；与 HTML 旁注面板内容两处必须同步

## 验证

交付前自查（完整清单见 [`references/review-checklist.md`](references/review-checklist.md)）：

1. HTML 文件可在浏览器直接打开（自包含，无本地文件依赖）；三对 `@proto-gen` 标记块均已由脚本回填、无空块
2. 各 section 都有 `toc-sidebar` 对应入口
3. `prd-panel` 内容与 UI 元素一一对应
4. 没有使用 `references/css-components.md` 中未列出的自造类名
5. 通用区域与同目录最新一份原型视觉一致
