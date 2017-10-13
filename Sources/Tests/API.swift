import RequestEngine

public struct API {
    let engine: RequestEngine

    init(_ engine: RequestEngine) {
        self.engine = engine
    }

    func ping() throws -> Response {
        return try engine.get("/ping")
    }

    func post(user: [String: String]) throws -> Response {
        return try engine.post("/api/v1/users", data: user)
    }

    func login(user: String, pass: String) throws {
        engine.auth = .basic(user, pass)
        let response = try engine.post("/api/v1/login")
        if let json = response.json {
            let token = json["token"] as! String
            engine.auth = .token(token)
        }
        else {
            engine.auth = .none
        }
    }

    func logout() {
        engine.auth = .none
    }

    func getNotes() throws -> Response {
        return try engine.get("/api/v1/notes")
    }

    func post(note: [String: String]) throws -> Response {
        return try engine.post("/api/v1/notes", data: note)
    }
}

