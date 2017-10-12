import Foundation
import RequestEngine
import Rainbow

func processUnauthorized(_ response: Response) {
    print("Status code: \(response.status)".red.bold.blink)
    if let responseString = response.string {
        print(responseString.red)
    }
}

func processLogin(_ response: Response) -> String {
    print("Status code: \(response.status)".blue.underline)
    if let json = response.json {
        let token = json["token"] as! String
        return token
    }
    return ""
}

func processResponse(_ response: Response) {
    print("Status code: \(response.status)".blue.underline)
    if let responseString = response.string {
        print(responseString.green)
    }
}

// Get the URL of the server from the command line
let server = CommandLine.arguments[1]
let engine = RequestEngine(server)

// Ping the API
var response = try engine.get("/ping")
processResponse(response)

// Create an user
let user = [
    "email": "vapor@theswiftalps.com",
    "name": "swiftalps",
    "password": "swiftalps"
]
response = try engine.post("/api/v1/users", data: user)
processResponse(response)

// Login
engine.auth = .basic("vapor@theswiftalps.com", "swiftalps")
response = try engine.post("/api/v1/login", data: nil)
let token = processLogin(response)
print(token.green)

// Try to create a note
let note = [
    "title": "test title",
    "contents" : "test note created from swift"
]

engine.auth = .token(token)
response = try engine.post("/api/v1/notes", data: note)
processResponse(response)

// Logout
engine.auth = .none
response = try engine.post("/api/v1/notes", data: note)
processUnauthorized(response)

