# HeliosSDK for Apple platforms

> Reader communication preview: **0.0.4-rc.541bf13c**. The [artifact provenance](artifact-provenance.json) records immutable source revisions, checksums, and verification. Run `make verify` to check the packaged binary.


HeliosSDK is the supported Swift SDK for discovering, connecting to,
configuring, and reading tags from RFIDReader hardware on iPhone, iPad, and
Mac. This distribution repository contains the compiled XCFramework, Swift
Package manifest, CocoaPods specification, and hosted API documentation.

> Current release: **0.0.3** · Minimum deployment: **iOS 13 / macOS 13**

## Start here

| Resource | Link |
| --- | --- |
| API reference | [Browse HeliosSDK documentation](docs/index.html) |
| Swift Package | `https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution` |
| Binary archive | [HeliosSDK.xcframework.zip](releases/download/v0.0.3/HeliosSDK.xcframework.zip) |
| License | [HeliosSDK License Agreement](LICENSE) |

## Install with Swift Package Manager

In Xcode, choose **File → Add Package Dependencies**, enter:

```text
https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution
```

Select the `HeliosSDK` product and add it to your application target.
For a package manifest, use:

```swift
dependencies: [
    .package(
        url: "https://github.com/RFIDReader/RFIDReaderConnect-swift-distribution",
        branch: "master"
    )
]
```

When declaring the dependency on a target, reference the product explicitly:

```swift
.product(name: "HeliosSDK", package: "HeliosSDK-swift-distribution")
```

Then `import HeliosSDK` in your Swift sources.

The `master` branch always points at the latest published binary. Pin a commit
in production if your release process requires reproducible dependencies.

## Install with CocoaPods

Reference the hosted podspec directly until the SDK is published to a specs
registry:

```ruby
platform :ios, '13.0'

target 'MyApp' do
  use_frameworks!
  pod 'HeliosSDK', :podspec => 'https://raw.githubusercontent.com/RFIDReader/RFIDReaderConnect-swift-distribution/master/HeliosSDK.podspec'
end
```

Then run `pod install` and open the generated workspace.

## Manual installation

1. Download and unzip [HeliosSDK.xcframework.zip](releases/download/v0.0.3/HeliosSDK.xcframework.zip).
2. Drag `HeliosSDK.xcframework` into the Xcode project.
3. Add it to the application target under **Frameworks, Libraries, and Embedded Content**.
4. Select **Embed & Sign** for an application target.

## Recommended application architecture

Keep platform discovery, SDK ownership, and UI state separate:

- A CoreBluetooth scanner discovers peripherals. The SDK intentionally does
  not own the system permission or discovery UI.
- One observable store owns the active `RFIDReader` for its full lifecycle.
- One delegate translates SDK callbacks into application state on the main
  queue.
- Views send commands through the store and render published state. They do
  not parse reader messages directly.

This is the same pattern used by the reference application.

### 1. Create a reader store and delegate

```swift
import Combine
import CoreBluetooth
import HeliosSDK

final class ReaderStore: ObservableObject, RFIDReaderDelegate {
    @Published private(set) var isConnected = false
    @Published private(set) var isScanning = false
    @Published private(set) var tags: [RFIDTag] = []
    @Published private(set) var lastError: Error?

    private(set) var reader: RFIDReader?

    func connect(to peripheral: CBPeripheral) {
        reader?.disconnect()
        reader = RFIDReader(
            .mark3HH7,
            peripheral.name,
            transport: .ble(
                identifier: peripheral.identifier.uuidString,
                connectionTimeout: 30,
                maxRetries: 1,
                retryInterval: 5
            ),
            delegate: self
        )
        reader?.connect()
    }

    func disconnect() {
        reader?.disconnect()
    }

    func rfidReaderDidConnect() {
        DispatchQueue.main.async { self.isConnected = true }
    }

    func rfidReaderDidBecomeReady() {
        DispatchQueue.main.async { self.isConnected = true }
    }

    func rfidReaderDidDisconnect() {
        DispatchQueue.main.async {
            self.isConnected = false
            self.isScanning = false
        }
    }

    func rfidReaderDidStartScanning() {
        DispatchQueue.main.async { self.isScanning = true }
    }

    func rfidReaderDidStopScanning() {
        DispatchQueue.main.async { self.isScanning = false }
    }

    func rfidReaderDidReadTag(tag: RFIDTag) {
        DispatchQueue.main.async { self.tags.append(tag) }
    }

    func rfidReaderDidReceiveMessage(message: Any) {
        // Route typed configuration responses to the relevant app state.
    }

    func rfidReaderDidEncounteredError(error: Error) {
        DispatchQueue.main.async { self.lastError = error }
    }
}
```

