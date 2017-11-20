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
    /// 6. Backup all notes; that should return a ZIP file, which will be saved in the Desktop folder.
    /// 7. Count all the notes of the current user; the number should be equal to the number of notes created in step 4.
    /// 8. Logout.
    ///
    /// - Returns: A dictionary of string descriptions and test methods.
    public override func scenario() -> [(String, BaseScenario.TestMethod)]? {
        return [
            ("Create user", createUser),
            ("Login", login),
            ("Count notes", countNotes),
            ("Create many notes", createManyNotes),
            ("Get note", getNote),
            ("Backup notes", backupNotes),
            ("Count notes", countNotes),
            ("Logout", logout),
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
}

