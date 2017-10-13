import Foundation


public final class RequestEngine {

    public enum AuthenticationType {
        case none
        case basic(String, String)
        case token(String)

        func header() -> String? {
            switch self {
                case .none: return nil
                case .basic(let user, let pass): return basicAuthString(user, pass)
                case .token(let value): return tokenAuthString(value)
            }
        }

        private func tokenAuthString(_ token: String) -> String? {
            let authString = "Bearer \(token)"
            return authString
        }

        private func basicAuthString(_ username: String, _ password: String) -> String? {
            let loginString = "\(username):\(password)"
            guard let loginData: Data = loginString.data(using: .utf8) else {
                return nil
            }
            let base64LoginString = loginData.base64EncodedString(options: [])
            let authString = "Basic \(base64LoginString)"

            return authString
        }
    }

    private let baseURL: String
    private let session: URLSession
    private let configuration: URLSessionConfiguration
    public var auth = AuthenticationType.none
    public var contentType = "application/json; charset=utf-8"

    public init(_ baseURL: String) {
        self.baseURL = baseURL

        configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20

        session = URLSession(configuration: configuration,
            delegate: nil,
            delegateQueue: OperationQueue())
    }

    private enum RequestMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }

    public enum LocalError: Error {
        case cannotConvertUTF8ToData
        case cannotConvertStringToURL
    }

    public func get(_ endpoint: String) throws -> Response {
        let request = try createRequest(.get, endpoint)
        return session.send(request)
    }

    public func post(_ endpoint: String, data: [String:Any]? = nil) throws -> Response {
        let request = try createRequest(.post, endpoint, data)
        return session.send(request)
    }

    public func put(_ endpoint: String, data: [String:Any]?) throws -> Response {
        let request = try createRequest(.put, endpoint, data)
        return session.send(request)
    }

    public func patch(_ endpoint: String, data: [String:Any]?) throws -> Response {
        let request = try createRequest(.patch, endpoint, data)
        return session.send(request)
    }

    public func delete(_ endpoint: String) throws -> Response {
        let request = try createRequest(.delete, endpoint)
        return session.send(request)
    }

    private func createRequest(_ method: RequestMethod, _ endpoint: String, _ data: [String:Any]? = nil) throws -> URLRequest {

        guard let url = URL(string: baseURL + endpoint) else {
            throw LocalError.cannotConvertStringToURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(contentType, forHTTPHeaderField: "Accept")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        if let userAuthString = self.auth.header() {
            request.setValue(userAuthString, forHTTPHeaderField: "Authorization")
        }
        if let postData = data {
            let json: Data = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = json
        }
        return request
    }
}

