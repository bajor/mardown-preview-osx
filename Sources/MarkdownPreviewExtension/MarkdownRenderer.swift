import Foundation
import Ink

public struct MarkdownRenderer {

    private static let parser = MarkdownParser()

    public static func render(markdown: String, fileName: String = "") -> String {
        let htmlBody = parser.html(from: markdown)
        return HTMLTemplate.wrap(body: htmlBody, title: fileName)
    }

    public static func renderPlainText(content: String, fileName: String = "") -> String {
        // Escape HTML entities
        let escaped = content
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")

        // Detect language from filename for syntax highlighting
        let language = detectLanguage(from: fileName)
        let codeClass = language.isEmpty ? "" : "class=\"language-\(language)\""

        let htmlBody = "<pre><code \(codeClass)>\(escaped)</code></pre>"
        return HTMLTemplate.wrapPlainText(body: htmlBody, title: fileName)
    }

    private static func detectLanguage(from fileName: String) -> String {
        let name = fileName.lowercased()

        // Check for known extensionless files
        let knownFiles: [String: String] = [
            "dockerfile": "dockerfile",
            "makefile": "makefile",
            "gemfile": "ruby",
            "rakefile": "ruby",
            "podfile": "ruby",
            "vagrantfile": "ruby",
            "brewfile": "ruby",
            "procfile": "yaml",
            "cakefile": "coffeescript",
            "license": "plaintext",
            "licence": "plaintext",
            "authors": "plaintext",
            "contributors": "plaintext",
            "readme": "plaintext",
            "changelog": "plaintext",
            "history": "plaintext",
            "copying": "plaintext",
            "notice": "plaintext",
            "todo": "plaintext",
            "codeowners": "plaintext",
            ".gitignore": "gitignore",
            ".gitattributes": "gitignore",
            ".gitmodules": "ini",
            ".editorconfig": "ini",
            ".npmrc": "ini",
            ".nvmrc": "plaintext",
            ".env": "bash",
            ".env.example": "bash",
            ".bashrc": "bash",
            ".bash_profile": "bash",
            ".zshrc": "bash",
            ".profile": "bash",
        ]

        if let lang = knownFiles[name] {
            return lang
        }

        // Check by extension
        let ext = (fileName as NSString).pathExtension.lowercased()
        let extMap: [String: String] = [
            "sh": "bash",
            "bash": "bash",
            "zsh": "bash",
            "fish": "bash",
            "yml": "yaml",
            "yaml": "yaml",
            "json": "json",
            "js": "javascript",
            "ts": "typescript",
            "py": "python",
            "rb": "ruby",
            "go": "go",
            "rs": "rust",
            "swift": "swift",
            "kt": "kotlin",
            "java": "java",
            "c": "c",
            "h": "c",
            "cpp": "cpp",
            "hpp": "cpp",
            "cs": "csharp",
            "php": "php",
            "sql": "sql",
            "xml": "xml",
            "html": "html",
            "css": "css",
            "scss": "scss",
            "less": "less",
            "toml": "toml",
            "ini": "ini",
            "conf": "ini",
            "cfg": "ini",
            "txt": "plaintext",
        ]

        return extMap[ext] ?? ""
    }
}
