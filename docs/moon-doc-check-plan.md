# MoonDocCheck 项目计划

## 1. 项目定位

MoonDocCheck 是一个面向 MoonBit 项目的文档质量检查与报告工具。它扫描一个 MoonBit 仓库，检查项目是否具备一个可维护开源包应有的文档、示例、元数据、测试和 CI 信号，并生成清晰的报告。

本项目不替代 MoonBit 官方文档工具。它更像一个轻量级项目健康检查助手，帮助 MoonBit 包作者在发布到 mooncakes.io、参加开源比赛或交付项目之前，快速发现文档和工程化准备上的缺口。

核心价值：

- 帮助 MoonBit 包作者发现缺少文档注释的公开 API。
- 帮助维护者判断 README 和示例是否足够清晰。
- 帮助比赛参赛者准备更容易通过审核的仓库。
- 同时提供给人阅读的报告和给 CI 使用的机器可读报告。

## 2. 目标用户

主要用户：

- 准备发布 MoonBit 开源包的开发者。
- 准备比赛提交材料的参赛者。
- 审查仓库是否达到公开维护标准的维护者。

次要用户：

- 需要在交付前执行结构化检查的 AI 编程助手。
- 希望在 CI 中检查文档质量的 MoonBit 项目。

## 3. 产品形态

MoonDocCheck 应该同时是一个 MoonBit 库和一个命令行工具。

初版命令行用法：

```bash
moon run cmd/main -- scan .
moon run cmd/main -- scan . --format text
moon run cmd/main -- scan . --format markdown --output DOC_REPORT.md
moon run cmd/main -- scan . --format json --output doc-report.json
```

初版行为：

- 默认只读，不修改用户仓库。
- 默认不做交互，方便放进 CI。
- 适合本地终端使用，也适合自动化流程使用。
- 不传额外参数时，直接输出一份清晰的终端摘要。

退出码规划：

- `0`：扫描完成，未发现阻塞级问题。
- `1`：扫描完成，但项目存在超过阈值的文档质量问题。
- `2`：工具运行失败，例如路径无效、文件不可读或内部错误。

初审前不加入自动修改功能。后续可以考虑 `fix` 模式，但只能做非常安全的生成类操作，例如生成报告文件或 README 章节模板。

## 4. 初审前目标

初审前版本不应只是一个最小 demo，而应该做成一个比较完整、可信的强雏形。目标是对标之前分析过的 FrontierLab 仓库：有可运行核心功能、有测试、有示例、有 CI、有 README、有许可证，并且边界清楚。

初审前目标版本：

```text
v0.1.0-submission
```

这个版本应该已经能实际扫描小型和中型 MoonBit 仓库，并给出有价值的文档质量反馈。

## 5. 初审前必须完成的功能

### 5.1 项目扫描器

工具需要递归扫描一个仓库目录，并识别这些文件：

- `.mbt`
- `.mbt.md`
- `README.md`
- `README.mbt.md`
- `moon.mod`
- `moon.pkg`
- `pkg.generated.mbti`
- `LICENSE`
- `.github/workflows/*.yml`
- `.github/workflows/*.yaml`

需要忽略常见的生成目录和无关目录：

- `.git`
- `.moon`
- `.repos`
- `target`
- `build`
- `.analysis_*`

### 5.2 MoonBit 源码文档检查

对于 `.mbt` 文件，工具需要识别常见公开 API 声明：

- `pub fn`
- `pub struct`
- `pub enum`
- `pub type`
- `pub trait`
- `pub suberror`
- `pub(all) enum`
- `pub(all) struct`
- `declare pub`

对于每一个公开 API，工具需要判断它附近是否有文档注释。

可接受的文档注释：

- 声明前连续的 `///` 注释行。
- `///|` 分块标记后，紧跟在声明前的 `///` 文档注释。

工具需要报告：

- 公开 API 总数。
- 已有文档注释的公开 API 数量。
- 缺少文档注释的公开 API 数量。
- 文档覆盖率百分比。
- 缺少文档的 API 列表，包含文件路径和行号。

