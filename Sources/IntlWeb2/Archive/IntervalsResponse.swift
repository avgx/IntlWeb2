import Foundation
import IntlWireFormat

public struct IntervalsResponse: Decodable, Sendable {
    public let count: Int
    public let complete: String
    public let sort: String
    public let cam: String
    public let records: [IntervalsRecord]
}

public struct IntervalsRecord: Decodable, Sendable {
    public let from: Date
    public let to: Date

    private enum CodingKeys: String, CodingKey {
        case from, to
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        from = try Self.date(from: try container.decode(String.self, forKey: .from), field: "from")
        to = try Self.date(from: try container.decode(String.self, forKey: .to), field: "to")
    }

    private static func date(from string: String, field: String) throws -> Date {
        guard let date = Timestamp.utc.date(from: string) ?? Timestamp.local.date(from: string) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Invalid Intellect timestamp in \(field): \(string)"
                )
            )
        }
        return date
    }
}
