import Combine
import SwiftUI

@main
struct CalendarMenuBarAppApp: App {
    @StateObject private var eventManager = EventManager()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(eventManager)
        } label: {
            MenuBarDateLabel()
        }
        .menuBarExtraStyle(.window)
    }
}

private struct MenuBarDateLabel: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("\(Calendar.current.component(.day, from: now))")
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .monospacedDigit()
            .frame(minWidth: 18)
            .onReceive(timer) { now = $0 }
            .accessibilityLabel("日历，今天 \(now.formatted(.dateTime.year().month().day()))")
    }
}