### 5.3 弱文档检测

工具需要对疑似无效或低质量文档注释给出警告，例如：

- `TODO`
- `FIXME`
- `TBD`
- 过短的注释。
- 只重复符号名、没有实际说明的注释。

这类问题应作为 warning，而不是 hard failure。

### 5.4 README 检查

工具需要检测项目是否存在：

- `README.md`
- `README.mbt.md`

并检查 README 中是否大致包含：

- 项目简介。
- 安装或使用说明。
- 代码示例。
- 开发命令。
- 许可证说明。

这一部分可以是启发式检查。目标是辅助作者改进文档，而不是完美理解自然语言。

### 5.5 Markdown 示例检查

对于 `README.md`、`README.mbt.md` 和其他 `.mbt.md` 文件，工具需要统计：

- fenced code block 总数。
- `mbt check` 代码块数量。
- `mbt nocheck` 代码块数量。
- 普通 `moonbit` 或 `mbt` 代码块数量。

工具需要报告文档中有多少示例是可以被 MoonBit 工具链自动检查的。

### 5.6 MoonBit 元数据检查

对于 `moon.mod`，工具需要检查这些字段是否出现：

- `name`
- `version`
- `readme`
- `repository`
- `license`
- `keywords`
- `description`

缺失字段应作为 suggestion 或 warning。

### 5.7 接口摘要检查

工具需要检查仓库中是否存在至少一个 `pkg.generated.mbti` 文件。

如果存在：

- 报告项目已经生成公开接口摘要。
- 统计 `.mbti` 文件中的公开 API 行数，作为辅助信息。

如果不存在：

- 建议运行 `moon info`。

### 5.8 CI 检查

工具需要扫描 GitHub Actions workflow 文件，检测 CI 中是否提到了：

- `moon check`
- `moon test`
- `moon fmt`
- `moon info`
- `moon run`

初审前最低要求：

- 能检测 `.github/workflows/*.yml` 或 `.yaml` 是否存在。
- 能报告 `moon check` 和 `moon test` 是否存在。

### 5.9 报告输出

初审前版本至少应该支持：

- 终端文本报告。
- Markdown 报告文件。

如果时间允许，建议初审前也完成 JSON 报告。JSON 报告会让项目更像正式工具，也方便后续 CI 集成。

终端报告示例：

```text
MoonDocCheck Report

Project: example/project
Files scanned: 24
MoonBit source files: 10
Markdown files: 3

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
  Has development commands: no

Examples:
  mbt check blocks: 4
  ordinary MoonBit blocks: 3

Moon metadata:
  moon.mod: found
  license: MIT
  repository: found

CI:
  GitHub Actions: found
  moon check: yes
  moon test: yes

Top suggestions:
  1. Add documentation comments for 8 public APIs.
  2. Add development commands to README.
  3. Convert simple MoonBit examples to mbt check blocks.
```

### 5.10 示例项目

仓库中应包含几个小型 MoonBit 示例项目，用于演示工具效果：

- `examples/good_project`
- `examples/missing_docs`
- `examples/readme_gaps`

每个示例项目都应该足够小，但要足够真实，能展示报告效果。

### 5.11 测试

初审前应包含这些测试：

- 从 `.mbt` 文件提取公开 API。
- 匹配文档注释。
- 报告缺失文档。
- 检测 README 章节。
- 统计 Markdown 代码块。
- 检测 `moon.mod` 元数据。
- 渲染文本报告和 Markdown 报告。

目标：

- 初审前至少有 12 个有意义的测试。
- 报告渲染类测试可以使用 snapshot 风格。

### 5.12 CI

初审前仓库应包含 GitHub Actions。

CI 必须执行：

- 安装 MoonBit。
- 运行 `moon version --all`。
- 运行 `moon check`。
- 运行 `moon test`。
- 运行示例扫描命令。

## 6. 初审前仓库结构

推荐结构：

