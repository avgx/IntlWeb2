import Foundation

public enum ApplePushEnvironment: Int, Codable, Sendable {
    case prod = 0
    case sandbox = 1
}

public struct PushRegistration: Encodable, Sendable, Equatable {
    public let sandbox: ApplePushEnvironment
    public let bundleId: String
    public let deviceToken: String
    public let serverId: Int
    public let locale: String
    public let localeId: String
    public let serverName: String
    public let timezone: String?
    public let user: String?

    public init(
        sandbox: ApplePushEnvironment,
        bundleId: String,
        deviceToken: String,
        serverId: Int,
        locale: String,
        localeId: String,
        serverName: String,
        timezone: String? = nil,
        user: String? = nil
    ) {
        self.sandbox = sandbox
        self.bundleId = bundleId
        self.deviceToken = deviceToken
        self.serverId = serverId
        self.locale = locale
        self.localeId = localeId
        self.serverName = serverName
        self.timezone = timezone
        self.user = user
    }

    private enum CodingKeys: String, CodingKey {
        case os, v, sandbox, bundleId, deviceToken, serverId, locale, localeId, serverName, timezone, user
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("iOS", forKey: .os)
        try container.encode(1, forKey: .v)
        try container.encode(sandbox, forKey: .sandbox)
        try container.encode(bundleId, forKey: .bundleId)
        try container.encode(deviceToken, forKey: .deviceToken)
        try container.encode(serverId, forKey: .serverId)
        try container.encode(locale, forKey: .locale)
        try container.encode(localeId, forKey: .localeId)
        try container.encode(serverName, forKey: .serverName)
        try container.encodeIfPresent(timezone, forKey: .timezone)
        try container.encodeIfPresent(user, forKey: .user)
    }
}

public struct PushTest: Encodable, Sendable, Equatable {
    public let sandbox: ApplePushEnvironment
    public let bundleId: String
    public let deviceToken: String
    public let serverId: Int

    public init(
        sandbox: ApplePushEnvironment,
        bundleId: String,
        deviceToken: String,
        serverId: Int
    ) {
        self.sandbox = sandbox
        self.bundleId = bundleId
        self.deviceToken = deviceToken
        self.serverId = serverId
    }

    private enum CodingKeys: String, CodingKey {
        case os, v, sandbox, bundleId, deviceToken, serverId
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("iOS", forKey: .os)
        try container.encode(1, forKey: .v)
        try container.encode(sandbox, forKey: .sandbox)
        try container.encode(bundleId, forKey: .bundleId)
        try container.encode(deviceToken, forKey: .deviceToken)
        try container.encode(serverId, forKey: .serverId)
    }
}
