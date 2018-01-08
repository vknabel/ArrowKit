import XCTest
@testable import ArrowKit

class ArrowKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let data = """
        {"arrow":"x","array":["", ""]}
        """.data(using: .utf8)!
        print(try! JSONDecoder().decode(AnyArrow.self, from: data).metadata)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
