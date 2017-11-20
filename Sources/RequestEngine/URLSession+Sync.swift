import Foundation

#if os(Linux)
import Dispatch
#endif

extension URLSession {
    /// Sends an HTTP request synchronously. This method blocks!
    /// Adapted from
    /// https://stackoverflow.com/a/34308158/133764
    ///
    /// - Parameter request: The URL request to send.
    /// - Returns: A Response object with the results of the request.
    func send(_ request: URLRequest) -> Response {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: request) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return Response(data, response, error)
    }
}

