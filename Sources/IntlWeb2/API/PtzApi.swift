import Foundation
import IntlWireFormat
import RequestResponse

public enum PtzApi {
    private static let videoPath = "secure/video/action.do"
    private static let version = "4.10.0.0"

    public static func move(
        camera: AccessPoint,
        telemetryId: ObjectID,
        pan: Double,
        tilt: Double
    ) -> Request<Void> {
        let command = ptzMoveCommand(pan: pan, tilt: tilt)
        return ptzRequest(camera: camera, telemetryId: telemetryId, command: command)
    }

    public static func zoom(
        camera: AccessPoint,
        telemetryId: ObjectID,
        value: Double
    ) -> Request<Void> {
        let command = ptzZoomCommand(value: value)
        return ptzRequest(camera: camera, telemetryId: telemetryId, command: command)
    }

    private static func ptzRequest(
        camera: AccessPoint,
        telemetryId: ObjectID,
        command: String
    ) -> Request<Void> {
        guard let camID = camera.accessPointObjectId else {
            preconditionFailure("camera access point must include object id")
        }
        let query: [(String, String?)] = [
            ("version", version),
            ("sessionid", String(Date().timeIntervalSinceReferenceDate)),
            ("cam.id", camID),
            ("target", "PTZ"),
            ("targetid", telemetryId),
            ("command", command),
            ("speed", "5"),
        ]
        return Request(path: videoPath, method: .get, query: query, id: "ptz")
    }

    static func ptzMoveCommand(pan: Double, tilt: Double) -> String {
        if pan == 0, tilt == 0 { return "STOP" }
        if abs(pan) > abs(tilt) {
            return pan < 0 ? "LEFT" : "RIGHT"
        }
        return tilt > 0 ? "UP" : "DOWN"
    }

    static func ptzZoomCommand(value: Double) -> String {
        if value == 0 { return "STOP" }
        return value > 0 ? "ZOOM_IN" : "ZOOM_OUT"
    }
}
