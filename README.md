# SQNetworkLogger

## Installation

SPM:
```swift
.package(url: "https://github.com/sequenia/SQNetworkLogger.git", .upToNextMajor(from: "0.3.0"))
```

## Usage

```swift
// 1. Initialize plugin 
let plugin = SQNetworkLoggerPlugin(isActive: true, limit: 50)

// 2. Add the plugin to the provider
let provider = MoyaProvider<SomeMoyaProvider>(plugins: [plugin])

// 3. Launch provider's method
provider.request(.someProviderAction) { result in
    // Processing result
}

// 4. Open NetworkLoggerTable and view log of requests
let controller = NetworkLoggerTableViewController.loggerScreen
self.present(controller, animated: true, completion: nil)
```
