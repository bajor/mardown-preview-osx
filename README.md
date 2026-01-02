# Markdown Preview for macOS

A Quick Look extension that renders Markdown files with GitHub-style formatting when you press spacebar in Finder.

**Built without Xcode** - only requires Swift Command Line Tools.

## Features

- **Markdown rendering** with GitHub-style CSS
- **Light and dark mode** support (follows system preference)
- **Syntax highlighting** for code blocks in markdown files
- Full markdown support: headers, tables, code blocks, blockquotes, lists, images
- **`.rule` file support**: Displays rule files as plain text without size limits
- **Plain text previews**: Supports extensionless files like `LICENSE`, `Makefile`, `Dockerfile`, `.gitignore`, etc.
  - Shows files ≤100 lines and ≤50KB (to avoid binaries)

## Requirements

- macOS 12.0 or later
- Swift Command Line Tools (not full Xcode)

### Install Command Line Tools

If you don't have them installed:

```bash
xcode-select --install
```

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/bajor/mardown-preview-osx.git
cd mardown-preview-osx
```

### 2. Build and install

```bash
./build.sh
```

This will:
- Fetch the [Ink](https://github.com/JohnSundell/Ink) markdown parser via Swift Package Manager
- Compile the extension
- Sign it for local use (ad-hoc signing)
- Install to `~/Applications/MarkdownPreview.app`
- Reset Quick Look generators

### 3. Register the extension

Open the app once to register the Quick Look extension:

```bash
open ~/Applications/MarkdownPreview.app
```

### 4. Use it

1. Open Finder
2. Navigate to any `.md` or `.rule` file
3. Select the file and press **spacebar**
4. See your beautifully rendered content!

## Testing

Run the test script to verify the build:

```bash
./test.sh
```

## Troubleshooting

### Preview shows raw text instead of rendered markdown

Reset Quick Look and restart Finder:

```bash
qlmanage -r
killall quicklookd
killall Finder
```

Then try again.

### Extension not loading

1. Make sure you opened the app at least once:
   ```bash
   open ~/Applications/MarkdownPreview.app
   ```

2. Check if the extension is registered:
   ```bash
   pluginkit -m -p com.apple.quicklook.preview | grep -i local
   ```

3. Try manually registering:
   ```bash
   pluginkit -a ~/Applications/MarkdownPreview.app/Contents/PlugIns/MarkdownPreviewExtension.appex
   ```

### Test with qlmanage

```bash
qlmanage -p /path/to/your/file.md
```

## Project Structure

```
.
├── Package.swift                      # Swift Package Manager manifest
├── build.sh                           # Build script
├── test.sh                            # Test script
├── VERSION                            # Current version
├── CHANGELOG.md                       # Version history
├── Sources/
│   ├── MarkdownPreview/
│   │   └── AppDelegate.swift          # Container app (minimal)
│   └── MarkdownPreviewExtension/
│       ├── PreviewViewController.swift # Quick Look controller
│       ├── MarkdownRenderer.swift      # Markdown to HTML conversion
│       └── HTMLTemplate.swift          # CSS styling
└── Resources/
    ├── AppInfo.plist                  # App bundle configuration
    ├── ExtensionInfo.plist            # Extension configuration
    ├── App.entitlements               # App sandbox entitlements
    └── Extension.entitlements         # Extension sandbox entitlements
```

## How It Works

1. **Quick Look Integration**: The extension implements `QLPreviewingController` protocol
2. **Markdown Parsing**: Uses [Ink](https://github.com/JohnSundell/Ink) Swift library to convert markdown to HTML
3. **Rendering**: Displays HTML in a `WKWebView` with GitHub-inspired CSS
4. **Code Highlighting**: Uses [highlight.js](https://highlightjs.org/) for syntax highlighting in markdown code blocks
5. **Binary Detection**: Checks file size and content to avoid displaying binary files

## Supported File Types

| Type | Extensions/Files | Notes |
|------|------------------|-------|
| Markdown | `.md`, `.markdown`, `.mdown`, `.mkd`, `.mkdn` | Full rendering with syntax highlighting |
| Rule files | `.rule` | Plain text, no size limits |
| Plain text | `.txt`, `.gitignore`, `LICENSE`, `Makefile`, etc. | ≤100 lines, ≤50KB |

## Uninstall

```bash
rm -rf ~/Applications/MarkdownPreview.app
qlmanage -r
```

## License

MIT
