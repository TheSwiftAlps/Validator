import Rainbow
import RequestEngine

public struct TestSuite {
    let tests: [APITest.Type]
    let api: API

    public init(server: String, tests: [APITest.Type]) {
        let engine = RequestEngine(server)
        self.api = API(engine)
        self.tests = tests
    }

    public func run() {
        for testClass in tests {
            let testCase = testClass.init(api: self.api)
            if let scenario = testCase.scenario(), scenario.count > 0 {
                print("Processing scenario: \(type(of: testCase))".yellow.bold)
                for (testName, testMethod) in scenario {
                    do {
                        try testMethod()
                        print("\(testName) passed".green)
                    }
                    catch APITest.TestError<String>.failed(let message) {
                        print("\(testName) failed: \(message)".red)
                    }
                    catch APITest.TestError<Int>.notEqual(let lhs, let rhs, let message) {
                        print("\(testName) failed: expected \(lhs), got \(rhs) instead.".red)
                        print("    Note: \(message)".red)
                    }
                    catch APITest.TestError<String>.notEqual(let lhs, let rhs, let message) {
                        print("\(testName) failed: expected \(lhs), got \(rhs) instead.".red)
                        print("    Note: \(message)".red)
                    }
                    catch {
                        print("\(testName) threw error: \(error)".red)
                    }
                }
            }
            else {
                print("No tests for this scenario! \(type(of: testCase))".red.bold)
            }
        }
    }
}
