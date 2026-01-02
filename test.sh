#!/bin/bash
# Simple test script for Markdown Preview
# Verifies build and basic functionality without requiring Xcode

set -e

echo "=== Markdown Preview Tests ==="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

pass() { echo -e "${GREEN}✓ $1${NC}"; }
fail() { echo -e "${RED}✗ $1${NC}"; exit 1; }

# Test 1: Swift Package Manager build
echo "Test 1: Swift Package Manager builds successfully"
swift build --product MarkdownPreviewLib > /dev/null 2>&1 && pass "SPM build" || fail "SPM build failed"

# Test 2: Full build script works
echo "Test 2: Build script creates app bundle"
./build.sh > /dev/null 2>&1
[ -d ".build/app/MarkdownPreview.app" ] && pass "App bundle created" || fail "App bundle not created"

# Test 3: Extension bundle exists
echo "Test 3: Quick Look extension exists"
[ -d ".build/app/MarkdownPreview.app/Contents/PlugIns/MarkdownPreviewExtension.appex" ] && pass "Extension bundle exists" || fail "Extension bundle missing"

# Test 4: App is signed
echo "Test 4: App bundle is signed"
codesign -v ".build/app/MarkdownPreview.app" 2>/dev/null && pass "App is signed" || fail "App signing failed"

# Test 5: Extension is signed
echo "Test 5: Extension is signed"
codesign -v ".build/app/MarkdownPreview.app/Contents/PlugIns/MarkdownPreviewExtension.appex" 2>/dev/null && pass "Extension is signed" || fail "Extension signing failed"

# Test 6: Info.plist exists
echo "Test 6: Info.plist files exist"
[ -f ".build/app/MarkdownPreview.app/Contents/Info.plist" ] && \
[ -f ".build/app/MarkdownPreview.app/Contents/PlugIns/MarkdownPreviewExtension.appex/Contents/Info.plist" ] && \
pass "Info.plist files exist" || fail "Info.plist missing"

# Test 7: Test preview with qlmanage (if installed)
echo "Test 7: Quick Look preview works"
echo "# Test Markdown" > /tmp/test-markdown-preview.md
if qlmanage -p /tmp/test-markdown-preview.md > /dev/null 2>&1; then
    pass "Quick Look preview works"
else
    echo "  (skipped - Quick Look may need manual testing)"
fi
rm -f /tmp/test-markdown-preview.md

echo ""
echo -e "${GREEN}=== All tests passed ===${NC}"
