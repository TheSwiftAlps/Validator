import Infrastructure

final public class DefaultUserScenario: BaseScenario {
    public override func scenario() -> [(String, BaseScenario.TestMethod)]? {
        return [
            ("Login default user", loginDefaultUser),
            ("Logout", logout),
        ]
    }
}

