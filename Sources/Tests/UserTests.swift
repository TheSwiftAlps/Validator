import RequestEngine

final public class UserTests: APITest {
    var token = ""
    var email = ""
    var name = ""
    var password = ""
    let note = [
        "title": "test title",
        "contents" : "test note created from swift"
    ]

    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("createUser", createUser),
            ("login", login),
            ("noNotes", noNotes),
            ("createNote", createNote),
            ("oneNote", oneNote),
            ("logout", logout),
        ]
    }

    func createUser() throws {
        email = String.randomEmail()
        name = String.randomString(14)
        password = String.randomString(40)
        let user = [
            "email": email,
            "name": name,
            "password": password,
        ]
        let response = try engine.post("/api/v1/users", data: user)
        try expectEquals(200, response.status)
    }

    func login() throws {
        engine.auth = .basic(email, password)
        let response = try engine.post("/api/v1/login", data: nil)
        try expectEquals(200, response.status)
        if let json = response.json {
            token = json["token"] as! String
            try expect(token.characters.count > 0)
        }
        else {
            try fail("No JSON in response")
        }
    }

    func noNotes() throws {
        engine.auth = .token(token)
        let response = try engine.get("/api/v1/notes")
        try expectEquals(200, response.status)
        if let json = response.json {
            let notes = json["response"] as! [Any]
            try expectEquals(0, notes.count)
        }
        else {
            try fail("No JSON in response")
        }
    }

    func createNote() throws {
        engine.auth = .token(token)
        let response = try engine.post("/api/v1/notes", data: note)
        try expectEquals(200, response.status)
    }

    func oneNote() throws {
        engine.auth = .token(token)
        let response = try engine.get("/api/v1/notes")
        try expectEquals(200, response.status)
        if let json = response.json {
            let notes = json["response"] as! [Any]
            try expectEquals(1, notes.count)
        }
        else {
            try fail("No JSON in response")
        }
    }

    func logout() throws {
        engine.auth = .none
        let response = try engine.post("/api/v1/notes", data: note)
        try expectEquals(401, response.status)
    }
}

