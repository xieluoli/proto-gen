# proto-gen

> 给 Claude Code 用的 skill — 根据自然语言描述/PRD 快速生成高保真 HTML 原型。

适合在产品 MVP 阶段做方案演示与评审：把脑子里的构思一键变成可在浏览器打开的、带页面索引和功能旁注的可视化原型。

![proto-gen 示例截图](assets/screenshots/example-home.png)

> 上图为 [`assets/example.html`](assets/example.html) 渲染效果，完整版（含弹窗叠加态）见 [`assets/screenshots/example-full.png`](assets/screenshots/example-full.png)。

## 这是什么

一套带[完整设计系统](assets/shared.css)的原型生成器。给一段需求描述（"做个任务管理页，列表 + 添加弹窗"），生成符合**三段结构契约**的 HTML：

- 左侧 **toc-sidebar**：全文件页面索引，滚动高亮
- 中间 **原型图**：macOS 窗口外壳（左侧栏 + 顶部工具栏 + 内容区），多 section 垂直堆叠（主页 / 弹窗 / 抽屉 / 子页 ...）
- 右侧 **功能概览**：每个 section 一个 PRD 面板，与原型图**一一对应**
- **PRD ↔ 原型 双向高亮**：hover 任一 PRD bullet → 自动高亮对应原型组件（反向亦然），评审时跨视图对照零成本

> 当前覆盖 **PC · macOS 系列**；Mobile 系列规划中（外壳容器与对应 reference 后续独立扩展）。
> 高亮联动（`data-comp` / `data-target` / `prd-highlight.js`）是**评审脚手架**——交付研发实现真实业务代码时应整套丢弃，剥离清单见 [`references/prd-highlight.md`](references/prd-highlight.md) 的「交付给研发时」段。

## 安装

把这个仓库 clone 到 Claude Code 的 skills 目录：

```bash
git clone git@github.com:xieluoli/proto-gen.git ~/.claude/skills/proto-gen
```

Claude Code 启动时会自动加载所有 `~/.claude/skills/*` 下的 skill。

## 使用

在 Claude Code 里说：

> "做一个会员中心的原型，包含个人信息页、订单列表、订单详情"

或者：

> "帮我生成 MCP 管理页面的原型，要有列表 + 添加弹窗 + 详情抽屉"

触发关键词（在你的指令里包含其中一个就行）：生成原型、新建原型、写原型、画原型、做个原型、新增一个 html、新建 html 原型。

第一次使用时，需要把 [`assets/shared.css`](assets/shared.css) 和 [`assets/prd-highlight.js`](assets/prd-highlight.js) 拷到你项目的原型目录下，所有生成的 HTML 通过相对路径引用：

```bash
mkdir -p your-project/prototypes
cp ~/.claude/skills/proto-gen/assets/shared.css your-project/prototypes/
cp ~/.claude/skills/proto-gen/assets/prd-highlight.js your-project/prototypes/
```

之后告诉 Claude "把生成的 HTML 放到 `your-project/prototypes/` 下" 即可。

## 目录结构

```
proto-gen/
├── SKILL.md                       skill 入口（Claude Code 加载）
├── assets/
│   ├── shared.css                 完整设计系统（颜色/字体/组件/PRD 面板/高亮规则）
│   ├── prd-highlight.js           PRD ↔ 原型 双向 hover 联动运行时
│   └── example.html               独立可运行示例
├── references/
│   ├── html-structure.md          HTML 骨架 + modal/drawer/subpage 三态决策（PC·macOS）
│   ├── css-components.md          CSS 组件速查 + 视觉食谱（PC·macOS）
│   ├── prd-rules.md               PRD bullets 写法 + 条件分支/重复引用规则（设备无关）
│   └── prd-highlight.md           data-comp / data-target 命名约定 + 易踩坑（设备无关）
└── evals/
    └── evals.json                 测试用例（可选）
```

## 设计系统速览

`shared.css` 自带的关键 token：

| 类别 | 值 |
|------|------|
| 主色 | `--primary: #6366F1` (indigo) |
| 字体 | `General Sans`（标题）/ `DM Sans`（正文）/ `JetBrains Mono`（代码） |
| 圆角 | chip 4px / button 6px / panel 8px / card 12px / full 9999px |
| 色板 | success / warning / error 三色 + 三档文字灰 |

组件完整清单见 [`references/css-components.md`](references/css-components.md)。

## 它解决了什么问题

**没有它时：** 每次想用 HTML 原型沟通方案，要么写得太糙（vanilla style 没说服力），要么写得太精致（一个页面一两小时）。

**有了它：** 把"画 UI"这件事从手工变成 prompt——花在思考产品逻辑的时间，远多于在写 HTML 上。生成出来的原型可以直接给 PM/设计/老板看，不会因为视觉粗糙拉低方案的说服力。

## License

MIT
