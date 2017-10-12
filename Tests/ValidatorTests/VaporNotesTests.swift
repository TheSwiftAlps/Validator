import XCTest
@testable import RequestEngine

class VaporNotesTests: XCTestCase {
    let engine = RequestEngine("http://localhost")

    func testPing() throws {
        let response = try engine.get("/ping")
        let httpResponse = response.1 as! HTTPURLResponse
        XCTAssertEqual(200, httpResponse.statusCode)
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
