import Infrastructure

/// Test Anything Protocol reporter, based on the specification at
/// https://testanything.org/
class TapReporter: RunReporter {
    var output = ""
    var count = 0

    func report(progress: ScenarioProgress) {
        switch progress {
        case ScenarioProgress.success(let text):
            count += 1
            output += "ok \(count) - \(text)\n"
        case ScenarioProgress.info(let text):
            output += "# \(text)\n"
        case ScenarioProgress.error(let text):
            count += 1
            output += "not ok \(count) - \(text)\n"
        }
    }

    func report() {
        output += "\n"
    }

    func display() -> String {
        return "1..\(count)\n\(output)"
    }
}
