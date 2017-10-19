import Foundation

final public class UserTests: APITest {
    var notesCount = 0

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

    func createManyNotes() throws {
        for _ in 1...10 {
            try createNote()
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
            try fail("No ID to retrieve note")
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
}

