import RequestEngine

final public class UserTests: APITest {
    var token = ""
    var email = ""
    var name = ""
    var password = ""
    var notesCount = 0

    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("createUser", createUser),
            ("login", login),
            ("countNotes", countNotes),
            ("createNote", createNote),
            ("createNote", createNote),
            ("createNote", createNote),
            ("createNote", createNote),
            ("createNote", createNote),
            ("countNotes", countNotes),
            ("logout", logout),
        ]
    }

    func createUser() throws {
        let user = makeRandomUser()
        let response = try engine.post("/api/v1/users", data: user)
        try expectEquals(200, response.status)
        try expectEquals("application/json; charset=utf-8", response.contentType)
    }

    func login() throws {
        engine.auth = .basic(email, password)
        let response = try engine.post("/api/v1/login")
        try expectEquals(200, response.status)
        try expectEquals("application/json; charset=utf-8", response.contentType)
        if let json = response.json {
            token = json["token"] as! String
            try expect(token.characters.count > 0)
        }
        else {
            try fail("No JSON in response")
        }
    }

    func createNote() throws {
        let note = makeRandomNote()
        engine.auth = .token(token)
        let response = try engine.post("/api/v1/notes", data: note)
        try expectEquals(200, response.status)
        try expectEquals("application/json; charset=utf-8", response.contentType)
        notesCount += 1
    }

    func countNotes() throws {
        engine.auth = .token(token)
        let response = try engine.get("/api/v1/notes")
        try expectEquals(200, response.status)
        try expectEquals("application/json; charset=utf-8", response.contentType)
        if let json = response.json {
            let notes = json["response"] as! [Any]
            try expectEquals(notesCount, notes.count)
        }
        else {
            try fail("No JSON in response")
        }
    }

    func logout() throws {
        let note = makeRandomNote()
        engine.auth = .none
        let response = try engine.post("/api/v1/notes", data: note)
        try expectEquals(401, response.status)
        try expectEquals("application/json; charset=utf-8", response.contentType)
    }
}

// Private methods
extension UserTests {
    private func makeRandomUser() -> [String: String] {
        email = String.randomEmail()
        name = String.randomString(14)
        password = String.randomString(40)
        return [
            "email": email,
            "name": name,
            "password": password,
        ]
    }

    private func makeRandomNote() -> [String: String] {
        return [
            "title": String.randomString(30),
            "contents" : String.randomString(3000)
        ]
    }
}

