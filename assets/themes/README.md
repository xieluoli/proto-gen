# proto-gen 主题

同结构、可互换的主题变体（token 名一致，`var()` 直接可用）。原型/UI 引用其中一个即可。

| 主题 | 文件 | 主色 | 基调 | 用于 |
|---|---|---|---|---|
| **violet**（默认） | `../theme.css` | 紫 `oklch(0.55 0.25 273)` | 桌面工具 App 观感、大圆角(1.3rem)、Google Sans Flex | 工具 / 管理类应用 |
| **orange** | `orange.css` | 橙 `#f97316`(hsl 24 95% 53%) | 浅色营销风、hairline·无阴影·小圆角(0.625rem)、Mulish | 官网 / 落地页 / 浏览器插件 |

## 用法

- **默认（violet）**：`inject-assets.mjs` 注入的就是 `../theme.css`，无需额外操作。
- **橙色**：原型 `<head>` 内联或引用 `themes/orange.css` 替代默认 theme.css（token 名相同，组件 CSS 不用改）。

## 新增主题

```sh
# 从 tweakcn 生成核心 19 token（需 jq）
../extract-theme.sh <tweakcn-id> themes/<name>.css
# 再手工补：sidebar 子 token(8) + 状态色派生(success/warning/info) + 确认字体 + radius 阶梯适配
```

主题值若源自某个已上线站点的 `globals.css`，改值时两处保持同源，避免原型与线上漂移。
</content>
