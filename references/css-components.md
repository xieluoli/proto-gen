# CSS 组件速查

> **适用范围**：PC · macOS 系列。Mobile 系列后续以独立文件扩展（如 `css-components-mobile.md`），不混入本文件。

所有类来自 `shared.css`，按功能分组。不要自造未在此列出的类名。

## 设计 Token（CSS 变量）

```
颜色
--primary: #6366F1      主色（indigo）
--primary-hover         hover 态
--primary-light         主色浅色背景 rgba(99,102,241,0.08)
--success: #10B981      成功绿
--warning: #F59E0B      警告黄
--error: #EF4444        错误红
--bg: #FAFAFA           页面背景
--surface: #FFFFFF      卡片/面板背景
--text: #0A0A0A         主文字
--text-2: #6B6B6B       次级文字
--text-3: #9C9C9C       三级文字（占位符、弱提示）
--border: #E8E8EC       普通描边
--border-2: #D4D4D8     强调描边

字体
--font-display: 'General Sans'   标题/数字
--font-body: 'DM Sans'           正文
--font-mono: 'JetBrains Mono'    代码/版本号/路径

圆角
--radius-chip: 4px    badge
--radius-btn: 6px     按钮/输入框
--radius-panel: 8px   小面板
--radius-card: 12px   卡片
--radius-full: 9999px 胶囊
```

---

## 布局

| 类 | 用途 |
|---|---|
| `.page-stack` | 垂直堆叠所有 section，`gap:48px`，居中 |
| `.section-label` | section 编号标签（如「Home-01」） |
| `.macos-window` | 1080px 宽 macOS 窗口容器 |
| `.macos-body` | 窗口主体，grid: 212px sidebar + 1fr |
| `.app-sidebar` | 左侧导航栏 212px |
| `.win-chrome-bar` | 顶栏（grid-row:1，grid-col:2） |
| `.app-main` | 主内容区（grid-row:2，grid-col:2），`padding:24px 28px;max-height:540px;overflow-y:auto` |
| `.proto-with-prd` | 原型+PRD 并排 flex 容器 |
| `.prd-panel-wrap` | PRD 面板占位（width:360px） |
| `.prd-panel` | PRD 面板（绝对定位，随 macos-window 高度） |
| `.grid-2/3/4` | 2/3/4 列等宽网格，gap:10px |

---

## 侧边栏组件

| 类 | 用途 |
|---|---|
| `.sidebar-section-header` | 分组标题（全大写，灰色） |
| `.sidebar-item` | 导航项，含 icon + 文字 |
| `.sidebar-item.active` | 当前页高亮（主色背景 + 主色文字） |
| `.sidebar-divider` | 水平分隔线 |
| `.sidebar-apps` | 我的应用列表（可滚动） |
| `.sidebar-item .si-badge` | 导航项右侧小 badge（如警告计数） |
| `.nav-icon` | 导航图标（16×16，flex-shrink:0） |

---

## 按钮

```html
<!-- 主色实心 -->
<button class="btn btn-primary">文字</button>
<button class="btn btn-primary btn-lg">大按钮</button>
<button class="btn btn-primary btn-sm">小按钮</button>

<!-- 次级（边框） -->
<button class="btn btn-secondary">文字</button>

<!-- 幽灵（透明底） -->
<button class="btn btn-ghost">文字</button>
<button class="btn btn-ghost btn-sm">小幽灵</button>

<!-- 危险（红色边框） -->
<button class="btn btn-danger">卸载</button>

<!-- 禁用态 -->
<button class="btn btn-ghost btn-sm" disabled style="color:var(--text-3);">已安装</button>
```

### 非对称 form-actions（左 danger / 右 cancel-save）

编辑型表单底部，左侧放危险操作（删除），右侧放主流程按钮（取消 + 保存）。

```html
<div class="form-actions" style="justify-content:space-between;">
  <button class="btn btn-danger btn-sm">删除</button>
  <div style="display:flex;gap:8px;">
    <button class="btn btn-ghost btn-sm">取消</button>
    <button class="btn btn-primary btn-sm">保存</button>
  </div>
</div>
```

要点：