```text
moon-doc-check/
  moon.mod
  moon.pkg
  README.mbt.md
  README.md
  LICENSE
  AGENTS.md
  CHANGELOG.md

  types.mbt
  api.mbt
  config.mbt
  project_scan.mbt
  path_filter.mbt
  file_scan.mbt
  moon_source_scan.mbt
  markdown_scan.mbt
  moon_mod_scan.mbt
  mbti_scan.mbt
  ci_scan.mbt
  rules.mbt
  report.mbt
  render_text.mbt
  render_markdown.mbt
  render_json.mbt

  moon_source_scan_test.mbt
  markdown_scan_test.mbt
  moon_mod_scan_test.mbt
  report_test.mbt
  cli_snapshot_test.mbt

  cmd/
    main/
      moon.pkg
      main.mbt
      cli.mbt

  examples/
    good_project/
      moon.mod
      moon.pkg
      README.mbt.md
      LICENSE
      pkg.generated.mbti
      sample.mbt
      .github/
        workflows/
          ci.yml

    missing_docs/
      moon.mod
      moon.pkg
      README.md
      sample.mbt

    readme_gaps/
      moon.mod
      moon.pkg
      README.md
      sample.mbt

  docs/
    proposal.md
    report-format.md
    rule-design.md
    roadmap.md

  .github/
    workflows/
      ci.yml
```

## 7. 文件职责

### 根目录元数据与文档

`moon.mod`

- MoonBit 模块元数据。
- 包含项目名、版本、许可证、仓库地址、关键词、描述和 README 路径。

`moon.pkg`

- 根包配置。
- 让库包可以被测试和 CLI 包导入。

`README.mbt.md`

- 主要用户文档。
- 包含安装说明、CLI 示例、报告示例，以及适合被检查的 `mbt check` 示例。

`README.md`

- GitHub 展示用 README。
- 可以镜像或链接到 `README.mbt.md`。

`LICENSE`

- 开源许可证。
- 推荐 MIT 或 Apache-2.0。

`AGENTS.md`

- 给 AI agent 和协作者看的说明。
- 解释项目结构、MoonBit 命令和验证流程。

### 库核心文件

`types.mbt`

- 定义核心公开数据结构：
  - `ProjectReport`
  - `FileReport`
  - `ApiItem`
  - `DocComment`
  - `DocIssue`
  - `Severity`
  - `ReportFormat`

`api.mbt`

- 对外门面 API。
- 暴露简单入口，例如：
  - `scan_project`
  - `scan_files`
  - `render_report`

`config.mbt`

- 定义扫描配置：
  - 忽略目录。
  - 最低文档覆盖率。
  - 启用或关闭的检查项。
  - 默认输出格式。

`project_scan.mbt`

- 项目遍历与调度入口。
- 调用各类专项扫描器并汇总结果。

`path_filter.mbt`

- 处理忽略目录和文件包含规则。

`file_scan.mbt`

- 判断文件类型。
- 把文件分发给对应扫描器。

### 各类扫描器

`moon_source_scan.mbt`

- 扫描 `.mbt` 文件。
- 提取公开声明。
- 匹配文档注释。
- 检测弱文档和缺失文档。

`markdown_scan.mbt`

- 扫描 Markdown 和 `.mbt.md`。
- 统计 fenced code block。
- 检测 `mbt check`、`mbt nocheck` 和普通 MoonBit 示例。
- 检查 README 章节线索。

`moon_mod_scan.mbt`

- 解析足够的 `moon.mod` 信息。
- 检测关键元数据字段是否存在。

`mbti_scan.mbt`

- 检测生成的接口摘要文件。
- 从 `pkg.generated.mbti` 中提取简单公开 API 统计。

`ci_scan.mbt`

- 扫描 GitHub Actions workflow。
- 检测 MoonBit 验证命令。

### 规则与报告

`rules.mbt`

- 把原始扫描事实转成 issue 和 suggestion。
- 分配严重程度。

`report.mbt`

