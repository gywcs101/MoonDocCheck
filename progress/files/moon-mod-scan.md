# moon_mod_scan.mbt

## 文件职责

扫描 `moon.mod` 文本，检测项目元数据字段是否存在。

## 当前完成情况

- [x] 支持 name、version、readme、repository、license、keywords、description 检测。

## 待完善

- [ ] 检查字段是否为空。
- [ ] 检查 license 是否为常见 OSI 许可证。

## 当前问题

- 当前只做轻量文本检测，不做完整 moon.mod 解析。

