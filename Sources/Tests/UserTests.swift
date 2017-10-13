import RequestEngine

final public class UserTests: APITest {
    var token = ""
    var email = ""
    var name = ""
    var password = ""

    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("createUser", createUser),
            ("login", login),
            ("createNote", createNote),
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
        if let json = response.json {
            token = json["token"] as! String
        }
        try expectEquals(200, response.status)
        try expect(token.characters.count > 0)
    }

    func createNote() throws {
        let note = [
            "title": "test title",
            "contents" : "test note created from swift"
        ]

        engine.auth = .token(token)
        let response = try engine.post("/api/v1/notes", data: note)
        try expectEquals(200, response.status)
    }

    func logout() throws {
        let note = [
            "title": "test title",
            "contents" : "test note created from swift"
        ]

        engine.auth = .none
        let response = try engine.post("/api/v1/notes", data: note)
        try expectEquals(401, response.status)
    }
}
