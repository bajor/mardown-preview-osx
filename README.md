# Markdown Preview for macOS

A Quick Look extension that renders Markdown files with GitHub-style formatting when you press spacebar in Finder.

**Built without Xcode** - only requires Swift Command Line Tools.

![Preview Example](https://via.placeholder.com/600x400?text=Markdown+Preview)

## Features

- GitHub-style CSS rendering
- Light and dark mode support (follows system preference)
- Syntax highlighting for code blocks
- Full markdown support: headers, tables, code blocks, blockquotes, lists, images
- **Plain text file support**: Previews extensionless files like `LICENSE`, `Makefile`, `Dockerfile`, `.gitignore`, etc.
  - Only shows files ≤100 lines and ≤50KB (to avoid binaries)
  - Auto-detects language for syntax highlighting

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
git clone https://github.com/YOUR_USERNAME/markdown-preview-osx.git
cd markdown-preview-osx
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
2. Navigate to any `.md` file
3. Select the file and press **spacebar**
4. See your beautifully rendered markdown!

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
4. **Code Highlighting**: Uses [highlight.js](https://highlightjs.org/) for syntax highlighting
5. **Binary Detection**: Checks file size and content to avoid displaying binary files

## Uninstall

```bash
rm -rf ~/Applications/MarkdownPreview.app
qlmanage -r
```

## License

MIT
