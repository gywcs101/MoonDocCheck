# project_scan.mbt

## 文件职责

递归扫描项目目录，读取各类文件，调用源码、Markdown、moon.mod、CI 扫描器，并汇总成 `ProjectReport`。

## 当前完成情况

- [x] 支持目录递归。
- [x] 支持忽略常见生成目录。
- [x] 支持 `.mbt` 文件扫描。
- [x] 支持 README / Markdown 扫描。
- [x] 支持 `moon.mod` 扫描。
- [x] 支持 `pkg.generated.mbti` 存在性检查。
- [x] 支持 GitHub Actions workflow 扫描。

## 待完善

- [ ] 错误处理更细化。
- [ ] 以相对路径显示报告。
- [ ] 支持配置文件。

## 当前问题

- 当前目录遍历使用 `moonbitlang/x/fs` 和 `moonbitlang/x/path`，需要继续在 Windows 和 CI/Linux 上验证。

