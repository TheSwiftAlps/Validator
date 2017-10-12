import Foundation
import RequestEngine
import Rainbow

let server = CommandLine.arguments[1]
let engine = RequestEngine(server)

func processResponse(_ response: Response) {
    let code = response.response?.statusCode ?? 0
    print("Status code: \(code)".blue.underline)
    precondition(code != 401)
    if let responseString = response.string {
        print(responseString.green)
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
    let code = response.response?.statusCode ?? 0
    print("Status code: \(code)".blue.underline)
    precondition(code != 401)
    if let json = response.json {
        let token = json["token"] as! String
        print(token.green)
        engine.auth = .token(token)
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
    let code = response.response?.statusCode ?? 0
    print("Status code: \(code)".red)
    precondition(code == 401)
    if let responseString = response.string {
        print(responseString.red)
    }
}

engine.auth = .none
response = try engine.post("/api/v1/notes", data: note)
processUnauthorized(response)

