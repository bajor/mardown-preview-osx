#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Building Markdown Preview Quick Look Extension ===${NC}"

# Configuration
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$PROJECT_DIR/.build"
APP_NAME="MarkdownPreview"
EXT_NAME="MarkdownPreviewExtension"
BUNDLE_ID="com.local.MarkdownPreview"
INSTALL_DIR="$HOME/Applications"

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
rm -rf "$BUILD_DIR/app"
mkdir -p "$BUILD_DIR/app"

# Step 1: Build with SPM to get dependencies
echo -e "${YELLOW}Building dependencies with Swift Package Manager...${NC}"
cd "$PROJECT_DIR"
swift build -c release

# Get the build paths
SWIFT_BUILD_DIR="$BUILD_DIR/release"
INK_MODULE="$BUILD_DIR/release/Modules"

# Step 2: Create app bundle structure
echo -e "${YELLOW}Creating app bundle structure...${NC}"
APP_BUNDLE="$BUILD_DIR/app/$APP_NAME.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_PLUGINS="$APP_CONTENTS/PlugIns"

EXT_BUNDLE="$APP_PLUGINS/$EXT_NAME.appex"
EXT_CONTENTS="$EXT_BUNDLE/Contents"
EXT_MACOS="$EXT_CONTENTS/MacOS"

mkdir -p "$APP_MACOS"
mkdir -p "$EXT_MACOS"

# Step 3: Copy Info.plist files
echo -e "${YELLOW}Copying Info.plist files...${NC}"
cp "$PROJECT_DIR/Resources/AppInfo.plist" "$APP_CONTENTS/Info.plist"
cp "$PROJECT_DIR/Resources/ExtensionInfo.plist" "$EXT_CONTENTS/Info.plist"

# Step 4: Compile the main app
echo -e "${YELLOW}Compiling main app...${NC}"
swiftc \
    -o "$APP_MACOS/$APP_NAME" \
    -target arm64-apple-macosx12.0 \
    -sdk $(xcrun --show-sdk-path) \
    -framework Cocoa \
    -parse-as-library \
    "$PROJECT_DIR/Sources/MarkdownPreview/AppDelegate.swift"

# Step 5: Compile the extension
echo -e "${YELLOW}Compiling Quick Look extension...${NC}"

# Module and library paths from SPM build
MODULES_DIR="$BUILD_DIR/release/Modules"
LIB_DIR="$BUILD_DIR/arm64-apple-macosx/release"

# Also need the Ink build objects
INK_BUILD_DIR="$BUILD_DIR/release/Ink.build"

# Create object files list from Ink build
INK_OBJECTS=$(find "$INK_BUILD_DIR" -name "*.o" 2>/dev/null | tr '\n' ' ')

# For app extensions, use the Foundation extension entry point
swiftc \
    -o "$EXT_MACOS/$EXT_NAME" \
    -target arm64-apple-macosx12.0 \
    -sdk $(xcrun --show-sdk-path) \
    -framework Cocoa \
    -framework Quartz \
    -framework WebKit \
    -framework ExtensionFoundation \
    -I "$MODULES_DIR" \
    -L "$LIB_DIR" \
    -lMarkdownPreviewLib \
    -parse-as-library \
    -Xlinker -e -Xlinker _NSExtensionMain \
    -module-name "$EXT_NAME" \
    "$PROJECT_DIR/Sources/MarkdownPreviewExtension/HTMLTemplate.swift" \
    "$PROJECT_DIR/Sources/MarkdownPreviewExtension/MarkdownRenderer.swift" \
    "$PROJECT_DIR/Sources/MarkdownPreviewExtension/PreviewViewController.swift" \
    $INK_OBJECTS

# Step 6: Copy the Ink library
echo -e "${YELLOW}Linking libraries...${NC}"

# Find and copy libInk if needed (static linking should include it, but let's be safe)
# For static library, it should be linked in

# Step 7: Sign the bundles (ad-hoc signing for local use with entitlements)
echo -e "${YELLOW}Signing bundles (ad-hoc)...${NC}"
codesign --force --sign - --entitlements "$PROJECT_DIR/Resources/Extension.entitlements" "$EXT_BUNDLE"
codesign --force --sign - --entitlements "$PROJECT_DIR/Resources/App.entitlements" "$APP_BUNDLE"

# Step 8: Install
echo -e "${YELLOW}Installing to $INSTALL_DIR...${NC}"
mkdir -p "$INSTALL_DIR"
rm -rf "$INSTALL_DIR/$APP_NAME.app"
cp -R "$APP_BUNDLE" "$INSTALL_DIR/"

# Step 9: Reload Quick Look
echo -e "${YELLOW}Reloading Quick Look generators...${NC}"
qlmanage -r 2>/dev/null || true
qlmanage -r cache 2>/dev/null || true

echo -e "${GREEN}=== Build complete! ===${NC}"
echo -e "${GREEN}App installed to: $INSTALL_DIR/$APP_NAME.app${NC}"
echo ""
echo -e "${YELLOW}To use:${NC}"
echo "1. Open $INSTALL_DIR/$APP_NAME.app once to register the extension"
echo "2. Select any .md file in Finder"
echo "3. Press spacebar to preview"
echo ""
echo -e "${YELLOW}If preview doesn't work, try:${NC}"
echo "  qlmanage -p /path/to/your/file.md"
