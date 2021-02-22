import XCTest
@testable import Stellar

final class StellarTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Stellar().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
