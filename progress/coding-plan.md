# 初审前具体编码计划

## 原则

- 优先做能运行、能展示、能测试的强雏形。
- 默认只读扫描，不修改用户仓库。
- 文档判断标准尽量依据 MoonBit 官方文档和当前工具链能力。
- 遇到 MoonBit API、配置格式、文档机制不确定时，优先查官方文档或使用 `moon ide doc` / `moon` 命令验证。
- 每完成阶段性修改，同步更新 `progress/`。

## 阶段 1：工程骨架

目标：仓库变成可检查的 MoonBit 项目。

任务：

- 创建 `moon.mod`
- 创建根 `moon.pkg`
- 创建基础库文件：`types.mbt`、`api.mbt`
- 创建 CLI 目录：`cmd/main`
- 创建 `LICENSE`
- 准备 `AGENTS.md`

验收：

- `moon check` 可以运行。
- `moon test` 可以运行。
- `moon run cmd/main` 可以输出基础 help 或版本信息。

## 阶段 2：核心源码扫描

目标：能扫描 `.mbt` 文本并提取公开 API。

任务：

- 实现文件类型识别。
- 实现 `.mbt` 行级扫描。
- 识别 `pub fn`、`pub struct`、`pub enum`、`pub type`、`pub trait`、`pub suberror`、`pub(all)`、`declare pub`。
- 匹配声明前的 `///` 文档注释。
- 识别缺失文档和弱文档。

验收：

- 能对示例 `.mbt` 输出公开 API 数、已注释数、缺注释列表。
- 有针对扫描器的测试。

## 阶段 3：项目级扫描

目标：能递归扫描一个 MoonBit 仓库。

任务：

- 实现路径过滤。
- 忽略 `.git`、`.moon`、`.repos`、`target`、`build`、`.analysis_*`。
- 识别 README、`.mbt.md`、`moon.mod`、`pkg.generated.mbti`、GitHub Actions。
- 汇总项目级统计。

验收：

- 能扫描 `examples/good_project` 和 `examples/missing_docs`。

## 阶段 4：文档与元数据检查

目标：补齐 README、Markdown 示例、`moon.mod`、CI 检查。

任务：

- 检查 README 是否存在。
- 检查 README 是否包含简介、使用、示例、开发命令、许可证线索。
- 统计 fenced code block、`mbt check`、`mbt nocheck`、普通 MoonBit 代码块。
- 检查 `moon.mod` 字段。
- 检查 `pkg.generated.mbti` 是否存在。
- 检查 workflow 中是否有 `moon check` 和 `moon test`。

验收：

- 报告包含 README、示例、元数据、CI 状态。

## 阶段 5：报告输出

目标：让使用者一眼看懂扫描结果。

任务：

- 实现终端文本报告。
- 实现 Markdown 报告。
- 可选实现 JSON 报告。
- CLI 支持 `--format` 和 `--output`。

验收：

- `moon run cmd/main -- scan examples/good_project`
- `moon run cmd/main -- scan examples/missing_docs --format markdown --output DOC_REPORT.md`

## 阶段 6：测试、示例、CI

目标：达到初审可提交状态。

任务：

- 添加至少 12 个有意义测试。
- 添加多个示例项目。
- 配置 GitHub Actions。
- 更新 README 和计划文档。
- 运行 `moon check`、`moon test`、`moon info`。

验收：

- 本地检查通过。
- README 能说明项目价值和使用方式。
- 仓库结构接近可提交状态。

