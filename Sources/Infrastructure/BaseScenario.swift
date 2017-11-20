import Foundation
import RequestEngine
import LoremSwiftum

/// Base class for all scenarios of interaction with the API.
/// This class is meant to be subclassed. Subclasses *must* override the
/// `scenario()` method, returning a dictionary mapping strings to
/// methods within the subclass instance.
/// This class provides ready-to-use methods to create users and notes.
open class BaseScenario {
    /// The e-mail used to connect to the backend.
    public var email = ""
    
    /// The password used to connect to the backend.
    public var password = ""

    /// The UUID of the current note being requested or manipulated.
    public var noteUUID: String? = nil

    /// The slug of the public note being requested.
    public var slug: String? = nil

    /// The API wrapper object used to connect to the backend.
    public let api: API

    /// Describes the base type of a test method inside a scenario.
    ///
    /// - Throws: whatever the RequestEngine or the assertions throw.
    public typealias TestMethod = () throws -> ()

    /// Type of errors that can be raised when asserting.
    ///
    /// - failed: Assertion has failed. The associated value is a description of the error.
    /// - notEqual: Raised when the two first associated values are not equal to each other.
    public enum TestError<T: Equatable> : Error {
        case failed(String)
        case notEqual(T, T, String)
    }

    /// Required initializer.
    ///
    /// - Parameter api: API object wrapping the accesses to the backend server.
    required public init(api: API) {
        self.api = api
    }

    /// Subclasses are required to override this method, in order to provide the
    /// exact sequence of methods to be executed for a scenario.
    ///
    /// - Returns: A dictionary of string descriptions and test methods.
    open func scenario() -> [(String, TestMethod)]? {
        return nil
    }
}

// MARK: - Helper test methods common to all scenarios
extension BaseScenario {
    /// Tells the API to create a user.
    ///
    /// - Throws: whatever the RequestEngine or the assertions throw.
    public func createUser() throws {
        let user = makeRandomUser()
        email = user["email"]!
        password = user["password"]!
        let response = try api.create(user: user)
        try expectStatusCode(.ok, response)
        try expectContentType(.json, response)
    }

    /// Tells the API to login the user identified
    /// with the "email" and "password" fields
    ///
    /// - Throws: whatever the RequestEngine or the assertions throw.
    public func login() throws {
        let response = try api.login(user: email, pass: password)
        try expectStatusCode(.ok, response)
        try expectContentType(.json, response)
        if let json = response.json {
            let token = json["token"] as! String
            try expect(token.count > 0)
        }
        else {
            try fail("No JSON in response")
        }
    }

    /// Tells the API to login a user with
    /// e-mail "vapor@theswiftalps.com" and password "swiftalps".
    ///
    /// - Throws: whatever the RequestEngine or the assertions throw.
    public func loginDefaultUser() throws {
        email = "vapor@theswiftalps.com"
        password = "swiftalps"
        let response = try api.login(user: email, pass: password)
        try expectStatusCode(.ok, response)
        try expectContentType(.json, response)
        if let json = response.json {
            let token = json["token"] as! String
            try expect(token.count > 0)
        }
        else {
            try fail("No JSON in response")
        }
    }

    /// Tells the API to create a note.
    ///
    /// - Throws: whatever the RequestEngine or the assertions throw.
    public func createNote() throws {
        let note = makeRandomNote()
        let response = try api.create(note: note)
        if let json = response.json {
            let data = json["data"] as! [String: Any]
            noteUUID = data["id"] as? String
            slug = data["slug"] as? String
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
        }
        else {
            try fail("No JSON in response")
        }
    }

    /// Logouts the current user and tries to create a note; this must fail.
    ///
    /// - Throws: whatever the RequestEngine or the assertions throw.
    public func logout() throws {
        api.logout()
        let note = makeRandomNote()
        let response = try api.create(note: note)
        try expectStatusCode(.notAuthorized, response)
        try expectContentType(.json, response)
    }
}

