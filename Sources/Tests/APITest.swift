import RequestEngine

public class APITest {
    public typealias TestMethod = () throws -> ()

    public enum TestError<T: Equatable> : Error {
        case failed(String)
        case notEqual(T, T, String)
    }

    let api: API

    required public init(api: API) {
        self.api = api
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

// Utility methods
extension APITest {
    func makeRandomUser() -> [String: String] {
        return [
            "email": String.randomEmail(),
            "name": String.randomString(14),
            "password": String.randomString(40),
        ]
    }

    func makeRandomNote() -> [String: String] {
        return [
            "title": String.randomString(30),
            "contents" : String.randomString(3000)
        ]
    }
}

