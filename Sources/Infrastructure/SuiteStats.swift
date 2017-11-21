/// Structure holding the results of a ScenarioSuite run.
public struct SuiteStats {
    /// The number of scenarios run.
    public let scenarios: Int

    /// The number of tests aggregated across all scenarios.
    public let tests: Int

    /// The number of successful tests.
    public let passed: Int

    /// The number of failed tests.
    public let failed: Int

    /// The number of points acumulated.
    public let points: Int
}
