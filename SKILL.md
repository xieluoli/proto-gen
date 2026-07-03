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

- `assets/theme.css` — **主题 token 单一来源**（19 个 shadcn 核心 + 8 个 sidebar 子 token + 12 个状态色派生 + 字体 CDN）。默认 = tweakcn 724-1，可通过 `extract-theme.sh` 切换
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
~/.claude/skills/proto-gen/assets/inject-assets.mjs path/to/prototypes/
```

改完 `theme.css` / `shared.css` 后跑一次，所有带标记的原型统一换皮。脚本幂等，重复执行结果一致。

**存量原型一次性迁移**：把已有 `<style>` 中的 token 段（`:root { --background: ... }` 等）与通用组件样式删掉，原位放入上面的空标记块对（页面特有样式保留在标记块之外的独立 `<style>` 里），然后跑一次注入脚本回填。迁移后该文件即可参与批量刷新。

## References 总览

| 文件 | 内容 | 设备适用 |
|---|---|---|
| `references/html-structure.md` | 页面骨架 + 三种叠加态（modal / drawer / subpage） | PC · macOS 系列 |
| `references/css-components.md` | **类名 → 用途 → components.html 锚点** 索引表；不再含 hex / px 等具体值 | PC · macOS 系列 |
| `references/default-theme.md` | proto-gen 默认主题（724-1）说明 + 切换流程 + token 全表 + 切换后必须手工补的 3 项 | 设备无关 |
| `references/shadcn-tweakcn-theme.md` | **目标项目接入**：当原型要对齐业务项目自身主题时如何覆盖 `theme.css`（sidebar 子 token 陷阱 / 状态色派生 / 字体大小映射 / lucide 踩坑 / 自检清单） | 设备无关；项目接入场景 |
| `references/prd-rules.md` | PRD bullets 写法、元素描述模板、重复内容引用规则 | 设备无关 |
| `references/prd-highlight.md` | PRD ↔ 原型 双向 hover 联动：`data-comp` / `data-target` 命名约定 / scope / 交付剥离须知 | 设备无关 |

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
- **优先用类名引用替代具体值描述**：不要写「展示一个紫色 #6366F1 圆角 8px 主按钮」，而写「展示主按钮（应用 `.btn-primary` 风格）」。视觉规范由 `theme.css` 与 `components.html` 沉淀，PRD / 旁注只引用类名
- **重复内容处理**：第一个 section 完整描述；后续 section 对相同通用结构用引用，只描述差异
- **顺手绑定 highlight**：按 `references/prd-highlight.md` 给 bullet 加 `data-target="<key>"`、给原型组件加 `data-comp="<key>"`，开启 PRD ↔ 原型 双向 hover 联动

### 5. 组装 HTML

参考 `references/html-structure.md` 的页面骨架模板，按顺序填入各 section。

`<head>` 内**必须带注入标记块**（见「自包含注入机制」，标记内先留空即可），页面自有样式写在标记块之外。写入用户指定目录下的 `{filename}.html` 后，跑一次注入脚本回填样式：

```bash
~/.claude/skills/proto-gen/assets/inject-assets.mjs {user-dir}/{filename}.html
```

## 输出文件

- **HTML 原型**：`{user-dir}/{name}.html`（包含全部 sections，自包含单文件，token / 通用组件样式由注入脚本回填）
- **（可选）PRD md**：如用户需要，同步生成 `{name}.md`

## 验证

生成后检查：

1. HTML 文件可在浏览器直接打开（自包含，无本地文件依赖）；三对 `@proto-gen` 标记块均已由脚本回填、无空块
2. 各 section 都有 `toc-sidebar` 对应入口
3. `prd-panel` 内容与 UI 元素一一对应
4. 没有使用 `references/css-components.md` 中未列出的自造类名
