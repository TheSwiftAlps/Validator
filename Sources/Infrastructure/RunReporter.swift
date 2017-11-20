public protocol RunReporter {
    func report(progress: ScenarioProgress)
    func report()
    func display() -> String
}
