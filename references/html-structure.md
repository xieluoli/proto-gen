# HTML 页面骨架

> **适用范围**：PC · macOS 系列。Mobile 系列后续以独立文件扩展（如 `html-structure-mobile.md`），不混入本文件。

所有原型 HTML 使用统一骨架，复制此模板后按需填入。

## section-label 编号约定

每个 section 顶部挂 `<div class="section-label">{名称}-{编号}</div>`，告诉评审人「现在在第几节」，与左侧 toc 互为冗余校验。

### 编号格式

| 形态 | 写法 | 用途 |
|---|---|---|
| **主序号** | `{名称}-01` / `-02` / `-03` | 主流程页面之间的顺序 |
| **变体编号** | `{名称}-02-编辑` / `-02-删除` | 同一序号下的多个形态（编辑态、确认弹窗、错误态等），共享上下文，**不占主序号** |
| **空状态** | `{名称}-01（空状态）` | 同一页的空态作为括号注，不切变体 |

例（model-mgmt 系列）：

```
模型库-01           主页 · 空状态
模型库-02           添加渠道子页
模型库-02-编辑      编辑渠道子页（与 -02 同结构，不同入口）
模型库-02-删除      删除二次确认（叠在 -02-编辑 之上）
模型库-03           多渠道 + hover 操作（主页 · 填充态）
```

### 取舍

- 主序号代表「**新页面/新视图**」，变体编号代表「**同页面的另一种形态**」
- 评审人按主序号顺读就能走完主流程，变体仅在需要对照时跳读
- 同一序号下的变体超过 3 个时，重新审视是不是该独立成主序号

---

## 完整骨架

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>{页面名} · 原型</title>
<link href="https://api.fontshare.com/v2/css?f[]=general-sans@400,500,600,700&display=swap" rel="stylesheet" />
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="shared.css" />
<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
</head>
<body>

<!-- 顶部导航栏 -->
<nav class="proto-nav">
  <a href="index.html" class="proto-back"><i data-lucide="arrow-left"></i>返回原型索引</a>
  <span class="proto-title">{页面名}</span>
</nav>

<div class="proto-toc-layout">

<!-- 左侧页面索引 -->
<nav class="toc-sidebar">
  <div class="toc-title">页面导航</div>
  <a class="toc-item" href="#section-xxx"><span class="toc-dot"></span>{名称}-01</a>
  <!-- 每个 section 对应一个 toc-item -->
</nav>

<!-- 主内容区 -->
<div class="page-stack" style="padding-top:40px;">

<!-- Section 示例 -->
<div id="section-xxx">
  <div class="section-label">{名称}-01</div>
  <div class="proto-with-prd">

    <div class="macos-window">
      <div class="macos-titlebar">
        <div class="macos-dot red"></div>
        <div class="macos-dot yellow"></div>
        <div class="macos-dot green"></div>
        <div class="macos-title">{App Name} — {窗口标题}</div>
      </div>
      <div class="macos-body">
        <!-- 侧边栏 -->
        <div class="app-sidebar">
          <!-- 见 app-sidebar 模板 -->
        </div>
        <!-- 顶栏 -->
        <div class="win-chrome-bar">
          <!-- 见 win-chrome-bar 模板 -->
        </div>
        <!-- 主区 -->
        <div class="app-main">
          <!-- 页面内容 -->
        </div>
      </div>
    </div>

    <!-- PRD 面板 -->
    <div class="prd-panel-wrap">
      <aside class="prd-panel">
        <div class="prd-panel__title">功能概览</div>
        <div class="prd-panel__body">
          <div class="prd-section">
            <div class="prd-section__title">{名称}-01：{页面短名}</div>
            <ul>
              <li>展示...</li>
            </ul>
          </div>
        </div>
      </aside>
    </div>

  </div>
</div>

</div><!-- end page-stack -->

</div><!-- end proto-toc-layout -->

<script>
  if (window.lucide) lucide.createIcons();

  /* TOC 滚动高亮 */
  (function() {
    var sectionMap = {
      'section-xxx': '{名称}-01',
      /* 每个 section 一条 */
    };
    var tocItems = document.querySelectorAll('.toc-item');
    var ticking = false;
    window.addEventListener('scroll', function() {
      if (!ticking) {
        requestAnimationFrame(function() {
          var scrollPos = window.scrollY + 120;
          var currentId = null;
          var ids = Object.keys(sectionMap);
          for (var i = ids.length - 1; i >= 0; i--) {
            var el = document.getElementById(ids[i]);
            if (el && el.offsetTop <= scrollPos) { currentId = ids[i]; break; }
          }
          tocItems.forEach(function(item) {
            item.classList.remove('active');
            if (item.getAttribute('href') === '#' + currentId) item.classList.add('active');
          });
          ticking = false;
        });
        ticking = true;
      }
    });
    if (tocItems.length > 0) tocItems[0].classList.add('active');
  })();
