import Rainbow
import RequestEngine

public struct TestSuite {
    public typealias TestFunction = (RequestEngine) throws -> ()

    let tests: [TestFunction]
    let engine: RequestEngine

    public init(engine: RequestEngine, tests: [TestFunction]) {
        self.engine = engine
        self.tests = tests
    }

    public func run() {
        for test in tests {
            do {
                try test(engine)
                print("Test \(test) passed".green)
            }
            catch let error {
                print("Test failed, \(error)".red)
            }
        }
    }
}
