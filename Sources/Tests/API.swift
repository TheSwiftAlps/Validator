import RequestEngine

public struct API {
    let engine: RequestEngine

    init(_ engine: RequestEngine) {
        self.engine = engine
    }

    func ping() throws -> Response {
        return try engine.get("/ping")
    }

    func create(user: [String: String]) throws -> Response {
        return try engine.post("/api/v1/users", data: user)
    }

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

    func logout() {
        engine.auth = .none
    }

    func notes() throws -> Response {
        engine.contentType = "application/json"
        return try engine.get("/api/v1/notes")
    }

    func backup() throws -> Response {
        engine.contentType = "application/zip"
        return try engine.get("/api/v1/notes")
    }

    func note(id: String) throws -> Response {
        return try engine.get("/api/v1/notes/\(id)")
    }

    func create(note: [String: String]) throws -> Response {
        return try engine.post("/api/v1/notes", data: note)
    }
}