// MARK: - Assertions
extension BaseScenario {
    /// Fails unconditionally.
    ///
    /// - Parameter message: The text to be shown to the user.
    /// - Throws: a TestError instance
    public func fail(_ message: String = "Test failed") throws {
        throw TestError<String>.failed(message)
    }

    /// Throws an error if the condition is not met.
    ///
    /// - Parameters:
    ///   - condition: The condition to test.
    ///   - message: A message to display if the condition is not met.
    /// - Throws: A TestError instance.
    public func expect(_ condition: Bool, _ message: String = "Expected condition not met") throws {
        if !condition {
            throw TestError<String>.failed(message)
        }
    }

    /// Throws an error if the two values passed as parameter are not equal.
    ///
    /// - Parameters:
    ///   - expected: The value expected by this assertion.
    ///   - received: The actual value received from the server.
    ///   - message: A message to be displayed to the user.
    /// - Throws: A TestError instance.
    public func expectEquals<T: Equatable>(_ expected: T, _ received: T, _ message: String = "Values are not equal") throws {
        if expected != received {
            throw TestError<T>.notEqual(expected, received, message)
        }
    }

    /// Throws an error if the "Content-Type" header does not match the expectations.
    ///
    /// - Parameters:
    ///   - expected: The expected content type.
    ///   - received: The response received from the server.
    ///   - message: A message to be displayed to the user.
    /// - Throws: A TestError instance.
    public func expectContentType(_ expected: RequestEngine.MimeType, _ received: Response, _ message: String = "Received wrong Content-Type header") throws {
        if expected.rawValue != received.contentType {
            throw TestError<String>.notEqual(expected.rawValue, received.contentType, message)
        }
    }

    /// Throws an error if the status code of the response does not match the expectations.
    ///
    /// - Parameters:
    ///   - expected: The expected status code.
    ///   - received: The response received from the server.
    ///   - message: A message to be displayed to the user.
    /// - Throws: A TestError instance.
    public func expectStatusCode(_ expected: Response.StatusCode, _ received: Response, _ message: String = "Received wrong status code") throws {
        if expected != received.status {
            throw TestError<Response.StatusCode>.notEqual(expected, received.status, message)
        }
    }

    /// Throws an error if the response does not include a specific header.
    ///
    /// - Parameters:
    ///   - headerKey: The expected header key.
    ///   - headerValue: The expected header value.
    ///   - received: The response received from the server.
    ///   - message: A message to be displayed to the user.
    /// - Throws: A TestError instance.
    public func expectHeader(_ headerKey: String, _ headerValue: String, _ received: Response, _ message: String = "Wrong response header") throws {
        if let val = received.headers?[headerKey] as? String {
            if val == headerValue {
                return
            }
        }
        throw TestError<String>.failed(message)
    }
    
    /// Throws an error if a specific header is not available in the response.
    ///
    /// - Parameter response: The response received from the server.
    /// - Throws: A TestError instance.
    public func expectSwiftAlpsVersionHeader(_ response: Response) throws {
        try expectHeader("Version", "Swift Alps 2017 - Notes API 1.0", response)
    }
}

// MARK: - Utility private methods
extension BaseScenario {
    /// Creates a default user with a specific username and password.
    ///
    /// - Returns: A dictionary.
    private func makeDefaultUser() -> [String: String] {
        return [
            "email": "vapor@theswiftalps.com",
            "name": "Vapor @ The Swift Alps 2017",
            "password": "swiftalps",
        ]
    }

    /// Creates a random user with random username and password.
    ///
    /// - Returns: A dictionary.
    private func makeRandomUser() -> [String: String] {
        return [
            "email": Lorem.email,
            "name": Lorem.name,
            "password": String.randomString(40),
        ]
    }

    /// Creates a random note with "Lorem ipsum" text.
    ///
    /// - Returns: A dictionary.
    private func makeRandomNote() -> [String: String] {
        return [
            "title": Lorem.title,
            "contents": Lorem.sentences(count: 10),
            "id": UUID().uuidString,
        ]
    }
}

