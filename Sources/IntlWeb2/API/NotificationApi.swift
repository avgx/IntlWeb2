import Foundation
import RequestResponse

public enum NotificationApi {
    public static func register(_ registration: PushRegistration) -> Request<Void> {
        Request(path: "secure/notifications/subscription", method: .post, body: registration)
    }

    public static func unregister(deviceId: String) -> Request<Void> {
        Request(path: "secure/notifications/subscription/\(deviceId)", method: .delete)
    }

    public static func test(_ message: PushTest) -> Request<Void> {
        Request(path: "secure/notifications/test", method: .post, body: message)
    }
}
