import Foundation

let server = CommandLine.arguments[1]
let engine = RequestEngine(server)
let completionHandler: RequestEngine.Callback = {
    let data = $0
    let response = $1
    let _ = $2
    print("Response: ")
    let httpResponse = response as! HTTPURLResponse
    print(httpResponse.statusCode)
    precondition(httpResponse.statusCode != 401)
    if let d = data {
        let responseString = String(data: d, encoding: .utf8)!
        print(responseString)
    }
}

// Ping the API
try engine.get("/ping", callback: completionHandler)

// Create an user
let user = ["email": "vapor@theswiftalps.com", "name": "swiftalps", "password": "swiftalps"]

try engine.post("/api/v1/users", data: user) {
    let data = $0
    let response = $1
    let _ = $2

    print("Response: ")
    let httpResponse = response as! HTTPURLResponse
    print(httpResponse.statusCode)
    precondition(httpResponse.statusCode != 401)
    if let d = data {
        let responseString = String(data: d, encoding: .utf8)!
        print(responseString)
    }
}

// Login
engine.auth = .basic("vapor@theswiftalps.com", "swiftalps")
try engine.post("/api/v1/login", data: nil) {
    let data = $0
    let response = $1
    let _ = $2

    print("Response: ")
    let httpResponse = response as! HTTPURLResponse
    print(httpResponse.statusCode)
    precondition(httpResponse.statusCode != 401)
    if let d = data {
        do {
            var json = try JSONSerialization.jsonObject(with: d, options:[]) as! [String: String]
            let token = json["token"]!
            print(token)
            engine.auth = .token(token)
        }
        catch {
            print("Error converting JSON")
        }
    }
}

// Try to create a note
let note = [
    "title": "test title",
    "contents" : "test note created from swift"
]

try engine.post("/api/v1/notes", data: note, callback: completionHandler)

// Logout
engine.auth = .none
try engine.post("/api/v1/notes", data: note) {
    let data = $0
    let response = $1
    let _ = $2
    print("Unauthorized: ")
    let httpResponse = response as! HTTPURLResponse
    print(httpResponse.statusCode)
    precondition(httpResponse.statusCode == 401)
    if let d = data {
        let responseString = String(data: d, encoding: .utf8)!
        print(responseString)
    }
}

