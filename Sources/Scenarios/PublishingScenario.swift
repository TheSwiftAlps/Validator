import Infrastructure

/// Scenario with tests about the publishing feature of the API.
/// Users are able to "publish" notes to the whole world. This is done
/// through a "PUT" request that gives the note a "slug" that can be
/// used to access the note in HTML format from any browser.
final public class PublishingScenario: BaseScenario {

    /// Runs several verifications about the publishing feature:
    /// 1. Creates a random user.
    /// 2. Logs in using the random credentials.
    /// 3. Creates a note.
    /// 4. Verifies that this new note is not published by default.
    /// 5. Publishes the note.
    /// 6. Checks that the logged in user can access publicly this note.
    /// 7. Log out.
    /// 8. Check again that the note is publicly available in HTML format.
    /// 9. Log in again.
    /// 10. Unpublish the note.
    /// 11. Check that the note is not published anymore.
    /// 12. Log out again.
    /// 13. Check that the note is truly not published anymore.
    ///
    /// - Returns: A dictionary of string descriptions and test methods.
    public override func scenario() -> [(String, BaseScenario.TestMethod, Int)]? {
        return [
            ("Create user", createUser, 5),
            ("Login", login, 5),
            ("Create note", createNote, 5),
            ("Check note is not published", checkNotPublished, 3),
            ("Publish note", publishNote, 5),
            ("Check published", checkPublished, 3),
            ("Logout", logout, 5),
            ("Check published", checkPublished, 3),
            ("Login", login, 5),
            ("Unpublish note", unpublishNote, 5),
            ("Check note is not published again", checkNotPublished, 3),
            ("Logout", logout, 5),
            ("Check note is not published one last time", checkNotPublished, 3),
        ]
    }

    /// Verifies that a note is not published.
    ///
    /// - Throws: whatever is thrown.
    func checkNotPublished() throws {
        if let slug = noteSlug {
            let response = try api.published(slug: slug)
            try expectStatusCode(.notFound, response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    /// Publishes a note.
    ///
    /// - Throws: whatever is thrown.
    func publishNote() throws {
        if let id = noteUUID {
            let response = try api.publish(id: id)
            try expectStatusCode(.ok, response)
            try expectSwiftAlpsVersionHeader(response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    /// Verifies that a note is published.
    ///
    /// - Throws: whatever is thrown.
    func checkPublished() throws {
        if let slug = noteSlug {
            let response = try api.published(slug: slug)
            try expectStatusCode(.ok, response)
            try expectContentType(.html, response)
            try expectSwiftAlpsVersionHeader(response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    /// Unpublishes a note.
    ///
    /// - Throws: whatever is thrown.
    func unpublishNote() throws {
        if let id = noteUUID {
            let response = try api.unpublish(id: id)
            try expectStatusCode(.ok, response)
            try expectSwiftAlpsVersionHeader(response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }
}