- 聚合统计数据。
- 计算文档覆盖率。
- 按严重程度和文件路径排序问题。

`render_text.mbt`

- 生成终端可读报告。

`render_markdown.mbt`

- 生成 `DOC_REPORT.md`。

`render_json.mbt`

- 生成机器可读 JSON。
- 初审前可选，但结项前应完成。

### CLI

`cmd/main/main.mbt`

- 程序入口。

`cmd/main/cli.mbt`

- 解析命令行参数。
- 调用库 API。
- 把报告输出到终端或文件。
- 处理退出码。

### 测试

`moon_source_scan_test.mbt`

- 测试 API 提取、文档匹配、弱文档检测和行号。

`markdown_scan_test.mbt`

- 测试 README 章节检测和代码块统计。

`moon_mod_scan_test.mbt`

- 测试元数据字段检测。

`report_test.mbt`

- 测试覆盖率计算和 issue 汇总。

`cli_snapshot_test.mbt`

- 测试报告渲染输出。

## 8. 初审前里程碑

### 里程碑 A：项目骨架

交付物：

- `moon.mod`
- `moon.pkg`
- `README.mbt.md`
- `LICENSE`
- `AGENTS.md`
- CI workflow
- 能打印 help 的空 CLI

验收标准：

- `moon check` 通过。
- `moon test` 通过，哪怕只有最初的 smoke tests。

### 里程碑 B：核心源码扫描器

交付物：

- `.mbt` 文件扫描器。
- 公开 API 提取。
- 文档注释匹配。
- 缺失文档报告。

验收标准：

- 能扫描 `examples/missing_docs`。
- 终端输出能列出缺少文档的 API，并包含文件和行号。

### 里程碑 C：项目级报告

交付物：

- 递归项目扫描。
- README 检测。
- `moon.mod` 元数据检测。
- 基础报告聚合。

验收标准：

- 能扫描 `examples/good_project`。
- 输出文件数量、公开 API 数、覆盖率、README 状态和元数据状态。

### 里程碑 D：Markdown 与 CI 检查

交付物：

- Markdown 代码块统计。
- `mbt check` 示例统计。
- GitHub Actions 检测。
- CI 中 `moon check` 和 `moon test` 检测。

验收标准：

- 报告中包含可检查示例数量和 CI 状态。

### 里程碑 E：报告输出与打磨

交付物：

- 文本报告。
- Markdown 报告。
- 可选 JSON 报告。
- README 使用示例。
- 至少 12 个有意义测试。
- 通过 `moon info` 生成 `pkg.generated.mbti`。

验收标准：

- `moon check` 通过。
- `moon test` 通过。
- `moon run cmd/main -- scan examples/good_project` 可运行。
- `moon run cmd/main -- scan examples/missing_docs --format markdown --output DOC_REPORT.md` 可运行。
- GitHub Actions 能运行检查和测试。

## 9. 初审前完成标准

初次提交审核前，仓库应具备：

- 清晰 README，说明项目用途、使用方式、示例、当前状态和非目标。
- 可运行 CLI。
- 可复用库 API。
- 多个真实感示例项目。
- 覆盖主要逻辑的测试。
- 运行 `moon check` 和 `moon test` 的 CI。
- MIT 或 Apache-2.0 许可证。
- 填写完整的 `moon.mod` 元数据。
- 通过 `moon info` 生成 `pkg.generated.mbti`。
- `docs/proposal.md` 中有一页项目申报书草稿。

初审前明确不做：

- 不做完整 MoonBit 解析器。
- 不做跨包语义分析。
- 不自动重写源码。
- 不试图完美理解 README 自然语言。
- 不保证普通展示代码块一定能编译；可检查示例交给 MoonBit 自己的 `moon check` / `moon test`。

## 10. 初审后路线

初审通过后，项目目标从强雏形升级为可靠发布候选版本。

### 10.1 更完整的配置能力

增加配置文件，例如：

```text
moon-doc-check.toml
```

可配置内容：

