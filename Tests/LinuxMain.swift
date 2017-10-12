#if os(Linux)

import XCTest
@testable import ValidatorTests

XCTMain([
    // AppTests
    testCase(VaporNotesTests.allTests),
])

#endif
