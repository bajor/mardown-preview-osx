// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MarkdownPreview",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MarkdownPreviewLib",
            type: .static,
            targets: ["MarkdownPreviewLib"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Ink.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "MarkdownPreviewLib",
            dependencies: ["Ink"],
            path: "Sources/MarkdownPreviewExtension"
        )
    ]
)
