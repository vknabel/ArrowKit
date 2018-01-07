public protocol Arrow: Decodable {
  func fire(archerfile: Archerfile, arguments: [String]) throws
}
