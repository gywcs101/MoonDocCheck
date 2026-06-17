# .github/workflows/ci.yml

## 文件职责

GitHub Actions CI 配置，负责在远程仓库中自动安装 MoonBit、运行检查、测试和示例扫描。

## 当前完成情况

- [x] 已创建 CI workflow。
- [x] 包含 MoonBit 安装步骤。
- [x] 包含 `moon version --all`。
- [x] 包含 `moon update`。
- [x] 包含 `moon check`。
- [x] 包含 `moon test`。
- [x] 包含示例扫描命令。

## 待完善

- [ ] GitHub 仓库创建后验证真实 Actions 运行结果。
- [ ] 后续加入 `moon fmt` 或 `moon info` 检查。

## 当前问题

- 本地无法验证 GitHub Actions 云端环境，只能验证命令本身。

