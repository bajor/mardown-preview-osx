# Changelog

All notable changes to Markdown Preview for macOS will be documented in this file.

## [1.2.1] - 2026-01-02

### Changed
- Plain text files now display without syntax highlighting (plain monospace text)

## [1.2.0] - 2026-01-02

### Added
- Support for `.rule` file extension (displays as plain text)

## [1.1.0] - 2026-01-02

### Fixed
- Non-markdown file previews now display without visible frame/border, matching native macOS Quick Look appearance
- Background color now uses Apple system grays (`#f5f5f7` light / `#1d1d1f` dark) instead of GitHub-style colors
- Makefile syntax highlighting now works correctly (added highlight.js makefile language module)
- Dockerfile syntax highlighting now works correctly (added highlight.js dockerfile language module)

### Added
- New `wrapPlainText()` template function for clean, frameless plain text file rendering
- VERSION file for version tracking

### Changed
- Updated all color variables to use macOS-consistent palette
- Plain text files now use monospace font (SF Mono) with minimal padding for native appearance

## [1.0.0] - Initial Release

### Features
- Markdown file rendering with full GitHub-flavored styling
- Syntax highlighting for code blocks using highlight.js
- Dark mode support (automatic via `prefers-color-scheme`)
- Plain text file preview with automatic language detection
- Support for extensionless files (Makefile, Dockerfile, Gemfile, etc.)
- Binary file detection to prevent rendering non-text files
- File size limits for performance (50KB max, 100 lines max for plain text)
