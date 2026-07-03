#!/usr/bin/env node
/**
 * proto-gen 资产注入脚本 —— 自包含原型的样式单源刷新
 *
 * 原型 HTML 里用一对 HTML 标记注释包住注入块（放在 <head> 内）：
 *
 *   <!-- @proto-gen:theme:start -->
 *   <style> ...theme.css 注入内容... </style>
 *   <!-- @proto-gen:theme:end -->
 *
 * 支持三个块（按需使用，theme 必备）：
 *   theme     → assets/theme.css        （主题 token，注入为 <style>）
 *   shared    → assets/shared.css       （通用组件类骨架，注入为 <style>）
 *   highlight → assets/prd-highlight.js （PRD↔原型 hover 联动，注入为 <script>）
 *
 * 用法（可混填文件与目录，目录递归收集 *.html）：
 *   ./inject-assets.mjs path/to/proto.html
 *   ./inject-assets.mjs prototypes/*.html
 *   ./inject-assets.mjs path/to/prototypes-dir/          # 批量刷新整目录
 *
 * 行为：
 *   - 只替换标记之间的内容，标记外的页面自有样式一律不碰
 *   - 幂等：重复执行结果一致
 *   - 无任何标记的 HTML 跳过并提示；有 start 无 end 视为错误（exit 1）
 */

import { readFileSync, writeFileSync, readdirSync, statSync } from 'node:fs';
import { join, dirname, extname } from 'node:path';
import { fileURLToPath } from 'node:url';

const assetsDir = dirname(fileURLToPath(import.meta.url));

const BLOCKS = [
  { name: 'theme',     assetFile: 'theme.css',        tag: 'style'  },
  { name: 'shared',    assetFile: 'shared.css',       tag: 'style'  },
  { name: 'highlight', assetFile: 'prd-highlight.js', tag: 'script' },
];

function collectHtmlFiles(inputPaths) {
  const htmlFiles = [];
  const walk = (currentPath) => {
    const stats = statSync(currentPath);
    if (stats.isDirectory()) {
      for (const entry of readdirSync(currentPath)) {
        if (entry.startsWith('.')) continue;
        walk(join(currentPath, entry));
      }
    } else if (extname(currentPath).toLowerCase() === '.html') {
      htmlFiles.push(currentPath);
    }
  };
  for (const inputPath of inputPaths) walk(inputPath);
  return htmlFiles;
}

function injectOneFile(htmlPath) {
  let html = readFileSync(htmlPath, 'utf8');
  const refreshedBlocks = [];
  let hasBrokenBlock = false;

  for (const block of BLOCKS) {
    const startMarker = `<!-- @proto-gen:${block.name}:start -->`;
    const endMarker = `<!-- @proto-gen:${block.name}:end -->`;

    const startIndex = html.indexOf(startMarker);
    if (startIndex === -1) continue;

    const endIndex = html.indexOf(endMarker, startIndex + startMarker.length);
    if (endIndex === -1) {
      console.error(`✗ ${htmlPath}: 找到 ${startMarker} 但缺少 ${endMarker}，跳过该块`);
      process.exitCode = 1;
      hasBrokenBlock = true;
      continue;
    }
    if (html.indexOf(startMarker, startIndex + startMarker.length) !== -1) {
      console.error(`✗ ${htmlPath}: ${startMarker} 出现多次，仅允许一处，跳过该块`);
      process.exitCode = 1;
      hasBrokenBlock = true;
      continue;
    }

    const assetContent = readFileSync(join(assetsDir, block.assetFile), 'utf8');
    const injected = `\n<${block.tag}>\n${assetContent.replace(/\s*$/, '')}\n</${block.tag}>\n`;
    html = html.slice(0, startIndex + startMarker.length) + injected + html.slice(endIndex);
    refreshedBlocks.push(block.name);
  }

  if (refreshedBlocks.length > 0) {
    writeFileSync(htmlPath, html);
    console.log(`✓ ${htmlPath} — 已刷新 [${refreshedBlocks.join(', ')}]`);
  } else if (!hasBrokenBlock) {
    console.log(`- ${htmlPath} — 无 @proto-gen 标记，跳过`);
  }
}

const inputPaths = process.argv.slice(2);
if (inputPaths.length === 0) {
  console.error('用法: inject-assets.mjs <html文件或目录> [...]');
  process.exit(1);
}

const htmlFiles = collectHtmlFiles(inputPaths);
if (htmlFiles.length === 0) {
  console.error('未找到任何 .html 文件');
  process.exit(1);
}
for (const htmlFile of htmlFiles) injectOneFile(htmlFile);
