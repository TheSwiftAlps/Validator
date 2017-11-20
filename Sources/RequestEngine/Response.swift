import Foundation

/// Represents a response returned from the RequestEngine class.
/// This class wraps the URLResponse returned by the URLSession
/// call and automatically performs JSON deserialization and other tasks.
public struct Response {
    public let status: StatusCode
    public let contentType: String
    public let error: Error?
    public let json: [String: Any]?
    public let string: String?
    public let data: Data?
    public let headers: [AnyHashable: Any]?
    
    /// Possible status codes in responses
    ///
    /// - invalid: no valid value
    /// - ok: HTTP 200
    /// - notFound: HTTP 404
    /// - error: HTTP 500
    /// - notAuthorized: HTTP 401
    public enum StatusCode: Int {
        case invalid = 0
        case ok = 200
        case notFound = 404
        case error = 500
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

