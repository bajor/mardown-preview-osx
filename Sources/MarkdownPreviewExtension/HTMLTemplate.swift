import Foundation

public struct HTMLTemplate {

    public static func wrap(body: String, title: String = "") -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>\(title)</title>
            <style>
                :root {
                    --bg-color: #ffffff;
                    --text-color: #24292e;
                    --code-bg: #f6f8fa;
                    --border-color: #e1e4e8;
                    --link-color: #0366d6;
                    --blockquote-color: #6a737d;
                    --heading-color: #24292e;
                    --table-stripe: #f6f8fa;
                }

                @media (prefers-color-scheme: dark) {
                    :root {
                        --bg-color: #0d1117;
                        --text-color: #c9d1d9;
                        --code-bg: #161b22;
                        --border-color: #30363d;
                        --link-color: #58a6ff;
                        --blockquote-color: #8b949e;
                        --heading-color: #c9d1d9;
                        --table-stripe: #161b22;
                    }
                }

                * {
                    box-sizing: border-box;
                }

                body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
                    font-size: 14px;
                    line-height: 1.6;
                    color: var(--text-color);
                    background-color: var(--bg-color);
                    padding: 24px;
                    margin: 0;
                    max-width: 900px;
                }

                h1, h2, h3, h4, h5, h6 {
                    color: var(--heading-color);
                    margin-top: 24px;
                    margin-bottom: 16px;
                    font-weight: 600;
                    line-height: 1.25;
                }

                h1 { font-size: 2em; padding-bottom: 0.3em; border-bottom: 1px solid var(--border-color); }
                h2 { font-size: 1.5em; padding-bottom: 0.3em; border-bottom: 1px solid var(--border-color); }
                h3 { font-size: 1.25em; }
                h4 { font-size: 1em; }
                h5 { font-size: 0.875em; }
                h6 { font-size: 0.85em; color: var(--blockquote-color); }

                h1:first-child, h2:first-child, h3:first-child {
                    margin-top: 0;
                }

                p {
                    margin: 0 0 16px 0;
                }

                a {
                    color: var(--link-color);
                    text-decoration: none;
                }

                a:hover {
                    text-decoration: underline;
                }

                code {
                    font-family: "SF Mono", Menlo, Monaco, Consolas, monospace;
                    font-size: 0.9em;
                    background-color: var(--code-bg);
                    padding: 0.2em 0.4em;
                    border-radius: 6px;
                }

                pre {
                    background-color: var(--code-bg);
                    padding: 16px;
                    overflow-x: auto;
                    border-radius: 6px;
                    border: 1px solid var(--border-color);
                    margin: 16px 0;
                }

                pre code {
                    background-color: transparent;
                    padding: 0;
                    border-radius: 0;
                    font-size: 0.85em;
                    line-height: 1.45;
                }

                blockquote {
                    margin: 16px 0;
                    padding: 0 1em;
                    color: var(--blockquote-color);
                    border-left: 4px solid var(--border-color);
                }

                blockquote p {
                    margin: 0;
                }

                table {
                    border-collapse: collapse;
                    width: 100%;
                    margin: 16px 0;
                }

                th, td {
                    padding: 8px 13px;
                    border: 1px solid var(--border-color);
                    text-align: left;
                }

                th {
                    font-weight: 600;
                    background-color: var(--code-bg);
                }

                tr:nth-child(even) {
                    background-color: var(--table-stripe);
                }

                img {
                    max-width: 100%;
                    height: auto;
                }

                hr {
                    border: none;
                    height: 1px;
                    background-color: var(--border-color);
                    margin: 24px 0;
                }

                ul, ol {
                    padding-left: 2em;
                    margin: 16px 0;
                }

                li {
                    margin: 4px 0;
                }

                li > ul, li > ol {
                    margin: 0;
                }

                li > p {
                    margin: 0;
                }

                /* Checkbox lists */
                li input[type="checkbox"] {
                    margin-right: 8px;
                }

                /* Syntax Highlighting - GitHub-inspired */
                .hljs {
                    color: var(--text-color);
                    background: var(--code-bg);
                }

                @media (prefers-color-scheme: light) {
                    .hljs-comment, .hljs-quote { color: #6a737d; }
                    .hljs-keyword, .hljs-selector-tag { color: #d73a49; }
                    .hljs-string, .hljs-attr { color: #032f62; }
                    .hljs-number, .hljs-literal { color: #005cc5; }
                    .hljs-variable, .hljs-template-variable { color: #e36209; }
                    .hljs-type, .hljs-built_in { color: #6f42c1; }
                    .hljs-title, .hljs-function { color: #6f42c1; }
                    .hljs-name, .hljs-tag { color: #22863a; }
                    .hljs-attribute { color: #005cc5; }
                    .hljs-symbol, .hljs-bullet { color: #005cc5; }
                    .hljs-addition { color: #22863a; background-color: #f0fff4; }
                    .hljs-deletion { color: #b31d28; background-color: #ffeef0; }
                }

                @media (prefers-color-scheme: dark) {
                    .hljs-comment, .hljs-quote { color: #8b949e; }
                    .hljs-keyword, .hljs-selector-tag { color: #ff7b72; }
                    .hljs-string, .hljs-attr { color: #a5d6ff; }
                    .hljs-number, .hljs-literal { color: #79c0ff; }
                    .hljs-variable, .hljs-template-variable { color: #ffa657; }
                    .hljs-type, .hljs-built_in { color: #d2a8ff; }
                    .hljs-title, .hljs-function { color: #d2a8ff; }
                    .hljs-name, .hljs-tag { color: #7ee787; }
                    .hljs-attribute { color: #79c0ff; }
                    .hljs-symbol, .hljs-bullet { color: #79c0ff; }
                    .hljs-addition { color: #aff5b4; background-color: rgba(46, 160, 67, 0.15); }
                    .hljs-deletion { color: #ffdcd7; background-color: rgba(248, 81, 73, 0.15); }
                }
            </style>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css" media="(prefers-color-scheme: light)">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css" media="(prefers-color-scheme: dark)">
            <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
        </head>
        <body>
            \(body)
            <script>hljs.highlightAll();</script>
        </body>
        </html>
        """
    }
}
