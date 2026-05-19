# proto-gen

> 给 Claude Code 用的 skill — 根据自然语言描述/PRD 快速生成高保真 HTML 原型。

适合在产品 MVP 阶段做方案演示与评审：把脑子里的构思一键变成可在浏览器打开的、带页面索引和功能旁注的可视化原型。

## 这是什么

一套带[完整设计系统](assets/shared.css)的原型生成器。给一段需求描述（"做个任务管理页，列表 + 添加弹窗"），生成一个：

- macOS 窗口风格（左侧栏 + 顶部工具栏 + 内容区）
- 多个 section 垂直堆叠（主页 / 弹窗 / 抽屉 ...）
- 每个 section 旁边带 **PRD 旁注面板**（功能概览，跟 UI 一一对应）
- 顶部带页面索引（toc-sidebar）滚动高亮

效果可以打开 [`assets/example.html`](assets/example.html) 直接看。

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

第一次使用时，需要把 [`assets/shared.css`](assets/shared.css) 拷到你项目的原型目录下，所有生成的 HTML 通过相对路径 `href="shared.css"` 引用：

```bash
mkdir -p your-project/prototypes
cp ~/.claude/skills/proto-gen/assets/shared.css your-project/prototypes/
```

之后告诉 Claude "把生成的 HTML 放到 `your-project/prototypes/` 下" 即可。

## 目录结构

```
proto-gen/
├── SKILL.md                       skill 入口（Claude Code 加载）
├── assets/
│   ├── shared.css                 完整设计系统（颜色/字体/组件/PRD 面板）
│   └── example.html               独立可运行示例
├── references/
│   ├── html-structure.md          HTML 骨架模板（含 sidebar / chrome-bar / 弹窗 / 抽屉）
│   ├── css-components.md          CSS 组件速查（按钮/输入/卡片/Badge/Tabs/Toggle/弹窗）
│   └── prd-rules.md               PRD bullets 写作规范 + 重复内容引用规则
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
