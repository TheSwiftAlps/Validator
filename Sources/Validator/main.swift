import Foundation
import Infrastructure
import Scenarios
import Rainbow
import Commander

#if os(Linux)
// Required in Linux to initialize the random number generator.
// The arc4random() family of functions is not available
// outside of BSD-like Unixes.
srandom(UInt32(time(nil)))
#endif

let main = command(Argument<String>("server", description: "The server being tested.")) { server in
    if let url = URL(string: server) {
        let scenarios = [
            PingScenario.self,
            UserScenario.self,
            DefaultUserScenario.self,
            PublishingScenario.self,
            SearchScenario.self,
        ]
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
            exit(1)
        }
        else {
            print(message.green)
            exit(0)
        }
    }
    else {
        print("Invalid parameter (\(server))".red)
        exit(3)
    }
}

main.run()

