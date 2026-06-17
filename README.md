# MoonDocCheck

MoonDocCheck 是一个面向 MoonBit 项目的文档质量检查与报告工具。它会扫描 MoonBit 仓库中的源码、README、`moon.mod`、生成的接口摘要和 CI 配置，帮助维护者快速了解项目是否具备一个可发布、可审核、可维护的开源包所需要的文档与工程化信号。

本项目计划参加 MoonBit 开源生态建设比赛，当前处于立项与早期开发阶段。

## 项目目标

MoonBit 已经提供了文档注释、`README.mbt.md` 可检查示例、`moon info` 生成接口摘要、`moon ide doc` 查询 API 等官方能力。MoonDocCheck 不替代这些官方工具，而是围绕它们提供一个轻量的项目健康检查入口：

- 检查公开 API 是否有文档注释。
- 检查 README 是否包含基本使用说明。
- 统计文档中可被 MoonBit 工具链检查的 `mbt check` 示例。
- 检查 `moon.mod` 元数据是否完整。
- 检查项目是否生成 `pkg.generated.mbti`。
- 检查 GitHub Actions 是否运行 `moon check` 和 `moon test`。
- 输出终端、Markdown 和 JSON 格式的文档质量报告。

## 预期使用方式

初版计划提供命令行工具：

```bash
moon run cmd/main -- scan .
moon run cmd/main -- scan . --format markdown --output DOC_REPORT.md
moon run cmd/main -- scan . --format json --output doc-report.json
```

示例输出：

```text
MoonDocCheck Report

Public API documentation:
  Total: 31
  Documented: 23
  Missing: 8
  Coverage: 74%

README:
  Found: yes
  Has overview: yes
  Has usage: yes
  Has code example: yes

Examples:
  mbt check blocks: 4
  ordinary MoonBit blocks: 3

CI:
  GitHub Actions: found
  moon check: yes
  moon test: yes
```

## 初版功能范围

计划在初审前完成一个可实际运行的强雏形：

- 递归扫描 MoonBit 项目目录。
- 识别 `.mbt` 文件中的常见公开声明：
  - `pub fn`
  - `pub struct`
  - `pub enum`
  - `pub type`
  - `pub trait`
  - `pub suberror`
  - `pub(all) struct`
  - `pub(all) enum`
- 判断公开 API 上方是否有 `///` 文档注释。
- 检测 `TODO`、`FIXME`、过短注释等弱文档信号。
- 检查 `README.md` / `README.mbt.md` 是否存在。
- 统计 Markdown 中的 `mbt check`、`mbt nocheck` 和普通 MoonBit 代码块。
- 检查 `moon.mod` 中的 name、version、license、repository、description、keywords 等元数据。
- 检查 `pkg.generated.mbti` 是否存在。
- 检查 GitHub Actions 中是否包含 `moon check` 和 `moon test`。
- 输出终端报告和 Markdown 报告。
- 提供示例项目和测试用例。

## 非目标

初版不会做这些事情：

- 不实现完整 MoonBit 语法解析器。
- 不替代 MoonBit 官方文档系统。
- 不做跨包语义分析。
- 不自动重写用户源码。
- 不对 README 自然语言内容做复杂语义判断。

## 项目计划

详细计划见：

- [docs/moon-doc-check-plan.md](docs/moon-doc-check-plan.md)

## 开发状态

当前状态：

- [x] 完成项目方向设计
- [x] 完成初版计划文档
- [ ] 初始化 MoonBit 工程
- [ ] 实现核心扫描器
- [ ] 实现报告输出
- [ ] 添加示例项目
- [ ] 添加测试和 CI

## 许可证

本项目计划使用 MIT License。

