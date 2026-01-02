import Cocoa
import Quartz
import WebKit

public class PreviewViewController: NSViewController, QLPreviewingController {

    private var webView: WKWebView!

    // Maximum lines for plain text files (to avoid showing huge files or binaries)
    private let maxPlainTextLines = 100
    private let maxFileSize = 50_000 // 50KB max for plain text

    public override func loadView() {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 800, height: 600), configuration: config)
        webView.setValue(false, forKey: "drawsBackground")
        self.view = webView
    }

    public func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        do {
            // Check file size first
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            let fileSize = attributes[.size] as? Int ?? 0

            if fileSize > maxFileSize {
                handler(NSError(domain: "MarkdownPreview", code: 1, userInfo: [NSLocalizedDescriptionKey: "File too large"]))
                return
            }

            // Try to read as UTF-8 text
            guard let content = try? String(contentsOf: url, encoding: .utf8),
                  isLikelyTextContent(content) else {
                handler(NSError(domain: "MarkdownPreview", code: 2, userInfo: [NSLocalizedDescriptionKey: "Not a text file"]))
                return
            }

            let fileName = url.lastPathComponent
            let htmlContent: String

            if isMarkdownFile(url) {
                // Render as markdown
                htmlContent = MarkdownRenderer.render(markdown: content, fileName: fileName)
            } else {
                // Check line count for plain text
                let lineCount = content.components(separatedBy: .newlines).count
                if lineCount > maxPlainTextLines {
                    handler(NSError(domain: "MarkdownPreview", code: 3, userInfo: [NSLocalizedDescriptionKey: "File has too many lines"]))
                    return
                }
                // Display as plain text with syntax highlighting
                htmlContent = MarkdownRenderer.renderPlainText(content: content, fileName: fileName)
            }

            webView.loadHTMLString(htmlContent, baseURL: url.deletingLastPathComponent())
            handler(nil)
        } catch {
            handler(error)
        }
    }

    private func isMarkdownFile(_ url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        return ["md", "markdown", "mdown", "mkd", "mkdn"].contains(ext)
    }

    private func isLikelyTextContent(_ content: String) -> Bool {
        // Check for null bytes or high ratio of non-printable characters (binary detection)
        let validChars = content.unicodeScalars.filter { scalar in
            // Allow printable ASCII, newlines, tabs, and common unicode
            return scalar.isASCII ? (scalar.value >= 32 || scalar.value == 9 || scalar.value == 10 || scalar.value == 13) : true
        }

        // If more than 95% of characters are "text-like", consider it text
        guard content.count > 0 else { return true }
        let ratio = Double(validChars.count) / Double(content.unicodeScalars.count)
        return ratio > 0.95
    }
}
