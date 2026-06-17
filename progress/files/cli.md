# cmd/main

## 文件职责

命令行入口目录，负责解析命令、调用库 API，并把报告输出到终端或文件。

## 当前完成情况

- [x] 已创建 `cmd/main/moon.pkg`。
- [x] 已创建 `cmd/main/main.mbt`。
- [x] 当前 CLI 可输出项目名称、版本和基础 usage。

## 待完善

- [x] 接入 `@env.args()` 解析命令行参数。
- [x] 接入项目扫描。
- [x] 支持 `scan <path>`。
- [x] 支持 `--format text|markdown`。
- [x] 支持 `--output` 写入报告文件。

## 当前问题

- 当前仅支持 `text` 和 `markdown` 输出，JSON 尚未实现。
