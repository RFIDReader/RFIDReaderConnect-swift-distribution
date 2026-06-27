// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "RFIDReaderConnect",
    platforms: [
        .macOS(.v13), .iOS(.v13)
    ],
    products: [
        .library(
            name: "RFIDReaderConnect",
            targets: ["RFIDReaderConnect"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "RFIDReaderConnect",
            url: "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution/raw/refs/heads/master/releases/download/v0.0.1-test/RFIDReaderConnect.xcframework.zip",
            checksum: "33d4fb8a530a100476508872318426a1f81704d408f8714c95ffa8dcdcbf2c0a"
        )
    ]
)
