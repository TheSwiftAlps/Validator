import RequestEngine

public enum TestError: Error {
    case failed(String)
}

func expect(_ condition: Bool, _ message: String = "") throws {
    if !condition {
        throw TestError.failed(message)
    }
}

public func ping(_ engine: RequestEngine) throws {
    let response = try engine.get("/ping")
    try expect(response.status != 200, "Ping failed")
}