- 默认 `.form-actions` 是右对齐 flex；用 inline `justify-content:space-between` 切换为两端对齐
- 创建场景下不渲染左侧 danger 按钮，回到默认右对齐
- 建议未来在 shared.css 抽 `.form-actions--split` 修饰符替代 inline style

---

## 输入控件

```html
<!-- 普通输入框 -->
<input class="input" placeholder="..." />
<input class="input input-mono" placeholder="sk-..." />  <!-- 等宽字体 -->

<!-- 表单输入框（在 form-group 中） -->
<div class="form-group">
  <label class="form-label">字段名</label>
  <input class="form-input" placeholder="..." />
</div>

<!-- 密码框（带眼睛图标） -->
<div class="form-group">
  <label class="form-label">API Key</label>
  <div class="form-input-wrap">
    <input class="form-input" type="password" placeholder="sk-..." />
    <button class="form-eye">
      <i data-lucide="eye" class="eye-on" style="width:14px;height:14px;"></i>
      <i data-lucide="eye-off" class="eye-off" style="width:14px;height:14px;"></i>
    </button>
  </div>
</div>

<!-- 多行文本 -->
<textarea class="form-textarea" rows="4" placeholder="..."></textarea>

<!-- Combobox（带下拉）-->
<div class="form-combobox">
  <input class="form-input" placeholder="选择..." />
  <button class="form-chevron"><i data-lucide="chevron-down" style="width:14px;height:14px;"></i></button>
  <div class="combobox-menu">
    <div class="combobox-option" data-value="x">
      <img src="...icon..." />选项名
    </div>
  </div>
</div>
```

### 表单小尺寸变体（用于嵌套场景）

当表单字段嵌套在 tab pane / 卡片内部时，用 `--sm` 修饰符紧凑展示；`.form-row-2` 用于并排两个字段。

```html
<div class="form-row-2">
  <div>
    <label class="form-label form-label--sm">字段 1</label>
    <input class="form-input form-input--sm" placeholder="..." />
  </div>
  <div>
    <label class="form-label form-label--sm">字段 2</label>
    <input class="form-input form-input--sm" placeholder="..." />
  </div>
</div>

<!-- 字段下方的灰色解释文 -->
<div class="form-tip">这是一句对上方字段的辅助说明，灰色小字。</div>
```

适用场景：tab pane 内的字段集、设置类卡片内的多字段、需要并列展示的成对字段（如「默认 / Opus / Sonnet / Haiku」4 字段 2×2 网格）。

### 只读字段（系统下发 / 不可编辑场景）

```html
<div class="form-group">
  <label class="form-label">字段名</label>
  <input class="form-input" value="系统下发的值" readonly>
  <div class="form-tip">默认值由账号绑定，前端只读。</div>
</div>

<!-- 密码类只读字段：保留眼睛图标切换明文/密文，但 input 不可编辑 -->
<div class="form-group">
  <label class="form-label">API Key</label>
  <div class="form-input-wrap">
    <input class="form-input" type="password" value="sk-****c9e2" readonly>
    <button class="form-eye"><i data-lucide="eye"></i></button>
  </div>
</div>
```

要点：

- 用原生 `readonly` 属性 + `.form-tip` 解释为什么只读，**不要**用 `disabled`（会丢失键盘选中能力，妨碍用户查看内容）
- combobox 在只读时不渲染 `.form-chevron`（用户无下拉选择权）
- 建议未来在 shared.css 抽一个 `.form-input--readonly` 修饰符代替对 `readonly` 属性的样式选择器，便于显式控制视觉

---

## 卡片

```html
<!-- 基础信息卡 -->
<div class="info-card">
  <div class="info-row">
    <span class="info-label">字段名</span>
    <span class="info-value">值</span>
  </div>
</div>

<!-- 渠道卡片 -->
<div class="channel-card">
  <!-- 内容 -->
  <div class="channel-actions">
    <button class="channel-action-btn"><i data-lucide="pencil"></i><span class="ca-tip">编辑</span></button>
    <button class="channel-action-btn danger"><i data-lucide="trash-2"></i><span class="ca-tip">删除</span></button>
  </div>
</div>
<div class="channel-card default"><!-- 默认渠道左侧有主色边框 --></div>
```

