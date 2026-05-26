import AppKit
import Foundation

guard CommandLine.arguments.count == 2 else {
    fatalError("Usage: swift CreateIcon.swift <iconset directory>")
}

let iconsetURL = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
try FileManager.default.createDirectory(at: iconsetURL, withIntermediateDirectories: true)

let files: [(String, Int)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024)
]

for (filename, size) in files {
    let image = makeIcon(size: CGFloat(size))
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let data = rep.representation(using: .png, properties: [:]) else {
        fatalError("Could not render icon \(filename)")
    }
    try data.write(to: iconsetURL.appendingPathComponent(filename))
}

func makeIcon(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let bounds = NSRect(x: 0, y: 0, width: size, height: size)
    let padding = size * 0.075
    let card = bounds.insetBy(dx: padding, dy: padding)
    let radius = size * 0.22

    let shadow = NSShadow()
    shadow.shadowColor = NSColor(calibratedWhite: 0.05, alpha: 0.18)
    shadow.shadowOffset = NSSize(width: 0, height: -size * 0.025)
    shadow.shadowBlurRadius = size * 0.065
    shadow.set()

    let path = NSBezierPath(roundedRect: card, xRadius: radius, yRadius: radius)
    let gradient = NSGradient(colors: [
        NSColor(calibratedRed: 0.12, green: 0.54, blue: 1.0, alpha: 1.0),
        NSColor(calibratedRed: 0.18, green: 0.36, blue: 0.98, alpha: 1.0)
    ])!
    gradient.draw(in: path, angle: -60)

    NSGraphicsContext.current?.saveGraphicsState()
    path.addClip()
    let topBand = NSRect(x: card.minX, y: card.maxY - size * 0.20, width: card.width, height: size * 0.20)
    NSColor.white.withAlphaComponent(0.16).setFill()
    topBand.fill()
    NSGraphicsContext.current?.restoreGraphicsState()

    let attributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: size * 0.42, weight: .bold),
        .foregroundColor: NSColor.white
    ]
    let text = "日" as NSString
    let textSize = text.size(withAttributes: attributes)
    text.draw(
        at: NSPoint(x: (size - textSize.width) / 2, y: size * 0.27),
        withAttributes: attributes
    )

    image.unlockFocus()
    return image
}
