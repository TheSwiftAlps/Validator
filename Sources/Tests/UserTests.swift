import Foundation

final public class UserTests: APITest {
    var email = ""
    var password = ""
    var notesCount = 0
    var noteUUID: String? = nil

    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("createUser", createUser),
            ("login", login),
            ("countNotes", countNotes),
            ("createManyNotes", createManyNotes),
            ("getNote", getNote),
            ("backupNotes", backupNotes),
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
            if let json = response.json {
                let data = json["data"] as! [String: Any]
                noteUUID = data["id"] as? String
            }
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
            notesCount += 1
        }
    }

    func getNote() throws {
        if let id = noteUUID {
            let response = try api.note(id: id)
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
        }
        else {
            try fail("No JSON response")
        }
    }

    func backupNotes() throws {
        let response = try api.backup()
        try expectStatusCode(.ok, response)
        try expectContentType(.zip, response)
        let url = URL(fileURLWithPath:"/home/akosma/Desktop/archive.zip")
        try response.save(at: url)
    }

    func countNotes() throws {
        let response = try api.notes()
        try expectStatusCode(.ok, response)
        try expectContentType(.json, response)
        if let json = response.json {
            let notes = json["data"] as! [Any]
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

