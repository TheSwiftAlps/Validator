import Infrastructure
import Foundation

class StandardReporter: RunReporter {
    var stats: SuiteStats? = nil

    func report(progress: ScenarioProgress) {
        switch progress {
        case ScenarioProgress.success(let text):
            print(text.green)
        case ScenarioProgress.info(let text):
            print(text.yellow)
        case ScenarioProgress.error(let text):
            print(text.red)
        }
    }

    func display() -> String {
        if let stats = stats {
            var output = ""
            // Show stats at the end
            output += "\n---\n"
            let message = "Executed \(stats.scenarios) scenarios with \(stats.tests) tests: \(stats.passed) passed, \(stats.failed) failed.\n"
            if stats.failed > 0 {
                output += message.red
            }
            else {
                output += message.green
            }
            return output
        }
        return ""
    }

    func report() {
        print()
    }

    func add(stats: SuiteStats) {
        self.stats = stats
    }
}

