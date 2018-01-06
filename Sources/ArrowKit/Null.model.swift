public struct Null: Codable, Equatable {
  public init() {}
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    guard container.decodeNil() else {
      throw ArrowError.couldNotDecodeValue(decoder.codingPath, decoder.userInfo)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encodeNil()
  }

  public static func == (lhs: Null, rhs: Null) -> Bool {
    return true
  }
}
