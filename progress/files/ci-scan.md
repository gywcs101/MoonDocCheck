# ci_scan.mbt

## 文件职责

扫描 GitHub Actions workflow 文本，检测 MoonBit 验证命令。

## 当前完成情况

- [x] 支持 `moon check` 检测。
- [x] 支持 `moon test` 检测。
- [x] 支持 `moon fmt`、`moon info`、`moon run` 检测。

## 待完善

- [ ] 支持多个 workflow 文件聚合。
- [ ] 区分 push、pull_request、workflow_dispatch 等触发器。

## 当前问题

- 当前只做文本包含检测。

