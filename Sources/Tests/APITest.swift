import Foundation
import RequestEngine
import LoremSwiftum

public class APITest {
    var email = ""
    var password = ""
    var noteUUID: String? = nil
    var slug: String? = nil

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

extension APITest {
    func createUser() throws {
        let user = makeRandomUser()
        email = user["email"]!
        password = user["password"]!
        let response = try api.create(user: user)
        try expectStatusCode(.ok, response)
        try expectContentType(.json, response)
    }
    
    func login() throws {
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
    
    func loginDefaultUser() throws {
        let response = try api.login(user: "vapor@theswiftalps.com", pass: "swiftalps")
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
    
    func createNote() throws {
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

    func logout() throws {
        api.logout()
        let note = makeRandomNote()
        let response = try api.create(note: note)
        try expectStatusCode(.notAuthorized, response)
        try expectContentType(.json, response)
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

    func expectContentType(_ expected: RequestEngine.MimeType, _ received: Response, _ message: String = "Received wrong Content-Type header") throws {
        if expected.rawValue != received.contentType {
            throw TestError<String>.notEqual(expected.rawValue, received.contentType, message)
        }
    }

    func expectStatusCode(_ expected: Response.StatusCode, _ received: Response, _ message: String = "Received wrong status code") throws {
        if expected != received.status {
            throw TestError<Response.StatusCode>.notEqual(expected, received.status, message)
        }
    }

    func expectHeader(_ headerKey: String, _ headerValue: String, _ received: Response, _ message: String = "Wrong response header") throws {
        if let val = received.headers?[headerKey] as? String {
            if val == headerValue {
                return
            }
        }
        throw TestError<String>.failed(message)
    }
}

// Utility methods
extension APITest {
    func makeDefaultUser() -> [String: String] {
        return [
            "email": "vapor@theswiftalps.com",
            "name": "Vapor @ The Swift Alps 2017",
            "password": "swiftalps",
        ]
    }
    
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

