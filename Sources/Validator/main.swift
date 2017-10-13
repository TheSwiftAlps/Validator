import Foundation
import RequestEngine
import Tests
import Rainbow

#if os(Linux)
// Required in Linux to initialize the random number generator.
// The arc4random() family of functions is not available
// outside of BSD-like Unixes.
srandom(UInt32(time(nil)))
#endif

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
let tests = [ping]
let suite = TestSuite(engine: engine, tests: tests)
suite.run()

// Create an user
let randomEmail = String.randomEmail()
let randomName = String.randomString(14)
let randomPassword = String.randomString(40)
let user = [
    "email": randomEmail,
    "name": randomName,
    "password": randomPassword,
]
var response = try engine.post("/api/v1/users", data: user)
processResponse(response)

// Login
engine.auth = .basic(randomEmail, randomPassword)
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

