import Foundation
import RequestEngine

/// A scenario suite holds and executes a set of scenarios. A scenario is a
/// subclass of BaseScenario, itself exposing a `scenario()` method returning
/// a dictionary of Strings mapping to TestMethod instances.
public struct ScenarioSuite {
    /// Holds a collection of scenarios to be executed in sequence.
    let scenarios: [BaseScenario.Type]

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
    /// - Parameter reporter: A RunReporter method collecting ScenarioProgress instances.
    /// - Returns: An instance of SuiteStats with statistics about the scenario run.
    public func run(reporter: RunReporter) -> SuiteStats {
        var scenariosCount = 0
        var tests = 0
        var passed = 0
        var failed = 0
        for scenarioClass in scenarios {
            let scenarioObj = scenarioClass.init(api: self.api)
            if let scenarioTests = scenarioObj.scenario(), scenarioTests.count > 0 {
                scenariosCount += 1
                reporter.report(progress: .info(message: "Processing scenario: \(type(of: scenarioObj))"))
                for (testName, testMethod) in scenarioTests {
                    tests += 1
                    do {
                        try testMethod()
                        reporter.report(progress: .success(message: "\(testName) passed"))
                        passed += 1
                    }
                    catch BaseScenario.TestError<String>.failed(let message) {
                        reporter.report(progress: .error(message: "\(testName) failed: \(message)"))
                    }
                    catch BaseScenario.TestError<Int>.notEqual(let lhs, let rhs, let message) {
                        reporter.report(progress: .error(message: "\(testName) failed: expected \(lhs), got \(rhs) instead."))
                        reporter.report(progress: .error(message: "    Note: \(message)"))
                    }
                    catch BaseScenario.TestError<String>.notEqual(let lhs, let rhs, let message) {
                        reporter.report(progress: .error(message: "\(testName) failed: expected \(lhs), got \(rhs) instead."))
                        reporter.report(progress: .error(message: "    Note: \(message)"))
                    }
                    catch {
                        reporter.report(progress: .error(message: "\(testName) threw error: \(error)"))
                    }
                    if passed == 0 {
                        failed += 1
                    }
                }
                reporter.report()
            }
            else {
                reporter.report(progress: .info(message: "No tests for this scenario: \(type(of: scenarioObj))"))
            }
        }
        return SuiteStats(scenarios: scenariosCount, tests: tests, passed: passed, failed: failed)
    }
}
