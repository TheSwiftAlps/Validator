final public class StatusCodeTests: APITest {
    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("ping", ping),
        ]
    }

    func ping() throws {
        let response = try api.ping()
        try expectContentType(.json, response)
        try expectStatusCode(.ok, response)
        try expectHeader("Version", "Swift Alps 2017 – Notes API 1.0", response)
        if let json = response.json {
            try expectEquals(json["ping"] as! String, "pong")
        }
        else {
            try fail("No JSON in response")
        }
    }
}

