import RequestEngine

public class APITest {
    public typealias TestMethod = () throws -> ()

    public enum TestError<T: Equatable> : Error {
        case failed(String)
        case notEqual(T, T, String)
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
    func fail(_ message: String = "Test failed") throws {
        throw TestError<String>.failed(message)
    }

    func expect(_ condition: Bool, _ message: String = "Expected condition not met") throws {
        if !condition {
            throw TestError<String>.failed(message)
        }
    }

    func expectEquals<T: Equatable>(_ expected: T, _ received: T, _ message: String = "Values are not equal") throws {
        if expected != received {
            throw TestError<T>.notEqual(expected, received, message)
        }
    }
}

