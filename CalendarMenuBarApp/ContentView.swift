import AppKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var eventManager: EventManager
    @State private var displayedMonth = Calendar.current.startOfMonth(containing: Date())
    @State private var selectedDate: Date?

    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 0) {
            header

            CalendarGridView(
                displayedMonth: displayedMonth,
                selectedDate: selectedDate,
                eventManager: eventManager
            ) { date in
                withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                    selectedDate = calendar.isDate(selectedDate ?? .distantPast, inSameDayAs: date) ? nil : date
                }
            }
            .padding(.horizontal, 12)

            if let selectedDate {
                NoteEditor(date: selectedDate, eventManager: eventManager) {
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.88)) {
                        self.selectedDate = nil
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            footer
        }
        .padding(.top, 14)
        .padding(.bottom, 10)
        .frame(width: 320)
        .background(
            ZStack {
                Color(nsColor: .windowBackgroundColor)
                LinearGradient(
                    colors: [Color.blue.opacity(0.055), .clear, Color.indigo.opacity(0.025)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(displayedMonth.formatted(.dateTime.year().month(.wide).locale(Locale(identifier: "zh_CN"))))
                        .font(.system(size: 21, weight: .bold, design: .rounded))
                    Text(lunarSummary)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 5) {
                    HeaderButton(symbol: "chevron.left") {
                        moveMonth(by: -1)
                    }
                    HeaderButton(symbol: "circle.fill", isSmall: true) {
                        withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
                            displayedMonth = calendar.startOfMonth(containing: Date())
                            selectedDate = Date()
                        }
                    }
                    .help("回到今天")
                    HeaderButton(symbol: "chevron.right") {
                        moveMonth(by: 1)
                    }
                }
            }
            .padding(.horizontal, 16)

            Divider().opacity(0.6)
        }
        .padding(.bottom, 9)
    }

    private var footer: some View {
        HStack {
            Text("点击日期添加备注")
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)

            Spacer()

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Image(systemName: "power")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("退出日历")
        }
        .padding(.horizontal, 16)
        .padding(.top, 11)
    }

    private var lunarSummary: String {
        if calendar.isDate(displayedMonth, equalTo: Date(), toGranularity: .month) {
            return "今日 \(LunarHelper.lunarDescription(for: Date()))"
        }
        return LunarHelper.lunarDescription(for: displayedMonth)
    }

    private func moveMonth(by amount: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: amount, to: displayedMonth) else { return }
        withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
            displayedMonth = newMonth
            selectedDate = nil
        }
    }
}

private struct HeaderButton: View {
    let symbol: String
    var isSmall = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: isSmall ? 6 : 11, weight: .bold))
                .foregroundStyle(isSmall ? Color.accentColor : Color.primary)
                .frame(width: 28, height: 28)
                .background(.primary.opacity(0.045), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct NoteEditor: View {
    let date: Date
    @ObservedObject var eventManager: EventManager
    let dismiss: () -> Void
    @State private var note = ""
    @State private var didSave = false

    private let locale = Locale(identifier: "zh_CN")

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(date.formatted(.dateTime.month(.wide).day().weekday(.wide).locale(locale)))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 8) {
                TextField("添加备注，如：14:00 项目复盘", text: $note)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .onSubmit(save)

                Button(action: save) {
                    HStack(spacing: 4) {
                        if didSave {
                            Image(systemName: "checkmark")
                        }
                        Text(didSave ? "已保存" : "保存")
                    }
                }
                    .font(.system(size: 12, weight: .semibold))
                    .buttonStyle(.borderedProminent)
                    .tint(didSave ? .green : .accentColor)
                    .controlSize(.small)
            }
        }
        .padding(10)
        .background(.primary.opacity(0.045), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .onAppear { note = eventManager.note(for: date) }
        .onChange(of: date) { _, newDate in
            note = eventManager.note(for: newDate)
            didSave = false
        }
    }

    private func save() {
        eventManager.save(note: note, for: date)
        withAnimation(.easeInOut(duration: 0.18)) {
            didSave = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.easeInOut(duration: 0.18)) {
                didSave = false
            }
        }
    }
}

private extension Calendar {
    func startOfMonth(containing date: Date) -> Date {
        self.date(from: dateComponents([.year, .month], from: date)) ?? date
    }
}
