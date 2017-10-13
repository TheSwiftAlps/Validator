import RequestEngine

public enum TestError: Error {
    case failed
}

func expect(_ condition: Bool) throws {
    if !condition {
        throw TestError.failed
    }
}

public func ping(_ engine: RequestEngine) throws {
    let response = try engine.get("/ping")
    try expect(response.status == 200)
}

