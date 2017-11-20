import Foundation
import RequestEngine

/// A scenario suite holds and executes a set of scenarios. A scenario is a
/// subclass of BaseScenario, itself exposing a `scenario()` method returning
/// a dictionary of Strings mapping to TestMethod instances.
public struct ScenarioSuite {
    /// Holds a collection of scenarios to be executed in sequence.
    let scenarios: [BaseScenario.Type]
    
    /// Callback used by the "run()" method.
    public typealias RunCallback = (ScenarioProgress) -> Void

    /// The API object onto which the scenarios will be run.
    let api: API
    
    /// Initializes a new scenario suite.
    ///
    /// - Parameters:
    ///   - server: The URL to connect to.
    ///   - scenarios: The scenarios to execute.
    public init(server: URL, scenarios: [BaseScenario.Type]) {

        let configuration: URLSessionConfiguration
        configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 20

        let session = URLSession(configuration: configuration,
                             delegate: nil,
                             delegateQueue: OperationQueue())

        let engine = RequestEngine(server: server, session: session)
        self.api = API(engine)
        self.scenarios = scenarios
    }

    /// Main scenario runner. This method iterates over the set of scenarios,
    /// and for each scenario it executes the complete sequence of tests included within.
    ///
    /// - Parameter callback: A callback method taking a ScenarioProgress instance as parameter.
    /// - Returns: An instance of SuiteStats with statistics about the scenario run.
    public func run(callback: RunCallback) -> SuiteStats {
        var scenariosCount = 0
        var tests = 0
        var passed = 0
        var failed = 0
        for scenarioClass in scenarios {
            let scenarioObj = scenarioClass.init(api: self.api)
            if let scenarioTests = scenarioObj.scenario(), scenarioTests.count > 0 {
                scenariosCount += 1
                callback(.info(message: "Processing scenario: \(type(of: scenarioObj))"))
                for (testName, testMethod) in scenarioTests {
                    tests += 1
                    do {
                        try testMethod()
                        callback(.success(message: "\(testName) passed"))
                        passed += 1
                    }
                    catch BaseScenario.TestError<String>.failed(let message) {
                        callback(.error(message: "\(testName) failed: \(message)"))
                    }
                    catch BaseScenario.TestError<Int>.notEqual(let lhs, let rhs, let message) {
                        callback(.error(message: "\(testName) failed: expected \(lhs), got \(rhs) instead."))
                        callback(.error(message: "    Note: \(message)"))
                    }
                    catch BaseScenario.TestError<String>.notEqual(let lhs, let rhs, let message) {
                        callback(.error(message: "\(testName) failed: expected \(lhs), got \(rhs) instead."))
                        callback(.error(message: "    Note: \(message)"))
                    }
                    catch {
                        callback(.error(message: "\(testName) threw error: \(error)"))
                    }
                    if passed == 0 {
                        failed += 1
                    }
                }
            }
            else {
                callback(.info(message: "No tests for this scenario: \(type(of: scenarioObj))"))
            }
        }
        return SuiteStats(scenarios: scenariosCount, tests: tests, passed: passed, failed: failed)
    }
}
