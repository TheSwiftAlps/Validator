import XCTest
@testable import RequestEngine

class VaporNotesTests: XCTestCase {
    let engine = RequestEngine("http://localhost")

    func testPing() throws {
        let response = try engine.get("/ping")
        XCTAssertEqual(200, response.response?.statusCode)
    }
}

// MARK: Manifest

extension VaporNotesTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testPing", testPing),
    ]
}
