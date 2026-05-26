# 中文日历

精致的 macOS 菜单栏中文日历。菜单栏以小猫轮廓显示今天的日期数字，点击打开月历浮窗；包含农历、二十四节气、法定假日和本地备注功能。

## 功能

- `MenuBarExtra` 原生浮窗，点击外部自动关闭
- 白底软陶小猫应用图标，以及紧凑的小猫日期菜单栏标记
- 320 点宽度的紧凑月历界面，支持月份前后切换与回到今天
- 中国农历日期、初一月份名和二十四节气
- 法定假日红色标注、调休补班橙色“班”标识
- 日期备注保存在本机 `UserDefaults`，保存后显示确认状态
- 菜单栏应用模式，不占用 Dock 位置

## 节假日数据

`CalendarMenuBarApp/Resources/holidays.json` 使用扁平日期映射，可直接更新。

- 2025 数据依据国务院办公厅 [国办发明电〔2024〕12号](https://www.gov.cn/zhengce/content/202411/content_6986382.htm)。
- 2026 数据依据国务院办公厅 [国办发明电〔2025〕7号](https://www.gov.cn/zhengce/content/202511/content_7047090.htm)。
- 截至 2026 年 5 月 26 日，国务院尚未发布 2027 年放假调休通知，因此未写入未经公布的 2027 调休安排。通知发布后只需补充 JSON，无需改代码。

## 构建安装包

需要 macOS 14 或更高版本以及已完成许可证确认的 Xcode。最低版本选择 macOS 14，是为了使用系统原生农历 API 准确标示闰月：

```bash
chmod +x Scripts/build-dmg.sh
./Scripts/build-dmg.sh
```

输出位置：

```text
dist/中文日历.dmg
```

生成的应用使用本地临时签名，适合本机安装使用。如需对外分发，需使用 Apple Developer ID 签名并公证。
