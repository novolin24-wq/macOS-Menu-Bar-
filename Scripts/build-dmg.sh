#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="中文日历"
EXECUTABLE_NAME="CalendarMenuBarApp"
DIST_DIR="$ROOT_DIR/dist"
WORK_DIR="${TMPDIR:-/private/tmp}/CalendarMenuBarApp-package"
STAGING_DIR="$WORK_DIR/dmg"
APP_DIR="$STAGING_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"

cd "$ROOT_DIR"
export CLANG_MODULE_CACHE_PATH="$WORK_DIR/ModuleCache"
export SWIFTPM_MODULECACHE_OVERRIDE="$CLANG_MODULE_CACHE_PATH"

rm -rf "$DIST_DIR" "$WORK_DIR" "$ROOT_DIR/.build"
mkdir -p "$DIST_DIR" "$CONTENTS_DIR/MacOS" "$CONTENTS_DIR/Resources" "$CLANG_MODULE_CACHE_PATH"

swift build -c release
BIN_DIR="$(swift build -c release --show-bin-path)"

cp "$BIN_DIR/$EXECUTABLE_NAME" "$CONTENTS_DIR/MacOS/$EXECUTABLE_NAME"
cp "$ROOT_DIR/Packaging/Info.plist" "$CONTENTS_DIR/Info.plist"
cp "$ROOT_DIR/CalendarMenuBarApp/Resources/holidays.json" "$CONTENTS_DIR/Resources/holidays.json"

ICONSET_DIR="$WORK_DIR/AppIcon.iconset"
swift "$ROOT_DIR/Scripts/CreateIcon.swift" "$ICONSET_DIR"
iconutil -c icns "$ICONSET_DIR" -o "$CONTENTS_DIR/Resources/AppIcon.icns"

xattr -cr "$APP_DIR"
codesign --force --deep --sign - "$APP_DIR"
codesign --verify --deep --strict "$APP_DIR"
ln -s /Applications "$STAGING_DIR/Applications"

hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$STAGING_DIR" \
    -ov \
    -format UDZO \
    "$DIST_DIR/$APP_NAME.dmg"

echo "已生成：$DIST_DIR/$APP_NAME.dmg"
