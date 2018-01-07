import Foundation

extension NSError: ExitCodeError {}

public extension Arrow {
    public static func fire(supportedApiLevels: Range<Int> = Self.supportedApiLevels, arguments: [String] = Array(CommandLine.arguments.dropFirst())) -> Never {
        do {
            try Self.shoot(supportedApiLevels: supportedApiLevels, arguments: arguments)
            exit(0)
        } catch let error as ExitCodeError {
            print("💥  \(error)")
            exit(Int32(error.code))
        } catch {
            print("💥  \(error)")
            exit(1)
        }
    }

    public static func shoot(supportedApiLevels: Range<Int>, arguments: [String]) throws {
        let minimumArguments = 3
            guard arguments.count >= minimumArguments else {
                throw ArrowError.notEnoughArguments(got: arguments, expectedAtLeast: minimumArguments)
            }
            guard let apiLevel = Int(arguments[0]), supportedApiLevels.contains(apiLevel) else {
                throw ArrowError.invalidApiLevel(got: arguments[0], expected: supportedApiLevels)
            }
        return try shoot(
            archerfileContents: arguments[1],
            arrowContents: arguments[2],
            arguments: Array(arguments.dropFirst(minimumArguments))
        )
    }

    public static func shoot(archerfileContents: String, arrowContents: String, arguments: [String]) throws {
        guard let archerfileData = archerfileContents.data(using: .utf8), let scriptData = arrowContents.data(using: .utf8) else {
            throw ArrowError.couldNotReadDataFromInput
        }
        let archerfile = try parseArcherfile(from: archerfileData)
        let arrow = try parseArrow(from: scriptData)
        let options = try parseExecutionOptions(from: scriptData)
        let invocationPrefix = options.shouldPassArrowParameters
                ? [String(Self.supportedApiLevels.upperBound - 1), archerfileContents, arrowContents]
                : []
        return try arrow.fire(
            archerfile: archerfile,
            arguments: invocationPrefix + arguments
        )
    }

    private static func parseArcherfile(from data: Data) throws -> Archerfile {
        return try require(
            or: ArrowError.invalidArcherfileFormat,
            { try JSONDecoder().decode(Archerfile.self, from: data) }
        )
    }

    private static func parseArrow(from data: Data) throws -> Self {
        return try require(
            or: ArrowError.invalidScriptFormat,
            { try JSONDecoder().decode(Self.self, from: data) }
        )
    }

    private static func parseExecutionOptions(from data: Data) throws -> ExecutionOptions {
        return try require(
            or: ArrowError.invalidScriptFormat,
            { try JSONDecoder().decode(ExecutionOptions.self, from: data) }
        )
    }
}
