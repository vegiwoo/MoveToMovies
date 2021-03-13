import XCTest

import OmdbAPITests

var tests = [XCTestCaseEntry]()
tests += OmdbAPITests.allTests()
XCTMain(tests)
