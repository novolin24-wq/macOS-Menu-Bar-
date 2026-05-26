import SwiftUI

struct DayCell: View {
    let date: Date
    let isDisplayedMonth: Bool
    let isToday: Bool
    let isSelected: Bool
    let holiday: HolidayEntry?

    private var isHoliday: Bool { holiday?.type == .holiday }
    private var isWorkday: Bool { holiday?.type == .workday }
    private var secondaryText: String { LunarHelper.displayText(for: date) }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 1) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 15, weight: isToday || isSelected ? .bold : .medium, design: .rounded))
                    .foregroundStyle(dayColor)
                    .frame(width: 28, height: 25)
                    .background {
                        if isToday {
                            Circle().fill(Color.accentColor)
                        } else if isSelected {
                            Circle().fill(Color.accentColor.opacity(0.15))
                        }
                    }

                Text(secondaryText)
                    .font(.system(size: 9.5, weight: LunarHelper.solarTerm(for: date) == nil ? .regular : .semibold))
                    .foregroundStyle(LunarHelper.solarTerm(for: date) == nil ? Color.secondary : Color.accentColor)
                    .lineLimit(1)

                Text(holidayText)
                    .font(.system(size: 8.5, weight: .medium))
                    .foregroundStyle(isHoliday ? Color.red.opacity(0.9) : Color.clear)
                    .lineLimit(1)
            }
            .opacity(isDisplayedMonth ? 1 : 0.27)

            if isWorkday && isDisplayedMonth {
                Text("班")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.orange)
                    .offset(x: 1, y: 1)
            }

        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .background {
            if isSelected && !isToday {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.accentColor.opacity(0.06))
            }
        }
        .contentShape(Rectangle())
    }

    private var holidayText: String {
        isHoliday ? (holiday?.name ?? "") : " "
    }

    private var dayColor: Color {
        if isToday { return .white }
        if isHoliday { return .red }
        return .primary
    }
}
