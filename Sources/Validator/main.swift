import Foundation
import Infrastructure
import Scenarios
import Rainbow
import Commander

// Exit codes:
// 0: no errors.
// 1: Wrong value to the --scenario parameter.
// 2: Invalid server parameter.
// 3: Normal execution but some tests failed.

#if os(Linux)
// Required in Linux to initialize the random number generator.
// The arc4random() family of functions is not available
// outside of BSD-like Unixes.
srandom(UInt32(time(nil)))
#endif

let scenarioList = [
    "ping": PingScenario.self,
    "user": UserScenario.self,
    "defaultUser": DefaultUserScenario.self,
    "publish": PublishingScenario.self,
    "search": SearchScenario.self
]

let keys = validKeys(list: scenarioList)
let scenarioOptionDescription = "Name of the scenario to execute: all, \(keys)"
let scenarioOption = Option("scenario", default: "all", description: scenarioOptionDescription)

let argument = Argument<String>("server", description: "The server being tested.")

let main = command(argument, scenarioOption) { server, chosenScenario in
    if let url = URL(string: server) {
        let scenarios = filterScenarios(chosen: chosenScenario, list: scenarioList)
        if scenarios.count == 0 {
            print("Wrong scenario name: \(chosenScenario)".red)
            exit(1)
        }
        let suite = ScenarioSuite(server: url, scenarios: scenarios)
        let stats = suite.run { progress in
            switch progress {
            case ScenarioProgress.success(let text):
                print(text.green)
            case ScenarioProgress.info(let text):
                print(text.yellow)
            case ScenarioProgress.error(let text):
                print(text.red)
            }
        }
        print("\n---")
        let message = "Executed \(stats.scenarios) scenarios with \(stats.tests) tests: \(stats.passed) passed, \(stats.failed) failed.\n"
        if stats.failed > 0 {
            print(message.red)
            exit(3)
        }
        else {
            print(message.green)
            exit(0)
        }
    }
    else {
        print("Invalid parameter (\(server))".red)
        exit(2)
    }
}

main.run()

