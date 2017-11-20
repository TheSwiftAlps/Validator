public struct SuiteStats {
    public let scenarios: Int
    public let tests: Int
    public let passed: Int
    public let failed: Int
    
    init(_ scenarios: Int, _ tests: Int, _ passed: Int, _ failed: Int) {
        self.scenarios = scenarios
        self.tests = tests
        self.passed = passed
        self.failed = failed
    }
}
