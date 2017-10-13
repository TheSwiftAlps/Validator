final public class StatusCodeTests: APITest {
    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("ping", ping),
        ]
    }

    func ping() throws {
        let response = try api.ping()
        try expectContentType(.json, response.contentType)
        try expectStatusCode(.ok, response.status, "When doing a ping, the returning message should contain a status of 200.")
        if let json = response.json {
            try expectEquals(json["ping"] as! String, "pong")
        }
        else {
            try fail("No JSON in response")
        }
    }
}

