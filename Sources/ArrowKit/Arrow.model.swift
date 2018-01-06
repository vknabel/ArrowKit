public protocol Arrow: Decodable {
  var arrow: String { get }
  var help: String? { get }

func fire(archerfile: Archerfile, arguments: [String]) throws
}