</script>

</body>
</html>
```

---

## app-sidebar 标准模板

```html
<div class="app-sidebar">
  <div style="padding:4px 14px 12px;display:flex;align-items:center;gap:8px;">
    <div style="width:22px;height:22px;border-radius:5px;background:var(--primary);display:flex;align-items:center;justify-content:center;">
      <i data-lucide="zap" style="width:12px;height:12px;color:#fff;stroke-width:2.5;"></i>
    </div>
    <span style="font-family:var(--font-display);font-size:14px;font-weight:600;letter-spacing:-0.02em;">{App Name}</span>
  </div>
  <div class="sidebar-section-header" style="padding-top:4px;">主要功能</div>
  <div class="sidebar-item {active?}"><i data-lucide="home" class="nav-icon"></i>首页</div>
  <div class="sidebar-item {active?}"><i data-lucide="layout-grid" class="nav-icon"></i>工作台</div>
  <div class="sidebar-item {active?}"><i data-lucide="folder" class="nav-icon"></i>资源库</div>
  <div class="sidebar-item {active?}"><i data-lucide="bar-chart-3" class="nav-icon"></i>数据统计</div>
  <div class="sidebar-item {active?}"><i data-lucide="settings" class="nav-icon"></i>设置</div>
  <div class="sidebar-divider"></div>
  <div class="sidebar-section-header">收藏夹</div>
  <div class="sidebar-apps">
    <div class="sidebar-item"><span class="nav-icon" style="background:linear-gradient(135deg,#6366F1,#818cf8);color:#fff;font-size:9px;font-weight:700;display:inline-flex;align-items:center;justify-content:center;border-radius:3px;">A</span>项目 Alpha</div>
    <div class="sidebar-item"><span class="nav-icon" style="background:linear-gradient(135deg,#10B981,#34d399);color:#fff;font-size:9px;font-weight:700;display:inline-flex;align-items:center;justify-content:center;border-radius:3px;">B</span>项目 Beta</div>
    <div class="sidebar-item"><span class="nav-icon" style="background:linear-gradient(135deg,#F59E0B,#fbbf24);color:#fff;font-size:9px;font-weight:700;display:inline-flex;align-items:center;justify-content:center;border-radius:3px;">G</span>项目 Gamma</div>
  </div>
</div>
```

当前页对应的 sidebar-item 加 `class="sidebar-item active"`。
侧边栏分组名称（主要功能 / 收藏夹）和具体导航项请根据实际产品功能替换。

---

## win-chrome-bar 标准模板

```html
<div class="win-chrome-bar">
  <div class="win-chrome-drag"></div>
  <div class="win-chrome-actions">
    <button class="win-chrome-btn" title="帮助"><i data-lucide="help-circle" class="win-chrome-icon"></i></button>
    <div class="win-credits"><i data-lucide="coins" class="win-chrome-icon"></i><span>1,000 积分</span></div>
    <div class="win-avatar-chip"><span class="win-avatar">U</span><span class="badge-free">FREE</span></div>
    <button class="win-chrome-btn" title="菜单"><i data-lucide="menu" class="win-chrome-icon"></i></button>
  </div>
</div>
```

---

## 弹窗叠加态结构

弹窗 section 使用 `position:relative` 的 `macos-body`，在其内加遮罩 + 弹窗：

```html
<div class="macos-body" style="position:relative;">
  <!-- 正常 sidebar + chrome-bar + app-main（主区内容灰暗，pointer-events:none） -->
  <div class="app-main" style="pointer-events:none;filter:brightness(0.97);">
    <!-- 主区内容原样保留 -->
  </div>
  <!-- 遮罩 -->
  <div style="position:absolute;inset:0;background:rgba(0,0,0,0.25);z-index:10;"></div>
  <!-- 弹窗 -->
  <div style="position:absolute;inset:0;display:flex;align-items:center;justify-content:center;z-index:11;">
    <div class="form-dialog">
      <button class="modal-close-x"><i data-lucide="x"></i></button>
      <div class="form-dialog-title">弹窗标题</div>
      <!-- 表单内容 -->
    </div>
  </div>
