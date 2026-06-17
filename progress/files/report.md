# report.mbt / render_text.mbt

## 文件职责

`report.mbt` 负责把扫描结果汇总为 `ProjectReport`。`render_text.mbt` 负责把报告渲染为终端可读文本。

## 当前完成情况

- [x] 支持从 API 扫描结果生成最小报告。
- [x] 支持文档覆盖率计算。
- [x] 支持缺失文档 issue。
- [x] 支持终端文本报告。
- [x] 终端报告最多展示前 20 条 issue，避免输出被大量问题淹没。

## 待完善

- [ ] 聚合 README、Markdown、moon.mod、CI 扫描结果。
- [ ] 实现 Markdown 报告。
- [ ] 实现 JSON 报告。

## 当前问题

- 当前报告还是源码扫描优先的最小版本。
