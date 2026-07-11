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
            url: "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution/raw/refs/heads/master/releases/download/v0.0.2-test/RFIDReaderConnect.xcframework.zip",
            checksum: "ec3f262fed0a7df3c434dc2ccf1dec9481925795c5e29557c3c17afa7a4dc432"
        )
    ]
)
