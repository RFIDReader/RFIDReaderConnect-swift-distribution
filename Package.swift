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
            url: "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution/raw/refs/heads/master/releases/download/v0.0.3/RFIDReaderConnect.xcframework.zip",
            checksum: "fa0c31e3969edac8de46393794cd57a26be41768daef40d46f5d2ff276fed85c"
        )
    ]
)
