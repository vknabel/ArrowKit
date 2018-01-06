private enum AnyArrowKey: String, CodingKey {
  case kind
  case help
}

public struct AnyArrow: Arrow, Decodable, Equatable {
  public static func ==(lhs: AnyArrow, rhs: AnyArrow) -> Bool {
    return lhs.arrow == rhs.arrow && lhs.metadata.keys == rhs.metadata.keys
  }

  public let arrow: String
  public let help: String?
  public let metadata: [String: Any]

  public init(arrow: String, help: String? = nil, metadata: [String: Any] = [:]) {
    self.arrow = arrow
    var mutableMetadata = metadata
    mutableMetadata["arrow"] = arrow
    self.metadata = mutableMetadata
    self.help = help
  }

  public init(from decoder: Decoder) throws {
    if let container = try? decoder.container(keyedBy: AnyArrowKey.self) {
      self.arrow = try require(or: ArrowError.adapterDictMustContainAdapter) {
        try container.decode(String.self, forKey: .kind)
      }
      self.metadata = try [String: Any](from: decoder)
      self.help = try container.decode(String.self, forKey: .help)
    } else if let container = try? decoder.singleValueContainer() {
      self.arrow = try require(or: ArrowError.adapterShorthandMustBeString) {
        try container.decode(String.self)
      }
      self.metadata = ["arrow": arrow]
      self.help = nil
    } else {
      throw ArrowError.adapterRequiresStringOrDictWithAdapter(
        decoder.codingPath,
        decoder.userInfo
      )
    }
  }

    public func fire(archerfile: Archerfile, arguments: [String]) throws {
        throw ArrowError.cannotFireAnyArrow(self, archerfile, arguments)
    }
}
