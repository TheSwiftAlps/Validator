import Infrastructure

final public class StatusCodeScenario: BaseScenario {
    public override func scenario() -> [(String, BaseScenario.TestMethod)]? {
        return [
            ("Ping", ping),
        ]
    }

    func ping() throws {
        let response = try api.ping()
        try expectContentType(.json, response)
        try expectStatusCode(.ok, response)
        try expectSwiftAlpsVersionHeader(response)
        if let json = response.json {
            try expectEquals(json["ping"] as! String, "pong")
        }
        else {
            try fail("No JSON in response")
        }
    }
}

