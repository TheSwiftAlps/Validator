import Foundation

/// Represents a response returned from the RequestEngine class.
/// This class wraps the URLResponse returned by the URLSession
/// call and automatically performs JSON deserialization and other tasks.
public struct Response {
    /// The status code returned by the server.
    public let status: StatusCode

    /// The value of the "Content-Type" header returned by the server.
    public let contentType: String

    /// An eventual error returned by URLSession when performing the request.
    public let error: Error?

    /// The actual JSON data, ready to be used.
    public let json: [String: Any]?

    /// The string data sent by the server.
    public let string: String?

    /// The raw binary data sent by the server.
    public let data: Data?

    /// All the headers returned by the server.
    public let headers: [AnyHashable: Any]?

    /// Possible status codes in responses
    ///
    /// - invalid: no valid value
    /// - ok: HTTP 200
    /// - notFound: HTTP 404
    /// - error: HTTP 500
    /// - notAuthorized: HTTP 401
    public enum StatusCode: Int {
        /// No valid value
        case invalid = 0
        /// HTTP 200
        case ok = 200
        /// HTTP 404
        case notFound = 404
        /// HTTP 500
        case error = 500
        /// HTTP 401
        case notAuthorized = 401
    }

    /// Initializer.
    ///
    /// - Parameters:
    ///   - data: The data received from the HTTP call.
    ///   - response: The URLResponse object returned by URLSession.
    ///   - error: An eventual error caused by the HTTP call.
    init(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        let resp = response as? HTTPURLResponse
        let statusCode = resp?.statusCode ?? 0

        self.status = StatusCode(rawValue: statusCode) ?? .invalid
        self.headers = resp?.allHeaderFields
        self.contentType = resp?.allHeaderFields["Content-Type"] as? String ??  "Unknown content type"
        self.error = error
        self.data = data
        do {
            if let d = data {
                self.json = try JSONSerialization.jsonObject(with: d, options:[]) as? [String: Any]
                self.string = String(data: d, encoding: .utf8)
            }
            else {
                self.string = nil
                self.json = nil
            }
        }
        catch {
            self.string = nil
            self.json = nil
        }
    }

    /// Saves the contents of a response to a particular local URL.
    ///
    /// - Parameter url: The URL to save this response to.
    /// - Throws: any errors happened during saving.
    public func save(at url: URL) throws {
        if let d = data {
            try d.write(to: url)
        }
    }
}

