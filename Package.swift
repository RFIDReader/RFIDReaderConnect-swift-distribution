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
            checksum: "6603f98cd2e1f7b989ea67ac4bf10e33a9d6dfb1bcf8e8c6e1abb8db06b20a4e"
        )
    ]
)