### 卡片悬浮操作条（hover-revealed action toolbar）

在卡片右上角浮出一组纯图标按钮，hover 时显示，每个按钮带 tooltip。适用于「列表 + 多卡片」场景的快捷操作。

```html
<div class="channel-card">
  <div class="channel-actions">
    <button class="channel-action-btn">
      <i data-lucide="pencil" style="width:13px;height:13px;"></i>
      <span class="ca-tip">编辑</span>
    </button>
    <!-- 禁用变体：灰色 + not-allowed 光标 + 自定义解释 tooltip -->
    <button class="channel-action-btn danger is-disabled" disabled>
      <i data-lucide="trash-2" style="width:13px;height:13px;"></i>
      <span class="ca-tip">默认渠道不可删除</span>
    </button>
  </div>
  <!-- 卡片正文 -->
</div>
```

要点：

- `.channel-actions` 绝对定位在卡片右上角，默认隐藏，父卡片 hover 时显示
- `.channel-action-btn.danger` 危险动作（红色），与普通动作的中性灰区分
- `.is-disabled` 修饰符：渲染禁用态（灰色 + `not-allowed` 光标 + 透明 hover 背景），点击无响应；`.ca-tip` 文案用于解释禁用原因，避免歧义
- 演示态可加 `.show-actions` 修饰符强制操作条可见（用于截图/原型审查）

### 空状态占位卡片（empty-state placeholder card）

列表/库为空时的兜底卡片，主 CTA 下沉到卡内：虚线边框 + 透明背景 + 居中加号徽块 + 主标题 + 副标题，整卡可点击。适用「空库 → 引导添加首条数据」类场景。

```html
<div class="empty-card" onclick="...打开添加子页...">
  <div class="empty-card__icon"><i data-lucide="plus" style="width:18px;height:18px;"></i></div>
  <div class="empty-card__title">点击添加{对象名}</div>
  <div class="empty-card__desc">{一句话引导，说明配置完后能做什么}</div>
</div>
```

要点：

- 与 `.channel-card`（实心已填充态）形成**视觉对比**——虚线 vs 实线、透明 vs 白底
- hover 时主色边框 + 浅主色背景（`--primary-light`），强化可点击性
- 顶部不需要再放「+ 添加」按钮——避免双 CTA 噪音；主 CTA 已下沉到占位卡内
- 副标题用 `--text-3` 弱化，主标题用 `--text` 加粗
- 适用「空渠道库 / 空 Agent 库 / 空 Skill 库 / 空收件箱」等所有需要引导首条数据的场景

---

## Badge

```html
<span class="badge">默认灰</span>
<span class="badge badge-success">健康 / 已安装 / 已完成</span>
<span class="badge badge-warn">警告 / 待处理</span>
<span class="badge badge-error">缺失 / 异常 / 错误</span>
<span class="badge badge-info">提示 / 信息 / 默认</span>
```

---

## Tabs

```html
<div class="inline-tabs">
  <button class="inline-tab active">全部</button>
  <button class="inline-tab">推荐</button>
  <button class="inline-tab">CLI 工具</button>
</div>
```

### 品牌 tabs（branded tabs + per-pane form）

横向 tab，每个 tab 带品牌 logo（或首字母兜底）+ 可选版本 badge。点击切换下方 `.agent-pane`。适用于「按对象/品牌切换配置面板」。

```html
<div class="agent-tabs">
  <button type="button" class="agent-tab agent-tab--active" data-agent="claude-code">
    <img src="https://unpkg.com/@lobehub/icons-static-svg@latest/icons/claude-color.svg" alt="">
    <span>Claude Code</span>
  </button>
  <button type="button" class="agent-tab" data-agent="codex">
    <img src="https://unpkg.com/@lobehub/icons-static-svg@latest/icons/openai.svg" alt="">
    <span>Codex</span>
    <span class="agent-tab__badge">v0.0.4+</span>
  </button>
  <!-- 无 logo 品牌走兜底块 -->
  <button type="button" class="agent-tab" data-agent="custom">
    <span class="agent-tab__fallback" style="background:linear-gradient(135deg,var(--primary),#818cf8);">C</span>
    <span>Custom</span>
  </button>
</div>

<!-- 每个 tab 对应一个 pane -->
<div class="agent-pane" data-agent="claude-code">
  <!-- pane 1 字段 -->
</div>
<div class="agent-pane" data-agent="codex" style="display:none;">
  <!-- pane 2 字段 -->
</div>
```

