import Combine
import SwiftUI

@main
struct CalendarMenuBarAppApp: App {
    @StateObject private var eventManager = EventManager()
    private let animalStyle: AnimalStyle = .cat

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(eventManager)
        } label: {
            MenuBarDateLabel(style: animalStyle)
        }
        .menuBarExtraStyle(.window)
    }
}

private struct MenuBarDateLabel: View {
    let style: AnimalStyle
    @State private var now = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        AnimalMenuBarIcon(style: style, date: now)
            .onReceive(timer) { now = $0 }
            .accessibilityLabel("日历，今天 \(now.formatted(.dateTime.year().month().day()))")
    }
}

enum AnimalStyle {
    case cat
    case bear
    case rabbit
    case fox
    case penguin
}

private struct AnimalMenuBarIcon: View {
    let style: AnimalStyle
    let date: Date

    private var day: String {
        "\(Calendar.current.component(.day, from: date))"
    }

    var body: some View {
        HStack(spacing: 3) {
            AnimalSilhouette(style: style)
                .fill(.primary)
                .frame(width: glyphWidth, height: 15)

            Text(day)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .monospacedDigit()
        }
        .foregroundStyle(.primary)
        .frame(height: 20)
    }

    private var glyphWidth: CGFloat {
        style == .rabbit ? 11 : 14
    }
}

private struct AnimalSilhouette: Shape {
    let style: AnimalStyle

    func path(in rect: CGRect) -> Path {
        switch style {
        case .cat:
            return catPath(in: rect)
        case .bear:
            return bearPath(in: rect)
        case .rabbit:
            return rabbitPath(in: rect)
        case .fox:
            return foxPath(in: rect)
        case .penguin:
            return penguinPath(in: rect)
        }
    }

    private func catPath(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: point(0.16, 0.40, in: rect))
        path.addLine(to: point(0.16, 0.10, in: rect))
        path.addLine(to: point(0.34, 0.26, in: rect))
        path.addCurve(to: point(0.66, 0.26, in: rect), control1: point(0.42, 0.21, in: rect), control2: point(0.58, 0.21, in: rect))
        path.addLine(to: point(0.84, 0.10, in: rect))
        path.addLine(to: point(0.84, 0.40, in: rect))
        path.addCurve(to: point(0.50, 0.97, in: rect), control1: point(0.92, 0.70, in: rect), control2: point(0.74, 0.97, in: rect))
        path.addCurve(to: point(0.16, 0.40, in: rect), control1: point(0.26, 0.97, in: rect), control2: point(0.08, 0.70, in: rect))
        path.closeSubpath()
        return path
    }

    private func bearPath(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: subrect(0.06, 0.12, 0.28, 0.28, in: rect))
        path.addEllipse(in: subrect(0.66, 0.12, 0.28, 0.28, in: rect))
        path.addRoundedRect(in: subrect(0.12, 0.22, 0.76, 0.73, in: rect), cornerSize: CGSize(width: rect.width * 0.35, height: rect.height * 0.35))
        return path
    }

    private func rabbitPath(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: subrect(0.20, 0.02, 0.21, 0.42, in: rect), cornerSize: CGSize(width: rect.width * 0.12, height: rect.height * 0.20))
        path.addRoundedRect(in: subrect(0.59, 0.02, 0.21, 0.42, in: rect), cornerSize: CGSize(width: rect.width * 0.12, height: rect.height * 0.20))
        path.addRoundedRect(in: subrect(0.10, 0.29, 0.80, 0.67, in: rect), cornerSize: CGSize(width: rect.width * 0.39, height: rect.height * 0.32))
        return path
    }

    private func foxPath(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: point(0.08, 0.12, in: rect))
        path.addLine(to: point(0.37, 0.27, in: rect))
        path.addCurve(to: point(0.63, 0.27, in: rect), control1: point(0.44, 0.22, in: rect), control2: point(0.56, 0.22, in: rect))
        path.addLine(to: point(0.92, 0.12, in: rect))
        path.addLine(to: point(0.80, 0.64, in: rect))
        path.addCurve(to: point(0.50, 0.98, in: rect), control1: point(0.72, 0.85, in: rect), control2: point(0.60, 0.98, in: rect))
        path.addCurve(to: point(0.20, 0.64, in: rect), control1: point(0.40, 0.98, in: rect), control2: point(0.28, 0.85, in: rect))
        path.closeSubpath()
        return path
    }

    private func penguinPath(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: subrect(0.15, 0.05, 0.70, 0.91, in: rect))
        return path
    }

    private func point(_ x: CGFloat, _ y: CGFloat, in rect: CGRect) -> CGPoint {
        CGPoint(x: rect.minX + rect.width * x, y: rect.minY + rect.height * y)
    }

    private func subrect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat, in rect: CGRect) -> CGRect {
        CGRect(x: rect.minX + rect.width * x, y: rect.minY + rect.height * y, width: rect.width * width, height: rect.height * height)
    }
}
