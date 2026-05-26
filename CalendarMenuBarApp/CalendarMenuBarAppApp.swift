import AppKit
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
        Image(nsImage: MenuBarIconRenderer.image(style: style, date: now))
            .renderingMode(.template)
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

private enum MenuBarIconRenderer {
    static func image(style: AnimalStyle, date: Date) -> NSImage {
        let size = NSSize(width: 28, height: 20)
        let day = "\(Calendar.current.component(.day, from: date))" as NSString
        let image = NSImage(size: size, flipped: false) { _ in
            NSColor.black.setStroke()
            let outline = animalPath(for: style)
            outline.lineWidth = 1.7
            outline.lineJoinStyle = .round
            outline.lineCapStyle = .round
            outline.stroke()

            if style == .cat {
                drawCatWhiskers()
            }

            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 9.7, weight: .bold),
                .foregroundColor: NSColor.black
            ]
            let textSize = day.size(withAttributes: attributes)
            day.draw(at: NSPoint(x: (size.width - textSize.width) / 2, y: 3.2), withAttributes: attributes)
            return true
        }
        image.isTemplate = true
        return image
    }

    private static func animalPath(for style: AnimalStyle) -> NSBezierPath {
        switch style {
        case .cat:
            return catPath()
        case .bear:
            return bearPath()
        case .rabbit:
            return rabbitPath()
        case .fox:
            return foxPath()
        case .penguin:
            return penguinPath()
        }
    }

    private static func catPath() -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 3, y: 12.5))
        path.line(to: NSPoint(x: 3.8, y: 18))
        path.line(to: NSPoint(x: 9, y: 15.5))
        path.curve(to: NSPoint(x: 19, y: 15.5), controlPoint1: NSPoint(x: 11.5, y: 16.8), controlPoint2: NSPoint(x: 16.5, y: 16.8))
        path.line(to: NSPoint(x: 24.2, y: 18))
        path.line(to: NSPoint(x: 25, y: 12.5))
        path.curve(to: NSPoint(x: 25.2, y: 7.2), controlPoint1: NSPoint(x: 26, y: 10.8), controlPoint2: NSPoint(x: 26, y: 8.6))
        path.curve(to: NSPoint(x: 14, y: 1.4), controlPoint1: NSPoint(x: 23.4, y: 3.5), controlPoint2: NSPoint(x: 19, y: 1.4))
        path.curve(to: NSPoint(x: 2.8, y: 7.2), controlPoint1: NSPoint(x: 9, y: 1.4), controlPoint2: NSPoint(x: 4.6, y: 3.5))
        path.curve(to: NSPoint(x: 3, y: 12.5), controlPoint1: NSPoint(x: 2, y: 8.6), controlPoint2: NSPoint(x: 2, y: 10.8))
        path.close()
        return path
    }

    private static func drawCatWhiskers() {
        let whiskers = NSBezierPath()
        whiskers.lineWidth = 1.15
        whiskers.lineCapStyle = .round
        whiskers.move(to: NSPoint(x: 2.1, y: 8.3))
        whiskers.line(to: NSPoint(x: 0.4, y: 8.8))
        whiskers.move(to: NSPoint(x: 2.1, y: 6.4))
        whiskers.line(to: NSPoint(x: 0.4, y: 6.0))
        whiskers.move(to: NSPoint(x: 25.9, y: 8.3))
        whiskers.line(to: NSPoint(x: 27.6, y: 8.8))
        whiskers.move(to: NSPoint(x: 25.9, y: 6.4))
        whiskers.line(to: NSPoint(x: 27.6, y: 6.0))
        whiskers.stroke()
    }

    private static func bearPath() -> NSBezierPath {
        let path = NSBezierPath(ovalIn: NSRect(x: 3, y: 13, width: 6, height: 6))
        path.appendOval(in: NSRect(x: 19, y: 13, width: 6, height: 6))
        path.appendRoundedRect(NSRect(x: 3.5, y: 1.5, width: 21, height: 16), xRadius: 9, yRadius: 9)
        return path
    }

    private static func rabbitPath() -> NSBezierPath {
        let path = NSBezierPath(roundedRect: NSRect(x: 7, y: 12, width: 5, height: 8), xRadius: 2.5, yRadius: 2.5)
        path.appendRoundedRect(NSRect(x: 16, y: 12, width: 5, height: 8), xRadius: 2.5, yRadius: 2.5)
        path.appendRoundedRect(NSRect(x: 4, y: 1.5, width: 20, height: 15), xRadius: 9, yRadius: 9)
        return path
    }

    private static func foxPath() -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 3, y: 18))
        path.line(to: NSPoint(x: 10, y: 15))
        path.line(to: NSPoint(x: 18, y: 15))
        path.line(to: NSPoint(x: 25, y: 18))
        path.line(to: NSPoint(x: 22, y: 6))
        path.line(to: NSPoint(x: 14, y: 1.5))
        path.line(to: NSPoint(x: 6, y: 6))
        path.close()
        return path
    }

    private static func penguinPath() -> NSBezierPath {
        NSBezierPath(ovalIn: NSRect(x: 4, y: 1, width: 20, height: 18))
    }
}
