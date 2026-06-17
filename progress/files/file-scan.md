# file_scan.mbt / path_filter.mbt

## 文件职责

`file_scan.mbt` 负责判断文件类型。`path_filter.mbt` 负责忽略不应扫描的目录和文件路径。

## 当前完成情况

- [x] 支持 `.mbt` 源码识别。
- [x] 支持 Markdown / `.mbt.md` 识别。
- [x] 支持 README 识别。
- [x] 支持 GitHub Actions workflow 识别。
- [x] 支持 `.git`、`.moon`、`.repos`、`target`、`build`、`_build`、`.analysis_*` 忽略。
- [x] 支持 `.mooncakes` 依赖缓存忽略。

## 待完善

- [ ] 支持用户配置忽略路径。
- [ ] 支持更多 CI 文件类型。

## 当前问题

- 需要继续观察 Windows 相对路径中的 `.\` 前缀是否还有其他过滤盲点。
