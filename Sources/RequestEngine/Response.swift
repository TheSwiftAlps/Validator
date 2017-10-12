import Foundation

public struct Response {
    public let data: Data?
    public let response: HTTPURLResponse?
    public let error: Error?
    public let json: [String: Any]?
    public let string: String?

    init(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        self.data = data
        self.response = response as? HTTPURLResponse
        self.error = error
        do {
            self.json = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String: Any]
        }
        catch {
            self.json = nil
        }
        if let d = data {
            self.string = String(data: d, encoding: .utf8)
        }
        else {
            self.string = nil
        }
    }
}

