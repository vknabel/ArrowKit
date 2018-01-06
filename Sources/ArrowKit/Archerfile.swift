private enum ArcherfileKey: String, CodingKey {
  case scripts = "scripts"
  case metadata
}

public struct Archerfile: Decodable {
  public let scripts: [String: AnyArrow]
  public let metadata: [String: Any]

  public init(from decoder: Decoder) throws {
    let container = try require(or: ArrowError.mustBeDictionary) {
      try decoder.container(keyedBy: ArcherfileKey.self)
    }

    if container.contains(.scripts) {
        scripts = try require(or: ArrowError.generateRequired) {
            try container.decode([String: AnyArrow].self, forKey: .scripts)
        }
    } else {
        scripts = [:]
    }

    metadata = try require(or: ArrowError.metadataMustBeADictionary) {
      try [String: Any](from: decoder)
    }
  }
}
