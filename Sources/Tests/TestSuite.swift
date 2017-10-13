import Rainbow
import RequestEngine

public struct TestSuite {
    let tests: [APITest.Type]
    let engine: RequestEngine

    public init(engine: RequestEngine, tests: [APITest.Type]) {
        self.engine = engine
        self.tests = tests
    }

    public func run() {
        for testClass in tests {
            let testCase = testClass.init(engine: self.engine)
            print("Processing tests: \(type(of: testCase))".yellow.bold)
            if let allTests = testCase.allTests() {
                for (testName, testMethod) in allTests {
                    do {
                        try testMethod()
                        print("Test \(testName) passed".green)
                    }
                    catch APITest.TestError.failed(let message) {
                        print("Test \(testName) failed: \(message)".red)
                    }
                    catch {
                        print("Test \(testName) threw error: \(error)".red)
                    }
                }
            }
        }
    }
}
