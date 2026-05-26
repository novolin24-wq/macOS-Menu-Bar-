import AppKit
import Foundation

guard CommandLine.arguments.count == 3 else {
    fatalError("Usage: swift CreateIcon.swift <source image> <iconset directory>")
}

let sourceURL = URL(fileURLWithPath: CommandLine.arguments[1])
let iconsetURL = URL(fileURLWithPath: CommandLine.arguments[2], isDirectory: true)
try FileManager.default.createDirectory(at: iconsetURL, withIntermediateDirectories: true)

guard let sourceImage = NSImage(contentsOf: sourceURL) else {
    fatalError("Could not read source icon at \(sourceURL.path)")
}

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
    let image = renderIcon(from: sourceImage, size: CGFloat(size))
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let data = rep.representation(using: .png, properties: [:]) else {
        fatalError("Could not render icon \(filename)")
    }
    try data.write(to: iconsetURL.appendingPathComponent(filename))
}

func renderIcon(from sourceImage: NSImage, size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()
    NSGraphicsContext.current?.imageInterpolation = .high
    sourceImage.draw(in: NSRect(x: 0, y: 0, width: size, height: size), from: .zero, operation: .copy, fraction: 1)
    image.unlockFocus()
    return image
}
