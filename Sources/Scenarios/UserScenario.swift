import Foundation
import Infrastructure

/// Scenario testing different user features: creation, login, logout, etc.
final public class UserScenario: BaseScenario {
    /// Counter holding the number of notes created
    var notesCount = 0

    /// Returns the path to the "Desktop" folder of the current user.
    /// In Linux NSSearchPathForDirectoriesInDomains is not yet available,
    /// so this method must be modified accordingly.
    var desktopPath: String {
        #if os(Linux)
            return "/home/developer/Desktop/archive.zip"
        #else
            let search = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
            let desktop = search.first!
            return "\(desktop)/archive.zip"
        #endif
    }

    /// Scenario testing several user-related features of the API:
    /// 1. Create a random user.
    /// 2. Login with these random credentials.
    /// 3. Count the number of notes of the current user. It should be zero.
    /// 4. Create many notes.
    /// 5. Get one of those notes just created.
    /// 6. Edit that note and verify it's saved correctly.
    /// 7. Backup all notes; that should return a ZIP file, which will be saved in the Desktop folder.
    /// 8. Count all the notes of the current user; the number should be equal to the number of notes created in step 4.
    /// 9. Delete that note.
    /// 10. Count again.
    /// 11. Delete all the notes.
    /// 12. Count again, and this time we should have zero notes.
    /// 13. Log out.
    ///
    /// - Returns: A dictionary of string descriptions and test methods.
    public override func scenario() -> [(String, BaseScenario.TestMethod, Int)]? {
        return [
            ("Create user", createUser, 5),
            ("Login", login, 5),
            ("Count notes", countNotes, 3),
            ("Create many notes", createManyNotes, 5),
            ("Get note", getNote, 3),
            ("Edit note", editNote, 5),
            ("Backup notes", backupNotes, 10),
            ("Count notes", countNotes, 3),
            ("Delete note", deleteNote, 3),
            ("Count one note less", countNotes, 3),
            ("Delete all notes", deleteAllNotes, 3),
            ("Count zero notes", countNotes, 3),
            ("Logout", logout, 5),
        ]
    }

    /// Creates many notes in the API.
    ///
    /// - Throws: whatever the underlying system throws.
    func createManyNotes() throws {
        for _ in 1...10 {
            try createNote()
            notesCount += 1
        }
    }

    /// Gets a note from the API.
    ///
    /// - Throws: whatever the underlying system throws.
    func getNote() throws {
        if let id = noteUUID {
            let response = try api.note(id: id)
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
            try expectSwiftAlpsVersionHeader(response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    /// Requests a backup of all notes in the API.
    ///
    /// - Throws: whatever the underlying system throws.
    func backupNotes() throws {
        let response = try api.backup()
        try expectStatusCode(.ok, response)
        try expectContentType(.zip, response)
        try expectSwiftAlpsVersionHeader(response)
        let url = URL(fileURLWithPath: desktopPath)
        try response.save(at: url)
    }

    /// Counts the amount of notes of the current user.
    ///
    /// - Throws: whatever the underlying system throws.
    func countNotes() throws {
        let response = try api.notes()
        try expectStatusCode(.ok, response)
        try expectContentType(.json, response)
        try expectSwiftAlpsVersionHeader(response)
        if let json = response.json {
            let notes = json["data"] as! [Any]
            try expectEquals(notesCount, notes.count)
        }
        else {
            try fail("No JSON in response")
        }
    }

    /// Edits the contents of the current note.
    ///
    /// - Throws: whatever the underlying system throws.
    func editNote() throws {
        if let id = noteUUID {
            let note = [
                "title": "New Title",
                "contents": "New Contents"
            ]
            let response = try api.edit(id: id, note: note)
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
            try expectSwiftAlpsVersionHeader(response)
            if let json = response.json {
                let data = json["data"] as! [String: Any]
                let newUUID = data["id"] as! String
                let newContents = data["contents"] as! String
                let newTitle = data["title"] as! String
                try expectStatusCode(.ok, response)
                try expectContentType(.json, response)
                try expectEquals(newUUID, id)
                try expectEquals(newTitle, note["title"]!)
                try expectEquals(newContents, note["contents"]!)
            }
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    /// Deletes the note specified by its ID.
    ///
    /// - Throws: whatever the underlying system throws.
    func deleteNote() throws {
        if let id = noteUUID {
            let response = try api.delete(id: id)
            try expectStatusCode(.ok, response)
            try expectSwiftAlpsVersionHeader(response)
            notesCount -= 1
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    /// Deletes all the notes of the current user.
    ///
    /// - Throws: whatever the underlying system throws.
    func deleteAllNotes() throws {
        let response = try api.delete()
        try expectStatusCode(.ok, response)
        try expectSwiftAlpsVersionHeader(response)
        notesCount = 0
    }
}

