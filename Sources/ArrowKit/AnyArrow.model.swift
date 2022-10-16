private enum AnyArrowKey: String, CodingKey {
    case arrow
    case help
}

public struct AnyArrow: Arrow, Decodable, Equatable {
    public static func == (lhs: AnyArrow, rhs: AnyArrow) -> Bool {
        return lhs.arrow == rhs.arrow && lhs.metadata.keys == rhs.metadata.keys
    }

    public let arrow: String
    public let help: String?
    public let metadata: [String: Any]

    public init(arrow: String, help: String? = nil, metadata: [String: Any] = [:]) {
        self.arrow = arrow
        var mutableMetadata = metadata
        mutableMetadata["arrow"] = arrow
        if let help = help {
            mutableMetadata["help"] = help
        }
        self.metadata = mutableMetadata
        self.help = help
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: AnyArrowKey.self) {
            arrow = try require(or: ArrowError.arrowDictMustContainArrow) {
                try container.decode(String.self, forKey: .arrow)
            }
            metadata = try [String: Any](from: decoder)
            if container.contains(.help) {
                help = try container.decode(String.self, forKey: .help)
            } else {
                help = nil
            }
        } else if let container = try? decoder.singleValueContainer() {
            let value = try require(or: ArrowError.arrowShorthandMustBeString) {
                try container.decode(String.self)
            }
            if !value.contains(" "), !value.starts(with: "."), value.split(separator: "/").count == 2 {
                arrow = value
                metadata = ["arrow": arrow]
            } else {
                arrow = "vknabel/BashArrow"
                metadata = ["arrow": arrow, "command": value]
            }
            help = nil
        } else {
            throw ArrowError.arrowRequiresStringOrDictWithArrow(
                decoder.codingPath,
                decoder.userInfo
            )
        }
    }

    public func fire(archerfile: Archerfile, arguments: [String]) throws {
        throw ArrowError.cannotFireAnyArrow(self, archerfile, arguments)
    }
}
