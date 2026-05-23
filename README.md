# IntlWeb2

Swift package for archive intervals, PTZ control, and push notification registration. HTTP descriptors use [RequestResponse](https://github.com/avgx/RequestResponse); `AccessPoint`, `ObjectID`, and timestamps come from [IntlWireFormat](https://github.com/avgx/IntlWireFormat).

For configuration and cameras, see [IntlConfiguration](https://github.com/avgx/IntlConfiguration). For snapshots and streams, see [IntlJpeg](https://github.com/avgx/IntlJpeg).

## Project layout

```
Sources/IntlWeb2/
├── API/              ArchiveApi, PtzApi, NotificationApi
├── Archive/          IntervalsResponse
└── Push/             PushRegistration, PushTest

Tests/IntlWeb2Tests/
├── Resources/        JSON fixtures
└── IntlWeb2Tests.swift
```

## Requirements

- Swift 6.1+
- iOS 15+, macOS 13+, tvOS 17+, visionOS 1+

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/avgx/IntlWeb2", from: "1.0.0"),
],
targets: [
    .target(name: "MyApp", dependencies: ["IntlWeb2"]),
]
```

## Quick start

```swift
import IntlWeb2
import RequestResponse

let intervals: IntervalsResponse = try await http.send(
    ArchiveApi.intervals(
        camera: "CAM:1",
        from: beginDate,
        to: endDate,
        limit: 100,
        offset: 0,
        splitThreshold: 300
    )
).value

try await http.send(
    PtzApi.move(camera: "CAM:1", telemetryId: "1", pan: -1, tilt: 0)
)

try await http.send(
    NotificationApi.register(
        PushRegistration(
            sandbox: .sandbox,
            bundleId: "com.example.app",
            deviceToken: "…",
            serverId: 1,
            locale: "en",
            localeId: "en_US",
            serverName: "Server"
        )
    )
)
```

## HTTP API descriptors

| Enum | Method | Path |
|------|--------|------|
| `ArchiveApi` | `intervals(...)` | `GET secure/video/action.do` — `command=arc.intervals`, `format=json` |
| `ArchiveApi` | `intervalsLegacy(...)` | Same without `format=json` (deprecated) |
| `ArchiveApi` | `depth(camera:)` | Full-range intervals query for archive depth |
| `PtzApi` | `move(camera:telemetryId:pan:tilt:)` | `GET secure/video/action.do` — PTZ direction or STOP |
| `PtzApi` | `zoom(camera:telemetryId:value:)` | `GET secure/video/action.do` — ZOOM_IN / ZOOM_OUT / STOP |
| `NotificationApi` | `register(_:)` | `POST secure/notifications/subscription` |
| `NotificationApi` | `unregister(deviceId:)` | `DELETE secure/notifications/subscription/{deviceId}` |
| `NotificationApi` | `test(_:)` | `POST secure/notifications/test` |

PTZ uses `cam.id` = camera `accessPointObjectId`. Push payloads include fixed `os=iOS` and `v=1` on encode.


## Tests

```bash
swift test
```

## License

See [LICENSE](LICENSE).
