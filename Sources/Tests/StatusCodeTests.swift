final public class StatusCodeTests: APITest {
    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("ping", ping),
            ("notFound", notFound),
        ]
    }

    func ping() throws {
        let response = try engine.get("/ping")
        try expectEquals("application/json; charset=utf-8", response.contentType)
        try expectEquals(200, response.status, "When doing a ping, the returning message should contain a status of 200.")
        if let json = response.json {
            try expectEquals(json["ping"] as! String, "pong")
        }
        else {
            try fail("No JSON in response")
        }
    }

    func notFound() throws {
        let response = try engine.get("/whatever")
        try expectEquals(404, response.status)
    }
}

