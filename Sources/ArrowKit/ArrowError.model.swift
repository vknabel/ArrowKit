public protocol ExitCodeError {
    var code: Int { get }
}

public enum ArrowError: Error, CustomStringConvertible {
    case notEnoughArguments(got: [String], expectedAtLeast: Int)
    case invalidApiLevel(got: String, expected: Range<Int>)
    case couldNotReadDataFromInput
    case invalidArcherfileFormat(Error)
    case invalidScriptFormat(Error)
    case cannotFireAnyArrow(AnyArrow, Archerfile, [String])

    case mustBeDictionary(Error)
    case scriptsRequired(Error)

    case arrowShorthandMustBeString(Error)
    case arrowDictMustContainArrow(Error)
    case arrowRequiresStringOrDictWithArrow([CodingKey], [CodingUserInfoKey: Any])

    case metadataMustBeADictionary(Error)

    case couldNotDecodeValue([CodingKey], [CodingUserInfoKey: Any]?)

    public var description: String {
        switch self {
        case let .notEnoughArguments(arguments, expectedAmount):
            return "Not enough arguments: expected \(expectedAmount), got \(arguments.count)"
        case let .invalidApiLevel(got, expectedRange):
            return "Incompatable Archery API: expected \(expectedRange.lowerBound)..<\(expectedRange.upperBound), got \(got)"
        case .couldNotReadDataFromInput:
            return "Invalid Archerfile or Script data"
        case let .invalidArcherfileFormat(error):
            return "Invalid Archerfile: \(error)"
        case let .invalidScriptFormat(error):
            return "Invalid Script: \(error)"
        case let .cannotFireAnyArrow(anyArrow, _, _):
            return "AnyArrows may not be fired: \(anyArrow)"
        case let .mustBeDictionary(error):
            return "Parsing error: expected dictionary, \(error)"
        case let .scriptsRequired(error):
            return "Parsing error: expected scripts tag, \(error)"
        case let .arrowShorthandMustBeString(error):
            return "Parsing error: expected arrow string shorthand or object, \(error)"
        case let .arrowDictMustContainArrow(error):
            return "Parsing error: arrow metadata must contain arrow, \(error)"
        case let .arrowRequiresStringOrDictWithArrow(path, _):
            return "Parsing error: arrow must be a string or dictionary at \(path)"
        case let .metadataMustBeADictionary(error):
            return "Parsing error: metadata must be a dictionary, \(error)"
        case let .couldNotDecodeValue(path, _):
            return "Parsing error: \(path)"
        }
    }
}

internal func require<T>(or fail: (Error) -> Error, _ value: () throws -> T) throws -> T {
    do {
        return try value()
    } catch {
        throw fail(error)
    }
}
