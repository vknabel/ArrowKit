public protocol ExitCodeError {
    var code: Int { get }
}

public enum ArrowError: Error {
    case notEnoughArguments(got: [String], expectedAtLeast: Int)
    case invalidApiLevel(got: String, expected: Range<Int>)
    case couldNotReadDataFromInput
    case invalidArcherfileFormat(Error)
    case invalidScriptFormat(Error)
    case cannotFireAnyArrow(AnyArrow, Archerfile, [String])

    case arrowNotFound(named: String)

    case mustBeDictionary(Error)
    case generateRequired(Error)

    case adapterShorthandMustBeString(Error)
    case adapterDictMustContainAdapter(Error)
    case adapterRequiresStringOrDictWithAdapter([CodingKey], [CodingUserInfoKey: Any])

    case collectMustBeADictionary(Error)
    case createMustBeADictionary(Error)
    case metadataMustBeADictionary(Error)

    case couldNotDecodeValue([CodingKey], [CodingUserInfoKey: Any]?)

    case couldNotDecodeArray([CodingKey], [CodingUserInfoKey: Any])
}

internal func require<T>(or fail: (Error) -> Error, _ value: () throws -> T) throws -> T {
    do {
        return try value()
    } catch {
        throw fail(error)
    }
}
