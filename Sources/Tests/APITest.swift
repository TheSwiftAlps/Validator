import RequestEngine

public class APITest {
    public typealias TestMethod = () throws -> ()

    public enum TestError: Error {
        case failed(String)
    }

    let engine: RequestEngine

    required public init(engine: RequestEngine) {
        self.engine = engine
    }

    func scenario() -> [(String, TestMethod)]? {
        return nil
    }
}

// Assertions
extension APITest {
    func expect(_ condition: Bool, _ message: String = "") throws {
        if !condition {
            throw TestError.failed(message)
        }
    }
}

