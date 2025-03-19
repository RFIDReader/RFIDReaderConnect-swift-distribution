Pod::Spec.new do |spec|
    spec.name          = "RFIDReaderConnect"
    spec.version       = "1.0.0"
    spec.summary       = "A multiplatform framework."
    spec.homepage      = "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution"
    spec.license       = { :type => "MIT", :file => "LICENSE" }
    spec.author        = { "Pratham Jaiswal" => "pr47h4m@gmail.com" }
    spec.source       = { :http => "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution/raw/refs/heads/master/releases/download/v1.0.0/RFIDReaderConnect.xcframework.zip" }
    spec.vendored_frameworks = "RFIDReaderConnect.xcframework"
    spec.platforms     = { :ios => "13.0" }
end
