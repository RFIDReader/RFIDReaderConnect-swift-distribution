import Foundation
import HeliosSDK

final class ConsumerDelegate: RFIDReaderDelegate {
    func rfidReaderDidConnect() {}
    func rfidReaderDidBecomeReady() {}
    func rfidReaderDidDisconnect() {}
    func rfidReaderDidStartScanning() {}
    func rfidReaderDidStopScanning() {}
    func rfidReaderDidReadTag(tag: RFIDTag) {}
    func rfidReaderDidReceiveMessage(message: Any) {}
    func rfidReaderDidEncounteredError(error: any Error) {}
    func rfidReaderDidReceiveRawData(_ data: Data) {}
}

let reader = RFIDReader(.mark3HH7, "Binary compatibility test", transport: .wifi(host: "127.0.0.1", mode: .tcp), delegate: ConsumerDelegate())
reader.getVersion()
reader.startAsyncInventory(metadata: [.returnRSSI, .returnTimestamp])
precondition(!reader.isScanning)
print("HeliosSDK public binary API loaded")