配套切换 JS（约 11 行）：

```js
document.querySelectorAll('.agent-tabs').forEach(function(bar){
  bar.querySelectorAll('.agent-tab').forEach(function(tab){
    tab.addEventListener('click', function(){
      bar.querySelectorAll('.agent-tab').forEach(function(t){ t.classList.remove('agent-tab--active'); });
      tab.classList.add('agent-tab--active');
      var formGroup = bar.closest('.form-group');
      var panes = formGroup ? formGroup.querySelectorAll('.agent-pane[data-agent]') : [];
      if (panes.length > 1) {
        var target = tab.dataset.agent;
        panes.forEach(function(p){ p.style.display = (p.dataset.agent === target) ? '' : 'none'; });
      }
    });
  });
});
```

与 `.inline-tabs` 的区别：

- `.inline-tabs` 纯文字 tab，用于「筛选/分类切换」（如全部 / 推荐 / CLI 工具）
- `.agent-tabs` 带 logo + badge，用于「按对象切换配置面板」（如不同 Agent 的字段映射）

---

## 弹窗 / 对话框

```html
<!-- form-dialog（用于弹窗内容容器） -->
<div class="form-dialog">
  <button class="modal-close-x"><i data-lucide="x"></i></button>
  <div class="form-dialog-title">弹窗标题</div>
  <!-- form-group 字段 -->
  <div class="form-actions">
    <button class="btn btn-ghost">取消</button>
    <button class="btn btn-primary">确认</button>
  </div>
</div>
```

### 卡片锚点 popover（anchored popover）

锚定到卡片底部展开的多选 + 确认浮层，比 modal 轻量。适合「针对当前卡片做一个小决定」的场景。

```html
<div class="channel-card show-actions">
  <!-- 卡片正文 -->
  <div class="apply-popover">
    <div class="ap-title">应用到 Agent</div>
    <label class="ap-item"><input type="checkbox" checked><span>Claude Code</span></label>
    <label class="ap-item"><input type="checkbox"><span>Cursor</span></label>
    <div class="ap-footer">
      <button class="btn btn-ghost btn-sm">取消</button>
      <button class="btn btn-primary btn-sm">确认应用</button>
    </div>
  </div>
</div>
```

要点：

- popover 是卡片的子节点，**不脱离卡片**，跟随卡片定位
- 与 modal 区别：不全局遮罩、不阻塞页面其他操作；仅在当前卡片上下文内有效
- 适用「多选 + 一次提交」类的快捷决定，超过 3 个字段建议改 subpage

### destructive confirm dialog 视觉食谱

不是新类，是**固定的视觉配方**，用现有 `.form-dialog` + 内部排版实现。所有"不可撤销的删除/重置"操作都应套用此食谱保持一致。

```html
<div class="form-dialog" style="width:360px;">
  <button class="modal-close-x"><i data-lucide="x"></i></button>

  <!-- 头部：32px 圆形浅红底 + alert-triangle 红色 16px -->
  <div style="display:flex;align-items:flex-start;gap:12px;margin-bottom:12px;">
    <div style="width:32px;height:32px;border-radius:50%;background:#fee2e2;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
      <i data-lucide="alert-triangle" style="width:16px;height:16px;color:#dc2626;"></i>
    </div>
    <div>
      <div class="form-dialog-title" style="margin-bottom:6px;">删除 {对象名}？</div>
      <div style="font-size:12px;color:var(--text-2);line-height:1.6;">
        即将删除 <strong style="color:var(--text);">{对象名}</strong>。{副作用说明}。
      </div>
    </div>
  </div>

  <!-- 浅红横条：不可撤销提醒 -->
  <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:6px;padding:10px 12px;margin-bottom:18px;">
    <div style="font-size:11px;color:#991b1b;line-height:1.6;display:flex;align-items:flex-start;gap:6px;">
      <i data-lucide="info" style="width:12px;height:12px;margin-top:2px;flex-shrink:0;"></i>
      <span>此操作不可撤销。{将被清除的具体内容}。</span>
    </div>
  </div>

  <!-- 底部按钮：右下对齐，确认按钮危险色实心 -->
  <div class="form-actions">
    <button class="btn btn-ghost btn-sm">取消</button>
    <button class="btn btn-sm" style="background:#dc2626;color:#fff;padding:5px 14px;">确认删除</button>
  </div>
</div>
```