- 忽略路径。
- 最低文档覆盖率。
- 禁用某些规则。
- 覆盖默认严重程度。
- 默认输出格式。

### 10.2 JSON 输出完善

完善并文档化 JSON 输出，供 CI 和其他工具消费。

预期字段：

- 项目元数据。
- 文件统计。
- API 文档统计。
- README 检查结果。
- Markdown 示例检查结果。
- CI 检查结果。
- issues。
- suggestions。

### 10.3 CI 模式

增加：

```bash
moon run cmd/main -- check . --min-doc-coverage 80
```

行为：

- 当阈值不达标时，以退出码 `1` 失败。
- 输出简洁的 CI 友好报告。

### 10.4 更准确的 API 提取

增强支持：

- 多行函数声明。
- 声明前属性。
- `pub using`。
- 相关的公开 impl 场景。
- 多 package 扫描。
- 与生成的 `.mbti` 结果对照。

### 10.5 安全的 Fix 模式

增加保守的修复模式：

```bash
moon run cmd/main -- fix . --dry-run
moon run cmd/main -- fix . --add-report
moon run cmd/main -- fix . --add-readme-template
```

允许的修复：

- 生成 `DOC_REPORT.md`。
- 生成缺失 README 章节模板。
- 生成文档 TODO 清单。

禁止的修复：

- 未经明确确认自动改写 `.mbt` 公开 API 注释。
- 修改 MoonBit 源码行为。

### 10.6 HTML 报告

增加静态 HTML 报告，方便展示：

- 总览卡片。
- 问题列表。
- 文件级 API 文档覆盖率。
- README checklist。
- CI checklist。

这不是必需项，但能提升比赛展示效果。

### 10.7 更多示例

增加对真实或接近真实仓库的扫描示例：

- 小型库项目。
- CLI 项目。
- 多 package module。
- 含 `README.mbt.md` 示例的项目。

### 10.8 文档打磨

补充或完善：

- 规则参考。
- CLI 参考。
- 报告格式参考。
- 示例教程。
- 贡献指南。

### 10.9 mooncakes.io 发布

准备发布：

- 检查 package metadata。
- 运行 `moon info`。
- 运行 `moon fmt`。
- 运行 `moon check`。
- 运行 `moon test`。
- 发布到 mooncakes.io。
- 打 `v0.1.0` 或 `v0.2.0` tag。

## 11. 风险与控制

### 风险：和 MoonBit 官方文档工具重复

控制方式：

- 把项目定位成文档质量检查器，而不是官方文档生成器。
- 把 `moon info` 和 `README.mbt.md` 当作辅助检查对象，而不是替代对象。

### 风险：基于文本扫描，不是完整解析器

控制方式：

- 明确说明范围。
- 先支持常见 MoonBit 声明。
- 用 `.mbti` 作为可选对照。
- 把复杂语法支持列为后续工作。

### 风险：README 检查是启发式的

控制方式：

- 报告建议，而不是下绝对判断。
- 使用谨慎措辞，例如“可能缺少 usage section”，而不是“README 无效”。

### 风险：自动修复可能破坏用户文件

控制方式：

- 初审前不做自动修复。
- 后续 fix 模式默认 `--dry-run`。
- 除非用户明确要求，否则只生成辅助文件。

### 风险：项目显得太小

控制方式：

- 初审前就包含 CLI、库 API、报告、示例、测试、CI 和文档。
- 强调项目服务 MoonBit 开源可维护性和比赛仓库提交质量。

## 12. 申报书摘要建议

MoonDocCheck 是一个面向 MoonBit 项目和比赛仓库的文档质量检查工具。它扫描 `.mbt`、`.mbt.md`、README、`moon.mod`、生成的接口摘要和 GitHub Actions workflow，输出关于公开 API 文档覆盖率、README 完整度、可检查示例、元数据准备情况和 CI 信号的报告。项目帮助 MoonBit 开发者准备更容易发布、审查、维护和提交比赛的开源仓库。