</div>
```

---

## 抽屉叠加态结构

```html
<div class="macos-body" style="position:relative;">
  <!-- 主区正常内容（被查看行加高亮背景） -->
  <!-- 遮罩 -->
  <div style="position:absolute;inset:0;background:rgba(0,0,0,0.25);z-index:10;"></div>
  <!-- 右侧抽屉 -->
  <div style="position:absolute;top:0;right:0;bottom:0;width:320px;background:var(--surface);border-left:1px solid var(--border);z-index:11;display:flex;flex-direction:column;">
    <div style="display:flex;align-items:center;justify-content:space-between;padding:14px 18px;border-bottom:1px solid var(--border);">
      <span style="font-weight:600;font-size:13px;">抽屉标题</span>
      <button class="modal-close-x" style="position:static;"><i data-lucide="x"></i></button>
    </div>
    <div style="flex:1;overflow-y:auto;padding:16px 18px;">
      <!-- 抽屉内容 -->
    </div>
  </div>
</div>
```

---

## 叠加态决策：modal / drawer / subpage 怎么选

| 形态 | 何时用 | 容器类 |
|------|------|------|
| **modal 弹窗** | 确认 / 短表单（≤3 字段） / destructive confirm | `.form-dialog` + 居中遮罩 |
| **drawer 抽屉** | 详情查看 / 列表筛选 / 队列任务列表 | 右侧 320px 抽屉 + 遮罩 |
| **subpage 子页** | 长表单（≥4 字段） / 多 tab 配置 / 创建&编辑场景 | `.channel-subpage` 替换整个 `app-main` |

判断要点：
- 字段一多，modal 会顶到视口边缘 → 走 subpage
- 不需要保留对底层主区的视觉参照 → 走 subpage（不需要遮罩）
- 用户操作意图是"切换到另一个工作面"而非"在当前页弹一个东西" → 走 subpage

---

## 子页（subpage）结构

子页**整体替换 `app-main` 内容**，不走遮罩、不悬浮——和 modal/drawer 的区别在于它本身就是新页面。适合创建 / 编辑等长表单场景。

```html
<div class="app-main">
  <div class="channel-subpage">
    <div class="channel-subpage__head">
      <div>
        <div class="section-title">子页标题</div>
        <div class="section-desc" style="margin-bottom:0;">副标题说明</div>
      </div>
      <button class="subpage-close-x" aria-label="取消">
        <i data-lucide="x"></i>
      </button>
    </div>

    <!-- 表单字段 form-group * N -->
    <div class="form-group">
      <label class="form-label">字段名</label>
      <input class="form-input" />
    </div>

    <!-- 底部按钮 -->
    <div class="form-actions">
      <button class="btn btn-ghost btn-sm">取消</button>
      <button class="btn btn-primary btn-sm">保存</button>
    </div>
  </div>
</div>
```

可选：head 右上角除 `subpage-close-x` 外可叠加一个辅助操作按钮（如「恢复到默认」）：

```html
<div style="display:flex;align-items:center;gap:8px;flex-shrink:0;">
  <button class="btn btn-ghost btn-sm">
    <i data-lucide="rotate-ccw" style="width:12px;height:12px;margin-right:4px;"></i>恢复到默认
  </button>
  <button class="subpage-close-x"><i data-lucide="x"></i></button>
</div>
```

要点：

- `subpage-close-x` 等效底部「取消」按钮
- 进入路径：通常由列表页主按钮触发（如「+ 添加 X」），或卡片 hover 操作中的「编辑」图标触发
- 子页与底层列表页**互斥呈现**——不像 modal/drawer 那样保留底层视觉

---

## nav-icon 规范

`nav-icon` 统一 `width:16px;height:16px;flex-shrink:0`。
- Lucide 图标：`<i data-lucide="xxx" class="nav-icon"></i>`
- lobehub 彩色 SVG（如需展示具体品牌）：`<img class="nav-icon" src="https://unpkg.com/@lobehub/icons-static-svg@latest/icons/{name}.svg" alt="">`
- 首字母兜底块：`<span class="nav-icon" style="background:linear-gradient(135deg,#xxx,#yyy);color:#fff;font-size:9px;font-weight:700;display:inline-flex;align-items:center;justify-content:center;border-radius:3px;">X</span>`

常用 lobehub 图标名（按需引用真实品牌时使用）：`claude-color`、`openai`、`cursor`、`deepseek-color`、`gemini-color`、`github`
