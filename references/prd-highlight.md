# prd-highlight：PRD ↔ 原型 双向高亮联动

> 适用范围：设备无关（PC · macOS 系列 / 后续 Mobile 系列均可用）
> 关联资产：`assets/shared.css`（样式）+ `assets/prd-highlight.js`（运行时）

## 这是什么

在每个原型 section 内，**hover 任一条 PRD bullet → 自动高亮对应原型组件**；反向同样成立（hover 原型组件 → 高亮对应 bullet）。用于评审时快速跨视图对照。

视觉表现：`var(--primary)` 主色描边（默认 724-1 紫，跟随主题）+ 外发光，与组件自身 `:hover` 状态（通常是 background 变化）**完全分离的视觉键**——不互相覆盖、不混淆。

## 接入步骤

1. **HTML head**：保持原有 `<link rel="stylesheet" href="shared.css" />` 即可，高亮样式已在 `shared.css` 末尾
2. **HTML head 加一行**：`<script src="prd-highlight.js" defer></script>`
3. **首次使用**：把 `prd-highlight.js` 拷到原型目录（与 `shared.css` 同级）

```bash
cp ~/.claude/skills/proto-gen/assets/prd-highlight.js your-project/prototypes/
```

## 标注约定

### 命名约定

- **组件上**：加 `data-comp="<key>"`
- **bullet 上**：加 `data-target="<key>"`
- **多对一**：`data-target="key1,key2"`（hover 该 bullet 同时高亮多个组件）
- **多 bullet 对同一组件**：多条 bullet 各自写 `data-target="<同一 key>"`（如「默认渠道」和「非默认渠道」两条 bullet 都指向 `channel-act-delete`）

### Key 唯一性范围

**Key 只在当前 section 内唯一**，跨 section 可以重名——因为 scope 限定在 `.proto-with-prd` 块内（一个 section 一个块），跨 section 不传染。

例：6 个 section 都可以用 `data-comp="channel-card"`，互不干扰。

### Key 命名建议

| 类型 | 命名风格 | 例 |
|---|---|---|
| 主功能区块 | 业务名 | `channel-card` / `quota-panel` |
| 操作按钮 | `btn-<动词>` | `btn-add-channel` / `btn-confirm` |
| 字段 | `field-<名>` | `field-base-url` / `field-api-key` |
| 状态标识 | `badge-<语义>` | `badge-default` / `badge-warn` |
| 子操作 | `<父>-<动词>` | `channel-act-delete` / `channel-act-apply` |

## 状态命名分层（业务态 vs 评审态）

原型里出现的「状态类」分两层，**命名风格刻意区分，便于一眼判断哪些交付时要剥离**：

| 层 | 命名约定 | 例 | 交付研发时 |
|---|---|---|---|
| **业务态**（用户实际可触发） | BEM `--<state>` 修饰符 / `.active` / `.expanded` 等业务语义 | `agent-tab--active` / `inline-tab.active` / `model-badges.expanded` / `btn--disabled` | **保留**（研发原样译为 React state / Vue class） |
| **评审脚手架**（PRD ↔ 原型 对照） | **`.is-*` 命名空间**专用 | `.is-highlight` / `.is-bullet-active` | **整段丢弃**（grep `.is-*` 一行 sed 清完） |

为什么要分层：

- 业务态是**产品事实**——交付后还在，研发必须实现
- 评审态是**评审工具**——只在原型评审期间有意义，进生产代码就是噪音
- 写新状态时先问自己：「这个状态用户真的能触发吗？」是 → BEM `--`；只是 PRD 标注 → `.is-*`

视觉键也要刻意区分：

| 状态 | 视觉键 | 用途 |
|---|---|---|
| 组件自身 `:hover` | background 变化 / 操作浮层显形 | 用户与组件直接交互 |
| 业务态 BEM `--active` 等 | background / 描边 / 加粗 / icon 切换（按场景） | 表达产品状态 |
| **评审态 `.is-highlight`** | **outline + 外发光** | PRD ↔ 原型 跨视图对照 |
| 评审态 `.is-bullet-active` | inset 浅 primary 边框（跟随主题） | bullet hover 时给所属卡片加视觉锚（解决"组件太小/在角落难发现"） |

不要把 `.is-highlight` 改成 background 变化——会与 `:hover` / 业务态互相覆盖、互相干扰。**`.is-*` 命名空间专属评审脚手架**，业务态绝不用 `is-` 前缀，否则 grep 自检会误伤。

## 易踩坑

1. **不要在 `.is-highlight` 上加 `position: relative` / `z-index`**——会把原本 `position: absolute` 的组件（如 `.channel-actions`）拽回文档流造成偏移。`outline` + `box-shadow` 本身不占空间也不需要 stacking context。
2. **强制显示隐藏组件**（如 `.channel-actions` 默认 `display: none`）必须用 `display: flex` 覆盖，**不能用 `opacity`**。
3. **反向高亮（组件 → bullet）必须 `stopPropagation`**——否则父组件 mouseenter 会遮盖子组件的高亮。
4. **scope 必须是 `.proto-with-prd`**——直接全局 querySelector 会跨 section 把所有同名 key 都高亮。

## 标注覆盖率建议

- **完整标注**：每条 bullet 都尽量标 `data-target`，未对应任何组件的 bullet 留空（如纯描述性 bullet「内容来源：后端下发」）
- **不必为每个像素标注**：纯装饰性 div（间距、分隔线）不需要标
- **嵌套粒度**：父组件和子组件都可以各自标 `data-comp`，反向高亮时子组件优先（`stopPropagation` 保障）

## 与其他 references 的分工

- [[html-structure]]：讲页面骨架（toc + macos-window + prd-panel），不涉及 hover 联动
- [[prd-rules]]：讲 bullet 文案怎么写、条件分支怎么表达
- **本文件**：讲 bullet 与组件**怎么绑定**（机械层）

## 交付给研发时（重要）

`data-comp` / `data-target` / `prd-highlight.js` / `shared.css` 末尾 4 条高亮规则都是**评审脚手架**（PRD ↔ 原型 对照工具），**不属于业务逻辑**。研发把原型 HTML 转 React / Vue / Tauri / 原生组件时，**这些资产应全部丢弃**，不要照搬到生产代码里。

### 研发应丢弃的清单

| 类别 | 字面识别 | 处理 |
|---|---|---|
| HTML 属性 | `data-comp="..."` | 全部删除 |
| HTML 属性 | `data-target="..."` | 全部删除 |
| HTML script 引用 | `<script src="prd-highlight.js"` 那一行 | 整行删除 |
| 文件 | `prd-highlight.js` | 不要拷到工程 |
| CSS | `shared.css` 末尾「PRD ↔ 原型 双向高亮联动」段（4 条规则） | 复用 shared.css 时整段删 |

### 一行 grep 自检（在原型目录跑）

```bash
# 输出应为空（输出说明研发版还有评审脚手架残留）
grep -nE "data-(comp|target)|prd-highlight|is-highlight|is-bullet-active" your-prod-code/
```

### 写在交付物的醒目位置

把原型 HTML 交付给研发 / 研发 Agent 时，建议在邮件 / PR 描述 / README 顶部注明：

> 本原型含 `data-comp` / `data-target` 属性、`prd-highlight.js`、`shared.css` 末尾高亮规则——全部是评审脚手架，**研发实现时请整套丢弃**，不要进入生产代码。
