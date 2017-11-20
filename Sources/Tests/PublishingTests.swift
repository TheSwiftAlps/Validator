final public class PublishingTests: APITest {

    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("Create user", createUser),
            ("Login", login),
            ("Create note", createNote),
            ("Check note is not published", checkNotPublished),
            ("Publish note", publishNote),
            ("Check published", checkPublished),
            ("Logout", logout),
            ("Check published", checkPublished),
            ("Login", login),
            ("Unpublish note", unpublishNote),
            ("Check not published", checkNotPublished),
        ]
    }

    func checkNotPublished() throws {
        if let slug = slug {
            let response = try api.published(slug: slug)
            try expectStatusCode(.notFound, response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    func publishNote() throws {
        if let id = noteUUID {
            let response = try api.publish(id: id)
            try expectStatusCode(.ok, response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    func checkPublished() throws {
        if let slug = slug {
            let response = try api.published(slug: slug)
            try expectStatusCode(.ok, response)
            try expectContentType(.html, response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }

    func unpublishNote() throws {
        if let id = noteUUID {
            let response = try api.unpublish(id: id)
            try expectStatusCode(.ok, response)
        }
        else {
            try fail("No ID to retrieve note")
        }
    }
}
