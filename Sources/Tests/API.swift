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
        return try engine.get("/api/v1/notes")
    }

    func backup() throws -> Response {
        engine.accept = .zip
        let response = try engine.get("/api/v1/notes")
        engine.accept = .json
        return response
    }

    func note(id: String) throws -> Response {
        return try engine.get("/api/v1/notes/\(id)")
    }

    func publish(id: String) throws -> Response {
        return try engine.put("/api/v1/notes/\(id)/publish")
    }

    func unpublish(id: String) throws -> Response {
        return try engine.put("/api/v1/notes/\(id)/unpublish")
    }

    func published(slug: String) throws -> Response {
        return try engine.get("/\(slug)")
    }

    func create(note: [String: String]) throws -> Response {
        return try engine.post("/api/v1/notes", data: note)
    }
}

