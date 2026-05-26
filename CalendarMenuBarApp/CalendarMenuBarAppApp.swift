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
        let size = NSSize(width: 23, height: 17)
        let day = "\(Calendar.current.component(.day, from: date))" as NSString
        let image = NSImage(size: size, flipped: false) { _ in
            NSColor.black.setStroke()
            let outline = animalPath(for: style)
            outline.lineWidth = 1.35
            outline.lineJoinStyle = .round
            outline.lineCapStyle = .round
            outline.stroke()

            if style == .cat {
                drawCatWhiskers()
            }

            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 8.3, weight: .bold),
                .foregroundColor: NSColor.black
            ]
            let textSize = day.size(withAttributes: attributes)
            day.draw(at: NSPoint(x: (size.width - textSize.width) / 2, y: 2.7), withAttributes: attributes)
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
        path.move(to: NSPoint(x: 2.6, y: 10.8))
        path.line(to: NSPoint(x: 3.2, y: 15.4))
        path.line(to: NSPoint(x: 7.6, y: 13.2))
        path.curve(to: NSPoint(x: 15.4, y: 13.2), controlPoint1: NSPoint(x: 9.4, y: 14.2), controlPoint2: NSPoint(x: 13.6, y: 14.2))
        path.line(to: NSPoint(x: 19.8, y: 15.4))
        path.line(to: NSPoint(x: 20.4, y: 10.8))
        path.curve(to: NSPoint(x: 20.6, y: 6.1), controlPoint1: NSPoint(x: 21.3, y: 9.4), controlPoint2: NSPoint(x: 21.3, y: 7.4))
        path.curve(to: NSPoint(x: 11.5, y: 1.2), controlPoint1: NSPoint(x: 19.1, y: 3.1), controlPoint2: NSPoint(x: 15.6, y: 1.2))
        path.curve(to: NSPoint(x: 2.4, y: 6.1), controlPoint1: NSPoint(x: 7.4, y: 1.2), controlPoint2: NSPoint(x: 3.9, y: 3.1))
        path.curve(to: NSPoint(x: 2.6, y: 10.8), controlPoint1: NSPoint(x: 1.7, y: 7.4), controlPoint2: NSPoint(x: 1.7, y: 9.4))
        path.close()
        return path
    }

    private static func drawCatWhiskers() {
        let whiskers = NSBezierPath()
        whiskers.lineWidth = 0.95
        whiskers.lineCapStyle = .round
        whiskers.move(to: NSPoint(x: 2.0, y: 7.2))
        whiskers.line(to: NSPoint(x: 0.5, y: 7.6))
        whiskers.move(to: NSPoint(x: 2.0, y: 5.7))
        whiskers.line(to: NSPoint(x: 0.5, y: 5.4))
        whiskers.move(to: NSPoint(x: 21.0, y: 7.2))
        whiskers.line(to: NSPoint(x: 22.5, y: 7.6))
        whiskers.move(to: NSPoint(x: 21.0, y: 5.7))
        whiskers.line(to: NSPoint(x: 22.5, y: 5.4))
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
