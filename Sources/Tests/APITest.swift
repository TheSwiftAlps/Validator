import Foundation
import RequestEngine
import LoremSwiftum

public class APITest {
    public typealias TestMethod = () throws -> ()

    public enum TestError<T: Equatable> : Error {
        case failed(String)
        case notEqual(T, T, String)
    }

    public enum ContentType: String {
        case json = "application/json; charset=utf-8"
        case zip = "application/zip"
        case html = "text/html"
    }

    public enum StatusCode: Int {
        case ok = 200
        case notFound = 404
        case error = 500
        case notAuthorized = 401
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

    func expectContentType(_ expected: ContentType, _ received: Response, _ message: String = "Received wrong Content-Type header") throws {
        if expected.rawValue != received.contentType {
            throw TestError<String>.notEqual(expected.rawValue, received.contentType, message)
        }
    }

    func expectStatusCode(_ expected: StatusCode, _ received: Response, _ message: String = "Received wrong status code") throws {
        if expected.rawValue != received.status {
            throw TestError<Int>.notEqual(expected.rawValue, received.status, message)
        }
    }
}

// Utility methods
extension APITest {
    func makeRandomUser() -> [String: String] {
        return [
            "email": Lorem.email,
            "name": Lorem.name,
            "password": String.randomString(40),
        ]
    }

    func makeRandomNote() -> [String: String] {
        return [
            "title": Lorem.title,
            "contents": Lorem.sentences(count: 10),
            "id": UUID().uuidString,
        ]
    }
}