Create the store once at the application boundary, not inside a transient
screen:

```swift
@main
struct MyRFIDApp: App {
    @StateObject private var readerStore = ReaderStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(readerStore)
        }
    }
}
```

### 2. Discover BLE readers

CoreBluetooth may still be in `.unknown` when a screen first appears. Preserve
the user's request to scan and start discovery from
`centralManagerDidUpdateState` once Bluetooth becomes `.poweredOn`; otherwise
an initial scan can appear to do nothing.

```swift
final class ReaderScanner: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published private(set) var peripherals: [CBPeripheral] = []
    private lazy var central = CBCentralManager(delegate: self, queue: .main)
    private var scanRequested = false

    func start() {
        scanRequested = true
        peripherals.removeAll()
        scanWhenReady()
    }

    func stop() {
        scanRequested = false
        central.stopScan()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        scanWhenReady()
    }

    private func scanWhenReady() {
        guard scanRequested, central.state == .poweredOn else { return }
        central.scanForPeripherals(withServices: nil)
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        guard peripheral.name != nil,
              !peripherals.contains(where: { $0.identifier == peripheral.identifier }) else { return }
        peripherals.append(peripheral)
    }
}
```

Retain the scanner for as long as discovery is needed and stop it before
connecting to the selected peripheral.

### 3. Start and stop inventory

Commands are asynchronous. Results and state changes arrive through
`RFIDReaderDelegate`:

```swift
readerStore.reader?.startAsyncInventory(
    metadata: [.returnRSSI, .returnTimestamp, .returnReadCount]
)

readerStore.reader?.stopAsyncInventory()
```

Use `rfidReaderDidReadTag`, `rfidReaderDidStartScanning`, and
`rfidReaderDidStopScanning` as the authoritative notification stream instead
of guessing command completion in the UI.

### Wi-Fi connection

For a reader reachable by hostname or IP address:

```swift
let reader = RFIDReader(
    .mark3HH7,
    "Warehouse Reader",
    transport: .wifi(
        host: "rfidreader.local",
        httpPort: "80",
        tcpPort: "81",
        udpPort: "82",
        mode: .tcp
    ),
    delegate: readerDelegate
)
reader.connect()
```

Keep a strong reference to both the reader and its delegate for the complete
connection lifecycle.

## Platform permissions

Add usage descriptions appropriate to the transports your application uses:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Connect to nearby RFID readers.</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Connect to RFID readers on your local network.</string>
```

For a sandboxed macOS application, enable **App Sandbox → Bluetooth** and
**Outgoing Connections (Client)**. Applications using `.local` discovery may
also need the relevant Bonjour service declarations.

## Connection lifecycle guidelines

- Construct one `RFIDReader` for the selected transport and retain it.
- Wait for `rfidReaderDidBecomeReady()` before sending configuration or
  inventory commands.
- Dispatch UI mutations to the main queue from delegate callbacks.
- Stop BLE discovery before connecting.
- Call `disconnect()` when replacing a reader or ending the session.
- Treat delegate callbacks—not button taps—as the source of truth for
  connection and scanning state.

## Troubleshooting

### BLE discovery does not start on first appearance

`CBCentralManager` initializes asynchronously. Queue the scan intent while its
state is `.unknown`, then begin scanning when the state callback reports
`.poweredOn`, as shown above.

### The reader connects but commands fail immediately

Wait for `rfidReaderDidBecomeReady()`. A transport connection can be established
before reader initialization has completed.

### Local Wi-Fi hostnames do not resolve

Confirm Local Network permission, the reader and Apple device are on the same
network, and the app's sandbox allows outgoing connections.

## Documentation and support

The generated symbol reference is available under [docs](docs/index.html).
When reporting an integration issue, include the Apple platform and version,
Xcode version, reader model, transport, firmware version, and the delegate
error description.

Use of the SDK is governed by the [HeliosSDK License Agreement](LICENSE).
