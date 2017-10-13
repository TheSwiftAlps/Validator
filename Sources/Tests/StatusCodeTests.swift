final public class StatusCodeTests: APITest {
    public func ping() throws {
        let response = try engine.get("/ping")
        try expect(response.status == 200, "Ping failed")
    }

    override func allTests() -> [(String, APITest.TestMethod)]? {
        return [
            ("ping", ping),
        ]
    }
}

