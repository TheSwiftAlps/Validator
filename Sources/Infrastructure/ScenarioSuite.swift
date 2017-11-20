import Foundation
import Rainbow
import RequestEngine

public struct ScenarioSuite {
    let scenarios: [BaseScenario.Type]
    let api: API

    public init(server: String, scenarios: [BaseScenario.Type]) {

        let configuration: URLSessionConfiguration
        configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20

        let session = URLSession(configuration: configuration,
                             delegate: nil,
                             delegateQueue: OperationQueue())

        let engine = RequestEngine(server, session: session)
        self.api = API(engine)
        self.scenarios = scenarios
    }

    public func run() {
        for scenarioClass in scenarios {
            let scenarioCase = scenarioClass.init(api: self.api)
            if let scenario = scenarioCase.scenario(), scenario.count > 0 {
                print("Processing scenario: \(type(of: scenarioCase))".yellow.bold)
                for (testName, testMethod) in scenario {
                    do {
                        try testMethod()
                        print("\(testName) passed".green)
                    }
                    catch BaseScenario.TestError<String>.failed(let message) {
                        print("\(testName) failed: \(message)".red)
                    }
                    catch BaseScenario.TestError<Int>.notEqual(let lhs, let rhs, let message) {
                        print("\(testName) failed: expected \(lhs), got \(rhs) instead.".red)
                        print("    Note: \(message)".red)
                    }
                    catch BaseScenario.TestError<String>.notEqual(let lhs, let rhs, let message) {
                        print("\(testName) failed: expected \(lhs), got \(rhs) instead.".red)
                        print("    Note: \(message)".red)
                    }
                    catch {
                        print("\(testName) threw error: \(error)".red)
                    }
                }
            }
            else {
                print("No tests for this scenario! \(type(of: scenarioCase))".red.bold)
            }
        }
    }
}
