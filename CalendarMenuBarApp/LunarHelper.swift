import Foundation

enum LunarHelper {
    private static var chineseCalendar: Calendar = {
        var calendar = Calendar(identifier: .chinese)
        calendar.locale = Locale(identifier: "zh_CN")
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")!
        return calendar
    }()

    private static var gregorianCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")!
        return calendar
    }()

    private static let monthNames = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]
    private static let dayNames = [
        "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
        "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"
    ]

    private static let solarTermNames = [
        "小寒", "大寒", "立春", "雨水", "惊蛰", "春分",
        "清明", "谷雨", "立夏", "小满", "芒种", "夏至",
        "小暑", "大暑", "立秋", "处暑", "白露", "秋分",
        "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"
    ]

    // Minutes from 1900-01-06 02:05 UTC for each solar longitude crossing.
    private static let solarTermMinuteOffsets = [
        0, 21208, 42467, 63836, 85337, 107014,
        128867, 150921, 173149, 195551, 218072, 240693,
        263343, 285989, 308563, 331033, 353350, 375494,
        397447, 419210, 440795, 462224, 483532, 504758
    ]

    static func displayText(for date: Date) -> String {
        solarTerm(for: date) ?? lunarDay(for: date)
    }

    static func lunarDay(for date: Date) -> String {
        let components = chineseCalendar.dateComponents([.month, .day, .isLeapMonth], from: date)
        guard let month = components.month, let day = components.day else { return "" }
        if day == 1 {
            let prefix = components.isLeapMonth == true ? "闰" : ""
            return prefix + monthNames[safe: month - 1, default: ""]
        }
        return dayNames[safe: day - 1, default: ""]
    }

    static func lunarDescription(for date: Date) -> String {
        let components = chineseCalendar.dateComponents([.month, .day, .isLeapMonth], from: date)
        guard let month = components.month else { return "" }
        let prefix = components.isLeapMonth == true ? "闰" : ""
        return "农历 \(prefix)\(monthNames[safe: month - 1, default: ""])\(dayNames[safe: (components.day ?? 1) - 1, default: ""])"
    }

    static func solarTerm(for date: Date) -> String? {
        let year = gregorianCalendar.component(.year, from: date)
        for (index, name) in solarTermNames.enumerated() {
            if gregorianCalendar.isDate(date, inSameDayAs: solarTermDate(year: year, index: index)) {
                return name
            }
        }
        return nil
    }

    private static func solarTermDate(year: Int, index: Int) -> Date {
        var baseComponents = DateComponents()
        baseComponents.calendar = Calendar(identifier: .gregorian)
        baseComponents.timeZone = TimeZone(secondsFromGMT: 0)
        baseComponents.year = 1900
        baseComponents.month = 1
        baseComponents.day = 6
        baseComponents.hour = 2
        baseComponents.minute = 5
        let base = baseComponents.date!
        let yearMilliseconds = 31_556_925_974.7 * Double(year - 1900)
        let termMilliseconds = Double(solarTermMinuteOffsets[index]) * 60_000
        return base.addingTimeInterval((yearMilliseconds + termMilliseconds) / 1_000)
    }

}

private extension Array {
    subscript(safe index: Int, default fallback: Element) -> Element {
        indices.contains(index) ? self[index] : fallback
    }
}
