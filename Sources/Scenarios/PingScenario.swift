import Infrastructure

/// Scenario to test whether the remote API has a PING endpoint.
final public class PingScenario: BaseScenario {
    /// This scenario sends a GET "ping" request to the API.
    ///
    /// - Returns: A dictionary of string descriptions and test methods.
    public override func scenario() -> [(String, BaseScenario.TestMethod)]? {
        return [
            ("Ping", ping),
        ]
    }

    /// Sends a ping request to the API. The response should be a JSON that contains the following text:
    /// `{ "ping": "pong" }`
    ///
    /// - Throws: whatever the underlying system throws.
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

