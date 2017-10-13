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

    func expect(_ condition: Bool, _ message: String = "") throws {
        if !condition {
            throw TestError.failed(message)
        }
    }

    func allTests() -> [(String, TestMethod)]? {
        return nil
    }
}

