import Foundation

/// Performs HTTP requests synchronously.
/// To be used in command-line environments only.
public final class RequestEngine {

    /// Represents an authentication mechanism for the RequestEngine class.
    /// The `header()` method automatically builds the required "Authorization"
    /// HTTP header required for the connection.
    ///
    /// - none: No authentication type.
    /// - basic: HTTP Basic Authentication type (RFC 2617).
    /// - token: HTTP Token Authentication type (RFC 6750).
    public enum AuthenticationType {
        /// No authentication.
        case none
        /// HTTP Basic Authentication type (RFC 2617).
        case basic(String, String)
        /// HTTP Token Authentication type (RFC 6750).
        case token(String)

        /// Returns the "Authorization" HTTP header that corresponds to
        /// the current authentication type.
        ///
        /// - Returns: A string with a matching "Authorization" header.
        func header() -> String? {
            switch self {
                case .none: return nil
                case .basic(let user, let pass): return basicAuthString(user, pass)
                case .token(let value): return tokenAuthString(value)
            }
        }

        /// Returns a "Bearer XXXXXXXXXX" token authorization header.
        /// The resulting string matches the requirements of RFC 6750.
        ///
        /// - Parameter token: The token to use in the header.
        /// - Returns: An "Authorization" HTTP header.
        private func tokenAuthString(_ token: String) -> String? {
            let authString = "Bearer \(token)"
            return authString
        }

        /// Returns a "Basic XXXXXXXXXX" basic authorization header.
        /// The username and password are encoded with Base64 as per RFC 2617.
        ///
        /// - Parameters:
        ///   - username: The username for the endpoint.
        ///   - password: The password for the endpoint.
        /// - Returns: An "Authorization" HTTP header.
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

    /// The possible HTTP request methods used by the RequestEngine.
    ///
    /// - post: POST method, usually for creation purposes.
    /// - get: GET method, usually for query purposes.
    /// - put: PUT method, usually for modification purposes.
    /// - delete: DELETE method, usually for deletion purposes.
    public enum RequestMethod: String {
        /// POST method, usually for creation purposes.
        case post = "POST"
        /// GET method, usually for query purposes.
        case get = "GET"
        /// PUT method, usually for modification purposes.
        case put = "PUT"
        /// DELETE method, usually for deletion purposes.
        case delete = "DELETE"
    }

    /// Types of errors thrown by the RequestEngine.
    ///
    /// - cannotConvertStringToURL: Thrown when the endpoint URL cannot be build properly.
    public enum LocalError: Error {
        /// Thrown when the endpoint URL cannot be build properly.
        case cannotConvertStringToURL
    }

    /// Different types of data exchanged with the remote service.
    ///
    /// - json: JSON MIME type
    /// - zip: ZIP MIME type
    /// - html: HTML MIME type
    public enum MimeType: String {
        /// JSON MIME type
        case json = "application/json; charset=utf-8"
        /// ZIP MIME type
        case zip = "application/zip"
        /// HTML MIME type
        case html = "text/html; charset=utf-8"
    }

    /// The base URL of the server this component is connecting to.
    private let baseURL: URL

    /// A URLSession object used to channel all requests.
    private let session: URLSession

    /// The type of authentication for the next requests.
    public var auth = AuthenticationType.none

    /// The value of the "Content-Type" header to be sent with each request.
    public var contentType = MimeType.json

    /// The value of the "Accept" header to be sent with each request.
    public var accept = MimeType.json

    /// Initializes a new instance.
    ///
    /// - Parameter baseURL: The base URL for this component, like `http://server.com`
    ///                      (without a trailing slash)
    public init(server: URL, session: URLSession) {
        self.baseURL = server
        self.session = session
    }
}

// MARK: - Public methods
extension RequestEngine {
    /// Sends a GET request and returns the response.
    ///
    /// - Parameter endpoint: The endpoint for the request, like `/path/endpoint`.
    /// - Returns: A Response object.
    /// - Throws: whatever RequestEngine.createRequest throws.
    public func get(_ endpoint: String) throws -> Response {
        let request = try createRequest(.get, endpoint)
        return session.send(request)
    }

    /// Sends a POST request and returns the response.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint for the request, like `/path/endpoint`.
    ///   - data: A dictionary of values to be serialized in JSON.
    /// - Returns: A Response object.
    /// - Throws: whatever RequestEngine.createRequest throws.
    public func post(_ endpoint: String, data: [String:Any]? = nil) throws -> Response {
        let request = try createRequest(.post, endpoint, data)
        return session.send(request)
    }

    /// Sends a PUT request and returns the response.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint for the request, like `/path/endpoint`.
    ///   - data: A dictionary of values to be serialized in JSON.
    /// - Returns: A Response object.
    /// - Throws: whatever RequestEngine.createRequest throws.
    public func put(_ endpoint: String, data: [String:Any]? = nil) throws -> Response {
        let request = try createRequest(.put, endpoint, data)
        return session.send(request)
    }

    /// Sends a DELETE request and returns the response.
    ///
    /// - Parameter endpoint: The endpoint for the request, like `/path/endpoint`.
    /// - Returns: A Response object.
    /// - Throws: whatever RequestEngine.createRequest throws.
    public func delete(_ endpoint: String) throws -> Response {
        let request = try createRequest(.delete, endpoint)
        return session.send(request)
    }
}

// MARK: - Private methods
extension RequestEngine {
    /// Creates a URL request object with the required parameters.
    ///
    /// - Parameters:
    ///   - method: The method of the request.
    ///   - endpoint: The endpoint of the request, in the form `/path/endpoint`
    ///   - data: A dictionary of data to send as JSON to the server.
    /// - Returns: A URLRequest object ready to be sent.
    /// - Throws: If the `baseURL` + `endpoint` cannot be converted to a URL.
    private func createRequest(_ method: RequestMethod, _ endpoint: String, _ data: [String:Any]? = nil) throws -> URLRequest {

        guard let url = URL(string: baseURL.absoluteString + endpoint) else {
            throw LocalError.cannotConvertStringToURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(accept.rawValue, forHTTPHeaderField: "Accept")
        request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")

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

