# types.mbt

## 文件职责

定义 MoonDocCheck 的核心公开数据结构，包括 API 条目、问题、严重程度、README 统计、Markdown 统计、moon.mod 统计、CI 统计和完整项目报告。

## 当前完成情况

- [x] 已定义 `Severity`。
- [x] 已定义 `ApiItem`。
- [x] 已定义 `DocIssue`。
- [x] 已定义 `MarkdownStats`。
- [x] 已定义 `ReadmeStats`。
- [x] 已定义 `MoonModStats`。
- [x] 已定义 `CiStats`。
- [x] 已定义 `ProjectReport`。

## 待完善

- [ ] 根据后续扫描器需求补充字段。
- [ ] 运行 `moon info` 后检查公开 API 是否合理。

## 当前问题

- 需要验证 `derive(ToJson)` 在当前结构上是否全部可用。

