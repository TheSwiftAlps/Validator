import Infrastructure

/// This scenario tests whether the API has defined the default user "vapor@theswiftalps.com"
final public class DefaultUserScenario: BaseScenario {
    
    /// This scenario consists of
    /// 1. Login using the default user credentials.
    /// 2. Logout.
    ///
    /// - Returns: A dictionary of string descriptions and test methods.
    public override func scenario() -> [(String, BaseScenario.TestMethod)]? {
        return [
            ("Login default user", loginDefaultUser),
            ("Logout", logout),
        ]
    }
}

