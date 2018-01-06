import XCTest
@testable import ArrowKit

class ArrowKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let data = """
        {"arrow":"x","array":[""]}
        """.data(using: .utf8)!
        JSONDecoder().decode(AnyArrow.self, data)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
