public final class SearchTests: APITest {

    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("Create user", createUser),
            ("Login", login),
            ("Create many notes", createManyNotes),
            ("Search", search),
        ]
    }

    func createManyNotes() throws {
        for _ in 1...10 {
            try createNote()
        }
    }

    func search() throws {
        let response = try api.search(query: "Lorem")
        if let json = response.json {
            let notes = json["data"] as! [Any]
            try expectStatusCode(.ok, response)
            try expectContentType(.json, response)
            try expect(notes.count > 0)
        }
        else {
            try fail("No JSON in response")
        }
    }
}