色板（不在 token 中，inline 使用即可，保持配方稳定）：

| 用途 | 色值 |
|---|---|
| 头部圆形背景 | `#fee2e2` |
| 警告图标 | `#dc2626` |
| 横条背景 | `#fef2f2` |
| 横条描边 | `#fecaca` |
| 横条文字 | `#991b1b` |
| 确认按钮背景 | `#dc2626` |

适用场景：删除渠道 / 删除应用 / 重置配置 / 清空数据 等不可撤销操作。简单的二次确认（如「确定退出？」）不需要走此食谱，直接用 `.form-dialog` 基础结构即可。

---

## Toggle 开关

```html
<label class="toggle-switch">
  <input type="checkbox" checked />
  <span class="toggle-slider"></span>
</label>
```

---

## 进度条

```html
<div class="progress-bar">
  <div class="progress-fill indigo" style="width:67%;"></div>  <!-- 主色 -->
  <div class="progress-fill amber" style="width:40%;"></div>   <!-- 黄色 -->
</div>
```

---

## 动效类

| 类 | 效果 |
|---|---|
| `.pulse-dot` | 绿色脉冲圆点（运行状态） |
| `.spin` | 旋转动画（loading spinner） |
| `@keyframes breathe` | 骨架屏呼吸动画 |

骨架屏占位块（体检加载态）：
```html
<div style="height:16px;background:#f0f0f3;border-radius:4px;animation:breathe 1.5s ease-in-out infinite;"></div>
```

---

## 工具类（常用 inline style）

| 场景 | 写法 |
|---|---|
| 等宽字体 | `style="font-family:var(--font-mono);"` |
| Display 字体（大数字标题） | `style="font-family:var(--font-display);font-size:20px;font-weight:700;"` |
| 次级文字色 | `style="color:var(--text-2);"` |
| 三级文字色 | `style="color:var(--text-3);"` |
| 主色文字 | `style="color:var(--primary);"` |
| 两端对齐行 | `style="display:flex;align-items:center;justify-content:space-between;"` |
| 隐藏但保留空间 | `style="visibility:hidden;"` |
| 主区 dimmed 态（弹窗叠加时） | `style="pointer-events:none;filter:brightness(0.97);"` |

### 展开/收起切换（badge 列表过长）

```html
<div class="model-badges">
  <span class="badge">item-1</span>
  <span class="badge">item-2</span>
  <!-- ... 很多 item -->
</div>
<button class="model-toggle"
        onclick="var b=this.previousElementSibling;b.classList.toggle('expanded');this.textContent=b.classList.contains('expanded')?'收起':'展开 N+';">
  <span style="color:var(--primary);">展开 N+</span>
</button>
```

要点：

- `.model-badges` 默认 `max-height` 限制只显示 1-2 行
- `.model-badges.expanded` 解除高度限制
- `.model-toggle` 是主色文字按钮（非块状），文案在「展开 N+ / 收起」之间切换
- 同模式适用任何「列表过长需要折叠」场景，不限于 badge

---

## PRD 面板专用类

```
.prd-panel-wrap        宽度 360px，relative，align-self:stretch
.prd-panel             absolute inset:0，flex-column，overflow:hidden
.prd-panel__title      面板标题（14px，加粗，flex-shrink:0）
.prd-panel__body       可滚动内容区（flex:1，min-height:0，overflow-y:auto）
.prd-section           功能概览分组
.prd-section__title    分组标题（12px，主色，加粗）
.prd-section ul        无序列表（padding-left:16px）
.prd-section li        条目（11.5px，line-height:1.7，text-2 色）
```
