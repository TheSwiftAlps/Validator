final public class UserTests: APITest {
    var email = ""
    var password = ""
    var notesCount = 0

    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("createUser", createUser),
            ("login", login),
            ("countNotes", countNotes),
            ("createManyNotes", createManyNotes),
            ("countNotes", countNotes),
            ("logout", logout),
        ]
    }

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
            try expect(token.characters.count > 0)
        }
        else {
            try fail("No JSON in response")
        }
    }

    func createManyNotes() throws {
        for _ in 1...10 {
            let note = makeRandomNote()
            let response = try api.create(note: note)
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
            notesCount += 1
        }
    }

    func countNotes() throws {
        let response = try api.notes()
        try expectStatusCode(.ok, response)
        try expectContentType(.json, response)
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
        try expectStatusCode(.notAuthorized, response)
        try expectContentType(.json, response)
    }
}

