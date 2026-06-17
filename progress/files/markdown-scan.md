# markdown_scan.mbt

## 文件职责

扫描 Markdown 和 `.mbt.md` 文档，统计 fenced code block、`mbt check`、`mbt nocheck` 和普通 MoonBit 示例，并检查 README 章节线索。

## 当前完成情况

- [x] 支持 fenced code block 统计。
- [x] 支持 `mbt check` 统计。
- [x] 支持 `mbt nocheck` 统计。
- [x] 支持普通 `moonbit` / `mbt` 代码块统计。
- [x] 支持 README 基础线索检查。

## 待完善

- [ ] 支持多个 Markdown 文件聚合。
- [ ] 增强 README 章节识别。

## 当前问题

- README 检查是启发式规则，只能作为建议。

