import Infrastructure

class JUnitReporter: RunReporter {
    var stats: SuiteStats? = nil
    var overallProgress = [ScenarioProgress]()

    func report(progress: ScenarioProgress) {
        overallProgress.append(progress)
    }

    func report() {
    }

    func display() -> String {
        if let stats = stats {
            var output = """
            <testsuite tests="\(stats.tests)">\n
            """
            for progress in overallProgress {
                switch progress {
                case ScenarioProgress.success(let text):
                    output += "<testcase name=\"\(text)\"/>\n"
                case ScenarioProgress.info:
                    break
                case ScenarioProgress.error(let text):
                    output += """
                    <testcase>
                    <failure>\(text)</failure>
                    </testcase>
                    """
                    print(text.red)
                }
            }
            output += """
            </testsuite>
            """
            return output
        }
        return ""
    }

    func add(stats: SuiteStats) {
        self.stats = stats
    }
}

