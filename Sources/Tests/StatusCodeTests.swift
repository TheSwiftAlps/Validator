final public class StatusCodeTests: APITest {
    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("ping", ping),
        ]
    }

    public func ping() throws {
        let response = try engine.get("/ping")
        try expect(response.status == 200, "Ping failed")
    }
}

