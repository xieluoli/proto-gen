# CSS 组件索引

> 视觉规范（颜色 / 字号 / 圆角）由 `assets/theme.css` 注入，可视样例见 `assets/components.html`（通用组件库）。
> 本文档只做**类名 → 用途 → 可视锚点**的索引。
>
> AI 生成原型 / 写 PRD 时：通过本表选用类名，直接说「展示主按钮，应用 `.btn-primary` 风格」，不要在 PRD 文档中复述颜色 hex / 圆角 px 等具体值。

适用范围：PC · macOS 系列。Mobile 系列后续以独立文件扩展（如 `css-components-mobile.md`），不混入本文件。

## 通用组件原语（在 `components.html` 展示）

| 组件名 | 主类名 | 可视锚点 | 何时用 |
|---|---|---|---|
| **按钮** |  |  |  |
| 主按钮 | `.btn .btn-primary` | [`#comp-btn-primary`](../assets/components.html#comp-btn-primary) | 主行动 CTA、表单提交、对话框确认 |
| 次按钮 | `.btn .btn-secondary` | [`#comp-btn-secondary`](../assets/components.html#comp-btn-secondary) | 取消、副行动、并列主按钮的次选择 |
| 幽灵按钮 | `.btn .btn-ghost` | [`#comp-btn-ghost`](../assets/components.html#comp-btn-ghost) | 透明底，弱化次级动作（工具栏、卡片内联） |
| 危险按钮 | `.btn .btn-danger` | [`#comp-btn-danger`](../assets/components.html#comp-btn-danger) | 破坏性操作：删除、卸载、清空、重置 |
| 尺寸变体 | `.btn-sm` / `.btn-lg` | [`#comp-btn-sizes`](../assets/components.html#comp-btn-sizes) | 紧凑场景 sm，强调主行动 lg |
| **输入** |  |  |  |
| 输入框 | `.input` | [`#comp-input`](../assets/components.html#comp-input) | 通用单行文本 |
| 等宽输入框 | `.input.input-mono` | [`#comp-input-mono`](../assets/components.html#comp-input-mono) | API Key / 路径 / 命令等 mono 内容 |
| 多行文本 | `.form-textarea` | [`#comp-textarea`](../assets/components.html#comp-textarea) | 多行输入；可垂直拖拽 |
| 下拉选择 | `.form-combobox` | [`#comp-combobox`](../assets/components.html#comp-combobox) | 带 chevron 的下拉 |
| 密码输入 | `.form-input-wrap` + `.form-eye` | [`#comp-password`](../assets/components.html#comp-password) | 密码切换明文 / 密文 |
| **表单** |  |  |  |
| 表单字段 | `.form-group` + `.form-label` + `.form-input` | [`#comp-form-group`](../assets/components.html#comp-form-group) | 标签 + 输入 + 可选说明 |
| 小尺寸表单 | `.form-input--sm` / `.form-label--sm` | [`#comp-form-group`](../assets/components.html#comp-form-group) | 嵌套场景紧凑展示 |
| 字段说明 | `.form-tip` | [`#comp-form-group`](../assets/components.html#comp-form-group) | 字段下方灰色辅助说明 |
| 两列并排 | `.form-row-2` | [`#comp-form-group`](../assets/components.html#comp-form-group) | 两个字段水平并排 |
| 表单按钮区 | `.form-actions` | [`#comp-form-actions`](../assets/components.html#comp-form-actions) | 表单底部按钮区；默认右对齐 |
| **卡片** |  |  |  |
| 信息卡 | `.info-card` + `.info-row` | [`#comp-info-card`](../assets/components.html#comp-info-card) | 通用信息容器 + 字段名/值列 |
| 空状态卡片 | `.empty-card` | [`#comp-empty-card`](../assets/components.html#comp-empty-card) | 空列表 / 空库引导添加首条数据 |
| **Badge** |  |  |  |
| 徽标 | `.badge .badge-{tone}` | [`#comp-badge`](../assets/components.html#comp-badge) | `default / success / warn / error / info` 5 套；font-weight 600 |
| 含图标徽标 | `.badge` + lucide icon | [`#comp-badge-icon`](../assets/components.html#comp-badge-icon) | badge 内含 10×10 icon |
| **Tabs** |  |  |  |
| 行内 Tab | `.inline-tabs` + `.inline-tab` | [`#comp-inline-tabs`](../assets/components.html#comp-inline-tabs) | 纯文字 tab，筛选 / 分类切换 |
| **弹窗** |  |  |  |
| 表单对话框 | `.form-dialog` + `.modal-close-x` + `.form-actions` | [`#comp-form-dialog`](../assets/components.html#comp-form-dialog) | 常规弹窗容器 |
| 危险确认 | `.form-dialog`（食谱） | [`#comp-destructive-confirm`](../assets/components.html#comp-destructive-confirm) | 不可撤销操作；红色警告头 + 横条 + 红色实心 |
| **侧栏** |  |  |  |
| 导航项 | `.sidebar-item` / `.sidebar-item.active` | [`#comp-sidebar`](../assets/components.html#comp-sidebar) | 主导航；active 用 sidebar-accent 背景 |
| 分组标题 | `.sidebar-section-header` | [`#comp-sidebar`](../assets/components.html#comp-sidebar) | 全大写 + tracking + 灰色 |
| 分隔线 | `.sidebar-divider` | [`#comp-sidebar`](../assets/components.html#comp-sidebar) | 水平 1px |
| 子 badge | `.sidebar-item .si-badge` | [`#comp-sidebar`](../assets/components.html#comp-sidebar) | 导航项右侧小 badge |
| 导航 icon | `.nav-icon` | — | 16×16 + stroke-width 1.75 |
| **Toggle** |  |  |  |
| 开关 | `.toggle-switch` + `.toggle-slider` | [`#comp-toggle`](../assets/components.html#comp-toggle) | 二态；切换即生效；禁用用 `.is-disabled` |
| **进度 / 动效** |  |  |  |
| 进度条 | `.progress-bar` + `.progress-fill .indigo` / `.amber` | [`#comp-progress-bar`](../assets/components.html#comp-progress-bar) | 线性进度 |
| 脉冲点 | `.pulse-dot` | [`#comp-loading`](../assets/components.html#comp-loading) | 运行中状态 |
| Spinner | `.spin` | [`#comp-loading`](../assets/components.html#comp-loading) | 配合 `data-lucide="loader-2"` |
| 骨架屏 | `@keyframes breathe` 工具类 | [`#comp-loading`](../assets/components.html#comp-loading) | 加载占位呼吸动画 |
| **PRD 旁注**（proto-gen 专属） |  |  |  |
| 面板容器 | `.prd-panel` + `.prd-panel-wrap` | [`#comp-prd-panel`](../assets/components.html#comp-prd-panel) | 原型右侧旁注 |
| 面板标题 | `.prd-panel__title` | [`#comp-prd-panel`](../assets/components.html#comp-prd-panel) | 「功能概览」标题 |
| 面板正文 | `.prd-panel__body` | [`#comp-prd-panel`](../assets/components.html#comp-prd-panel) | 滚动容器 |
| 分组 | `.prd-section` + `.prd-section__title` | [`#comp-prd-panel`](../assets/components.html#comp-prd-panel) | 一段功能描述 |

## 业务衍生类（**不**在 `components.html` 展示）

下面这些类是某些业务原型沉淀下来的高频模式，**继续可用**，但不属于通用组件原语；新原型如能用通用原语解决，**不要**走这些业务衍生。如果你的需求确实匹配这类业务场景，直接用即可。

| 业务衍生类 | 用途 | 适用场景示例 |
|---|---|---|
| `.channel-card` / `.channel-card.default` / `.channel-actions` / `.channel-action-btn` | 列表项卡片，hover 浮出操作条；`.default` 左侧主色边标识默认项 | 模型渠道列表 / Agent 实例列表 / 多账户切换 |
| `.channel-action-btn.danger` / `.channel-action-btn.is-disabled` + `.ca-tip` | 卡片操作条按钮的危险变体 + 禁用变体（带 tooltip 解释） | 删除按钮 / 默认项不可删提示 |
| `.agent-tabs` / `.agent-tab` / `.agent-tab--active` / `.agent-tab__badge` / `.agent-tab__fallback` | 横向品牌 tab（含 logo + 可选 badge） | 按 Agent 切换配置面板（Claude / Codex / Cursor 等） |
| `.apply-popover` / `.ap-item` / `.ap-footer` | 锚定卡片底部展开的多选 + 确认浮层 | 「应用到 N 个 Agent」类的快捷决定 |
| `.badge-free` | 用户身份 / 套餐标识（FREE / PRO） mono 字体 | 用户中心徽标 |
| `.empty-card` 业务变体 | （通用版已在组件库；业务侧用相同类） | — |
| `.kpi-cards` / `.kpi-value` / `.kpi-trend` / `.dist-row` / `.dist-bar-wrap` | 用量看板金刚区 4 卡 + 分布行 | Token 用量统计页 |
| `.agent-filter` / `.export-dropdown` / `.agent-filter-btn` / `.export-btn` | 顶栏 Agent 筛选 + 导出下拉 | 用量看板顶栏 |
| `.usage-detail-table` 及子选择器 | 用量明细表格 | 调用明细列表 |
| `.pricing-grid` / `.price-card` / `.price-card.featured` | 套餐价格卡片网格 | 充值 / 升级页 |
| `.win-chrome-bar` / `.win-chrome-btn` / `.win-credits` / `.win-avatar-chip` | macOS 风格主区顶部操作栏 | 应用顶栏 |
| `.win-avatar-menu` 及子选择器 | 用户头像下拉菜单 | 顶栏用户区 |
| `.login-modal` / `.login-overlay` 及子选择器 | 登录弹窗 / 登录浮层 | 登录页 / 未登录拦截 |
| `.win-login-btn` | 未登录态 chrome bar 上的「登录」按钮 | 顶栏 |
| `.env-issue-summary` / `.env-issue-badge` / `.env-action-chip` / `.env-source-chip` / `.env-prereq-row` | 环境管理：问题汇总条、问题计数 badge、命令/来源 chip、必要依赖行 | 环境管理页 |
| `.env-drawer` 及子选择器 | 环境管理：问题详情右侧抽屉 | 环境管理页 |
| `.toc-sidebar` / `.toc-item` / `.toc-dot` / `.toc-mirror-tag` | 原型自身的 TOC 目录导航（不是产品里的 sidebar） | 多 section 原型 |
| `.proto-nav` / `.proto-back` / `.proto-title` / `.proto-with-prd` | 原型自身的顶栏 + PRD 旁注容器 | 所有原型外壳 |
| `.macos-window` / `.macos-titlebar` / `.macos-dot` / `.macos-body` / `.app-sidebar` / `.app-main` | macOS 窗口骨架 + 三段布局 | 所有原型外壳 |
| `.launch-btn` / `.qr-placeholder` / `.app-topbar` / `.app-avatar` / `.app-breadcrumb` / `.phone-input-wrap` / `.hero-icon` / `.info-icon` / `.store-card` / `.detail-screenshot` / `.detail-section-title` / `.search-shortcut` / `.model-badges` / `.model-toggle` | 散落业务场景的高频小组件 | 商店 / 详情 / 列表等 |

> **判断规则**：写原型时**优先**用通用组件原语；只有当现有原语完全无法组合出目标视觉时，才查上表是否有业务衍生类。**不要**自造新业务衍生类——如出现重复模式 3 次以上再沉淀到 `shared.css` 并在本表登记。

## 工具类 / inline style

少量场景需要 inline style，**仅限**以下情况：

| 场景 | 写法 |
|---|---|
| 等宽字体 | `style="font-family:var(--font-mono);"` |
| 次级文字色 | `style="color:var(--text-2);"` |
| 三级文字色 | `style="color:var(--text-3);"` |
| 主色文字 | `style="color:var(--primary);"` |
| 两端对齐行 | `style="display:flex;align-items:center;justify-content:space-between;"` |
| 隐藏但保留空间 | `style="visibility:hidden;"` |
| 主区 dimmed 态（弹窗叠加时） | `style="pointer-events:none;filter:brightness(0.97);"` |

不要 inline 颜色 hex / px 圆角 / 字号 —— 用 token 引用或专用类。

## 非对称 form-actions（左 danger / 右 cancel-save）

编辑型表单底部，左侧放危险操作（删除），右侧放主流程按钮（取消 + 保存）：

```html
<div class="form-actions" style="justify-content:space-between;">
  <button class="btn btn-danger btn-sm">Delete</button>
  <div style="display:flex;gap:8px;">
    <button class="btn btn-ghost btn-sm">Cancel</button>
    <button class="btn btn-primary btn-sm">Save</button>
  </div>
</div>
```

创建场景不渲染左侧 danger 按钮即可回到默认右对齐。可视样例见 [`#comp-form-actions`](../assets/components.html#comp-form-actions)。

## 何时扩本表

新需求出现一个现有组件都不匹配的视觉元素时：

1. 判断是「通用原语」还是「业务衍生」
2. 通用原语：在 `assets/components.html` 加一行 `comp-{name}`（4 态样例 + 应用场景），`assets/shared.css` 补对应类（用 var() 引用，不写 hex/px），回到本表「通用组件原语」段追加一行
3. 业务衍生：`assets/shared.css` 补类，在本表「业务衍生类」段追加一行；**不**在 `components.html` 展示

**严禁**：把新组件 hex 值散写在原型 HTML 的 inline style 或新的 `<style>` 段——视觉规范必须沉淀到 components.html + shared.css。
