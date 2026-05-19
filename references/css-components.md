# CSS 组件速查

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
