import Foundation

struct HolidayEntry: Decodable {
    enum DayType: String, Decodable {
        case holiday
        case workday
    }

    let type: DayType
    let name: String
}

final class HolidayManager {
    static let shared = HolidayManager()

    private let entries: [String: HolidayEntry]
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private init() {
        let url = Bundle.main.url(forResource: "holidays", withExtension: "json")
            ?? Bundle.module.url(forResource: "holidays", withExtension: "json")

        guard let url, let data = try? Data(contentsOf: url) else {
            entries = [:]
            return
        }

        entries = (try? JSONDecoder().decode([String: HolidayEntry].self, from: data)) ?? [:]
    }

    func holiday(for date: Date) -> HolidayEntry? {
        entries[formatter.string(from: date)]
    }
}
