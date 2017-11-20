import RequestEngine

/// Wraps the target API to validate. This class is used by
/// all the subclasses of the `APITest` class, to perform operations
/// on the remote API endpoint.
public struct API {
    let engine: RequestEngine

    /// Initializes a new instance.
    ///
    /// - Parameter engine: A RequestEngine instance.
    init(_ engine: RequestEngine) {
        self.engine = engine
    }

    /// Performs a "GET /ping" request.
    ///
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func ping() throws -> Response {
        return try engine.get("/ping")
    }

    /// Performs a "POST /api/v1/users" request.
    ///
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func create(user: [String: String]) throws -> Response {
        return try engine.post("/api/v1/users", data: user)
    }

    /// Performs a "POST /api/v1/login" request.
    ///
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func login(user: String, pass: String) throws -> Response {
        engine.auth = .basic(user, pass)
        let response = try engine.post("/api/v1/login")
        if let json = response.json {
            let token = json["token"] as! String
            engine.auth = .token(token)
        }
        else {
            engine.auth = .none
        }
        return response
    }

    /// Disables the RequestEngine from providing "Authorization" headers
    /// with every request to the API.
    func logout() {
        engine.auth = .none
    }

    /// Performs a "GET /api/v1/notes" request.
    ///
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func notes() throws -> Response {
        return try engine.get("/api/v1/notes")
    }

    /// Performs a "GET /api/v1/notes" request with a non-default
    /// "Accept: application/zip" header, which makes the API
    /// return all the notes for the current user in a ZIP file.
    ///
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func backup() throws -> Response {
        engine.accept = .zip
        let response = try engine.get("/api/v1/notes")
        engine.accept = .json
        return response
    }

    /// Performs a "GET /api/v1/notes/UUID" request.
    ///
    /// - Parameter id: a UUID representing a single note.
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func note(id: String) throws -> Response {
        return try engine.get("/api/v1/notes/\(id)")
    }

    /// Performs a "PUT /api/v1/notes/UUID/publish" request.
    /// This makes the note publicly available for everyone to see
    /// through a shortened, random "slug" parameter: `http://localhost/xyzab`
    ///
    /// - Parameter id: a UUID representing a single note.
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func publish(id: String) throws -> Response {
        return try engine.put("/api/v1/notes/\(id)/publish")
    }

    /// Performs a "PUT /api/v1/notes/UUID/unpublish" request.
    ///
    /// - Parameter id: a UUID representing a single note.
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func unpublish(id: String) throws -> Response {
        return try engine.put("/api/v1/notes/\(id)/unpublish")
    }

    /// Performs a "GET /slug" request. This returns an HTML page
    /// with the contents of the published note. If no page is available
    /// at this slug, the response will be a 404.
    ///
    /// - Parameter slug: a UUID representing a single note.
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func published(slug: String) throws -> Response {
        return try engine.get("/\(slug)")
    }

    /// Performs a "POST /api/v1/notes" request.
    ///
    /// - Parameter note: A map of string keys and string values representing a note.
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func create(note: [String: String]) throws -> Response {
        return try engine.post("/api/v1/notes", data: note)
    }

    /// Performs a "POST /api/v1/notes/search" request.
    ///
    /// - Parameter query: a string with the text to search.
    /// - Returns: the response of the call.
    /// - Throws: anything that the RequestEngine throws.
    func search(query: String) throws -> Response {
        return try engine.post("/api/v1/notes/search", data: ["query": query])
    }
}

