import Foundation
import Testing
import IntlWireFormat
@testable import IntlWeb2

enum FixtureSupport {
    static func decode<T: Decodable>(_ name: String) throws -> T {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
            throw NSError(domain: "Fixture", code: 1)
        }
        return try JSONDecoder().decode(T.self, from: Data(contentsOf: url))
    }
}

@Test func decodesIntervalsSample() throws {
    let response: IntervalsResponse = try FixtureSupport.decode("intervals-sample")
    #expect(response.records.count == 1)
    #expect(response.cam == "CAM:1")

    let record = response.records[0]
    let expectedFrom = Timestamp.utc.date(from: "2024-01-15T00:00:00.000+00:00")
    let expectedTo = Timestamp.utc.date(from: "2024-01-15T12:00:00.000+00:00")
    #expect(record.from == expectedFrom)
    #expect(record.to == expectedTo)
    #expect(record.from < record.to)
}

@Test func intervalsFormatsTimeFromDate() {
    let from = Date(timeIntervalSince1970: 1_705_318_800)
    let to = Date(timeIntervalSince1970: 1_705_361_800)
    let request = ArchiveApi.intervals(
        camera: "CAM:1",
        from: from,
        to: to,
        limit: 100,
        offset: 0,
        splitThreshold: 300
    )
    #expect(request.query?.contains(where: { $0.0 == "time_from" && $0.1 == Timestamp.local.string(from: from) }) == true)
    #expect(request.query?.contains(where: { $0.0 == "time_to" && $0.1 == Timestamp.local.string(from: to) }) == true)
}

@Test func ptzMoveUsesObjectIDForCamId() {
    let request = PtzApi.move(camera: "CAM:1", telemetryId: "1.1", pan: 0, tilt: 1)
    #expect(request.query?.contains(where: { $0.0 == "cam.id" && $0.1 == "1" }) == true)
    #expect(request.query?.contains(where: { $0.0 == "command" && $0.1 == "UP" }) == true)
}

@Test func ptzStopOnZeroZoom() {
    #expect(PtzApi.ptzZoomCommand(value: 0) == "STOP")
    #expect(PtzApi.ptzZoomCommand(value: 1) == "ZOOM_IN")
}

@Test func pushRegistrationRoundTrip() throws {
    let original = PushRegistration(
        sandbox: .sandbox,
        bundleId: "com.example.app",
        deviceToken: "0000000000000000000000000000000000000000000000000000000000000000",
        serverId: 1,
        locale: "en",
        localeId: "en_US",
        serverName: "Test Server"
    )
    let data = try JSONEncoder().encode(original)
    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
    #expect(json?["os"] as? String == "iOS")
    #expect(json?["v"] as? Int == 1)
}

@Test func notificationApiPaths() {
    let unregister = NotificationApi.unregister(deviceId: "device-1")
    #expect(unregister.path == "secure/notifications/subscription/device-1")
    #expect(unregister.method == .delete)
}
