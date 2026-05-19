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

## 设计系统资产

本 skill 自带一套设计系统：

- `assets/shared.css` — 完整设计 token + 组件类（颜色、字体、按钮、卡片、弹窗、表单、PRD 面板等）
- `assets/example.html` — 最小可运行示例，展示 macOS 窗口（左侧边栏 + 顶部工具栏 + 内容区） + 旁注 PRD 面板的整体布局

> 首次使用：把 `assets/shared.css` 拷贝到目标项目的原型目录下，所有生成的 HTML 通过相对路径 `href="shared.css"` 引用。
> 想快速预览整体风格，直接在浏览器打开 `assets/example.html`。

## 工作目录

由用户在调用时指定，例如 `designs/prototype/` 或 `prototypes/`。所有生成的 HTML 与 `shared.css` 放在同一目录下。

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
- **重复内容处理**：第一个 section 完整描述；后续 section 对相同通用结构用引用，只描述差异

### 5. 组装 HTML

参考 `references/html-structure.md` 的页面骨架模板，按顺序填入各 section。

最后写入用户指定目录下的 `{filename}.html`。

## 输出文件

- **HTML 原型**：`{user-dir}/{name}.html`（包含全部 sections）
- **（可选）PRD md**：如用户需要，同步生成 `{name}.md`

## 验证

生成后检查：

1. HTML 文件可在浏览器直接打开（`shared.css` 在同目录即可）
2. 各 section 都有 `toc-sidebar` 对应入口
3. `prd-panel` 内容与 UI 元素一一对应
4. 没有使用 `references/css-components.md` 中未列出的自造类名
