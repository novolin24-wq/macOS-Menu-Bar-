import Combine
import Foundation

final class EventManager: ObservableObject {
    @Published private(set) var notes: [String: String] = [:]

    private let storageKey = "CalendarMenuBarApp.notes"
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    init() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([String: String].self, from: data) else {
            return
        }
        notes = decoded
    }

    func note(for date: Date) -> String {
        notes[key(for: date)] ?? ""
    }

    func save(note: String, for date: Date) {
        let cleaned = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let key = key(for: date)
        if cleaned.isEmpty {
            notes.removeValue(forKey: key)
        } else {
            notes[key] = cleaned
        }

        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func key(for date: Date) -> String {
        formatter.string(from: date)
    }
}
