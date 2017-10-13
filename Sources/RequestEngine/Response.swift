import Foundation

public struct Response {
    public let status: Int
    public let contentType: String
    public let error: Error?
    public let json: [String: Any]?
    public let string: String?

    init(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        let resp = response as? HTTPURLResponse
        self.status = resp?.statusCode ?? 0
        self.contentType = resp?.allHeaderFields["Content-Type"] as? String ??  "Unknown content type"
        self.error = error
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
}

