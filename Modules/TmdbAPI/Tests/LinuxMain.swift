import XCTest

import TmdbAPITests

var tests = [XCTestCaseEntry]()
tests += TmdbAPITests.allTests()
XCTMain(tests)
