# LogCollector

Collet custom logs and process asynchronously and periodically.

## Usage

```swift

import LogCollector

let logCollector = LogCollector<CustomLog>() { logs in
    someApiClient.sendLogs(payloads: logs.map{ $0.payload() })
}

logCollector.storeLog(
    CustomLog(message: "Custom Log Message")
)
```
