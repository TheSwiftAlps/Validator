import Infrastructure
import Foundation

struct StandardReporter: RunReporter {
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
        return ""
    }

    func report() {
        print()
    }
}

