import Foundation
import RequestEngine

let server = CommandLine.arguments[1]
let engine = RequestEngine(server)

func processResponse(_ response: Response) {
    print("Response: ")
    let httpResponse = response.1 as! HTTPURLResponse
    print(httpResponse.statusCode)
    precondition(httpResponse.statusCode != 401)
    if let data = response.0 {
        let responseString = String(data: data, encoding: .utf8)!
        print(responseString)
    }
}

// Ping the API
var response = try engine.get("/ping")
processResponse(response)

// Create an user
let user = ["email": "vapor@theswiftalps.com", "name": "swiftalps", "password": "swiftalps"]
response = try engine.post("/api/v1/users", data: user)
processResponse(response)

// Login
func processLogin(_ response: Response) {
    print("Response: ")
    let httpResponse = response.1 as! HTTPURLResponse
    print(httpResponse.statusCode)
    precondition(httpResponse.statusCode != 401)
    if let data = response.0 {
        do {
            var json = try JSONSerialization.jsonObject(with: data, options:[]) as! [String: String]
            let token = json["token"]!
            print(token)
            engine.auth = .token(token)
        }
        catch {
            print("Error converting JSON")
        }
    }
}

engine.auth = .basic("vapor@theswiftalps.com", "swiftalps")
response = try engine.post("/api/v1/login", data: nil)
processLogin(response)

// Try to create a note
let note = [
    "title": "test title",
    "contents" : "test note created from swift"
]

response = try engine.post("/api/v1/notes", data: note)
processResponse(response)

// Logout
func processUnauthorized(_ response: Response) {
    print("Unauthorized: ")
    let httpResponse = response.1 as! HTTPURLResponse
    print(httpResponse.statusCode)
    precondition(httpResponse.statusCode == 401)
    if let data = response.0 {
        let responseString = String(data: data, encoding: .utf8)!
        print(responseString)
    }
}

engine.auth = .none
response = try engine.post("/api/v1/notes", data: note)
processUnauthorized(response)

