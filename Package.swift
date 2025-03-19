import PackageDescription

let package = Package(
    name: "RFIDReaderConnect",
    products: [
        .library(
            name: "RFIDReaderConnect",
            targets: ["RFIDReaderConnect"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "RFIDReaderConnect",
            url: "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution/releases/download/v1.0.0/RFIDReaderConnect.xcframework.zip",
            checksum: "b0b93cc80ac7e586576c77c35ba52e9fd8f12c2931a3b82e0d0892b66080d909"
        )
    ]
)
