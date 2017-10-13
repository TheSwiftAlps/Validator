import Rainbow
import RequestEngine

public struct TestSuite {
    let tests: [APITest.Type]
    let engine: RequestEngine

    public init(server: String, tests: [APITest.Type]) {
        self.engine = RequestEngine(server)
        self.tests = tests
    }

    public func run() {
        for testClass in tests {
            let testCase = testClass.init(engine: self.engine)
            print("Processing scenario: \(type(of: testCase))".yellow.bold)
            if let scenario = testCase.scenario() {
                for (testName, testMethod) in scenario {
                    do {
                        try testMethod()
                        print("Test \(testName) passed".green)
                    }
                    catch APITest.TestError<String>.failed(let message) {
                        print("Test \(testName) failed: \(message)".red)
                    }
                    catch APITest.TestError<Int>.notEqual(let lhs, let rhs, let message) {
                        print("Test \(testName) failed: expected \(lhs), got \(rhs) instead.".red)
                        print("    Note: \(message)".red)
                    }
                    catch {
                        print("Test \(testName) threw error: \(error)".red)
                    }
                }
            }
            else {
                print("No tests for this scenario!".red.bold)
            }
        }
    }
}
