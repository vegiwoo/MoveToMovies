import XCTest
@testable import DataStorage

final class DataStorageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DataStorage().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
