final public class UserTests: APITest {
    var email = ""
    var password = ""
    var notesCount = 0

    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("createUser", createUser),
            ("login", login),
            ("countNotes", countNotes),
            ("createNote", createNote),
            ("countNotes", countNotes),
            ("logout", logout),
        ]
    }

    func createUser() throws {
        let user = makeRandomUser()
        email = user["email"]!
        password = user["password"]!
        let response = try api.create(user: user)
        try expectEquals(200, response.status)
        try expectEquals("application/json; charset=utf-8", response.contentType)
    }

    func login() throws {
        let response = try api.login(user: email, pass: password)
        try expectEquals(200, response.status)
        try expectEquals("application/json; charset=utf-8", response.contentType)
        if let json = response.json {
            let token = json["token"] as! String
            try expect(token.characters.count > 0)
        }
        else {
            try fail("No JSON in response")
        }
    }

    func createNote() throws {
        for _ in 1...100 {
            let note = makeRandomNote()
            let response = try api.create(note: note)
            try expectEquals(200, response.status)
            try expectEquals("application/json; charset=utf-8", response.contentType)
            notesCount += 1
        }
    }

    func countNotes() throws {
        let response = try api.notes()
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
        api.logout()
        let note = makeRandomNote()
        let response = try api.create(note: note)
        try expectEquals(401, response.status)
        try expectEquals("application/json; charset=utf-8", response.contentType)
    }
}

