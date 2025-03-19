import PackageDescription

let package = Package(
    name: "RFIDReaderConnect",
    platforms: [
        .macOS(.v13_0), .iOS(v13_0)
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
            url: "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution/raw/refs/heads/master/releases/download/v1.0.0/RFIDReaderConnect.xcframework.zip",
            checksum: "2adb2ec08ec35f8a8b50cd88ec6b484a7582688c11655c2463b148ac4a84cab3"
        )
//        .executableTarget(
//            name: "RFIDReaderConnectTest",
//            dependencies: ["RFIDReaderConnect"],
//            path: "RFIDReaderConnectTest"
//        )
    ]
)
