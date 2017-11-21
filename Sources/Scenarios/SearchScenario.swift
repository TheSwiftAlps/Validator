import Infrastructure
import RequestEngine

/// Scenario testing the searching capabilities of the API
public final class SearchScenario: BaseScenario {

    /// This scenario does the following:
    /// 1. Creates a random user.
    /// 2. Logs in with this random user.
    /// 3. Creates many random notes.
    /// 4. Searches notes by contents, using a random word in one of the notes created previously.
    /// 5. Searches notes by title, using a random word in one of the titles of the notes created previously.
    ///
    /// - Returns: A dictionary of string descriptions and test methods.
    public override func scenario() -> [(String, BaseScenario.TestMethod, Int)]? {
        return [
            ("Create user", createUser, 5),
            ("Login", login, 3),
            ("Create many notes", createManyNotes, 5),
            ("Search by contents", searchByContents, 5),
            ("Search by title", searchByTitle, 5),
        ]
    }

    /// Creates many notes in the API.
    ///
    /// - Throws: whatever the underlying system throws.
    func createManyNotes() throws {
        for _ in 1...10 {
            try createNote()
        }
    }

    /// Searches notes by a word in the contents.
    ///
    /// - Throws: whatever the underlying system throws.
    func searchByContents() throws {
        let words = noteContents?.split() ?? []
        let randomWord = selectRandomWord(words: words)

        let response = try api.search(query: randomWord)
        if let json = response.json {
            let notes = json["data"] as! [Any]
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
            try expectSwiftAlpsVersionHeader(response)
            try expect(notes.count > 0)
        }
        else {
            try fail("No note contained the word \"\(randomWord)\"")
        }
    }

    /// Searches notes by a word in the title.
    ///
    /// - Throws: whatever the underlying system throws.
    func searchByTitle() throws {
        let words = noteTitle?.split() ?? []
        let randomWord = selectRandomWord(words: words)

        let response = try api.search(query: randomWord)
        if let json = response.json {
            let notes = json["data"] as! [Any]
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
            try expectSwiftAlpsVersionHeader(response)
            try expect(notes.count > 0)
        }
        else {
            try fail("No note contained the word \"\(randomWord)\" in the title")
        }
    }

    /// Chooses a random word from an array of strings.
    ///
    /// - Parameter words: An array of strings to choose from.
    /// - Returns: A random pick from the array.
    private func selectRandomWord(words: [String]) -> String {
        let count = words.count
        let randomIndex = count.randomFromZeroToMe()
        if words.count > 0 {
            return words[randomIndex]
        }
        return ""
    }
}
