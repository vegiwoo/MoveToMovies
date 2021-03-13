import XCTest
@testable import UIControls

final class UIControlsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UIControls().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
