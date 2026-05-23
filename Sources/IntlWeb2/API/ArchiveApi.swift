import Foundation
import IntlWireFormat
import RequestResponse

public enum ArchiveApi {
    private static let videoPath = "secure/video/action.do"
    private static let version = "4.10.0.0"
    private static let tenYearsInSeconds = 315_360_000

    public static func intervals(
        camera: AccessPoint,
        from beginTime: Date,
        to endTime: Date,
        limit: Int,
        offset: Int,
        splitThreshold: Int
    ) -> Request<IntervalsResponse> {
        precondition(camera.objectClass == "CAM", "camera must be CAM:N access point")
        let query: [(String, String?)] = [
            ("command", "arc.intervals"),
            ("video_in", camera),
            ("offset", String(offset)),
            ("max_count", String(limit)),
            ("time_from", Timestamp.local.string(from: beginTime)),
            ("time_to", Timestamp.local.string(from: endTime)),
            ("split_threshold", String(splitThreshold)),
            ("format", "json"),
            ("version", version),
            ("sessionid", UUID().uuidString),
        ]
        return Request(path: videoPath, method: .get, query: query, id: "intervals")
    }

    @available(*, deprecated, message: "Use intervals without format=json for legacy servers")
    public static func intervalsLegacy(
        camera: AccessPoint,
        from beginTime: Date,
        to endTime: Date,
        limit: Int,
        offset: Int,
        splitThreshold: Int
    ) -> Request<IntervalsResponse> {
        precondition(camera.objectClass == "CAM", "camera must be CAM:N access point")
        let query: [(String, String?)] = [
            ("command", "arc.intervals"),
            ("video_in", camera),
            ("offset", String(offset)),
            ("max_count", String(limit)),
            ("time_from", Timestamp.local.string(from: beginTime)),
            ("time_to", Timestamp.local.string(from: endTime)),
            ("split_threshold", String(splitThreshold)),
            ("version", version),
            ("sessionid", UUID().uuidString),
        ]
        return Request(path: videoPath, method: .get, query: query, id: "intervalsLegacy")
    }

    public static func depth(camera: AccessPoint) -> Request<IntervalsResponse> {
        intervals(
            camera: camera,
            from: Date(timeIntervalSince1970: 946_684_800), // 2000-01-01
            to: Date(timeIntervalSince1970: 2_147_483_647), // 2038-01-19
            limit: 10,
            offset: 0,
            splitThreshold: tenYearsInSeconds
        )
    }
}
