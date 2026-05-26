import SwiftUI

struct CalendarGridView: View {
    let displayedMonth: Date
    let selectedDate: Date?
    let onSelect: (Date) -> Void

    private var calendar: Calendar {
        var result = Calendar(identifier: .gregorian)
        result.locale = Locale(identifier: "zh_CN")
        result.firstWeekday = 2
        return result
    }

    private let weekdayNames = ["一", "二", "三", "四", "五", "六", "日"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)

    var body: some View {
        VStack(spacing: 5) {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(weekdayNames, id: \.self) { title in
                    Text(title)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(title == "六" || title == "日" ? Color.red.opacity(0.7) : .secondary)
                        .frame(height: 22)
                }
            }

            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(days, id: \.self) { date in
                    DayCell(
                        date: date,
                        isDisplayedMonth: calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month),
                        isToday: calendar.isDateInToday(date),
                        isSelected: selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false,
                        holiday: HolidayManager.shared.holiday(for: date)
                    )
                    .onTapGesture { onSelect(date) }
                }
            }
        }
    }

    private var days: [Date] {
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))!
        let weekday = calendar.component(.weekday, from: monthStart)
        let offsetFromMonday = (weekday + 5) % 7
        let gridStart = calendar.date(byAdding: .day, value: -offsetFromMonday, to: monthStart)!
        let range = calendar.range(of: .day, in: .month, for: monthStart)!
        let needed = offsetFromMonday + range.count
        let cellCount = needed > 35 ? 42 : 35

        return (0..<cellCount).compactMap {
            calendar.date(byAdding: .day, value: $0, to: gridStart)
        }
    }
}
