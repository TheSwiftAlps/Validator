import Infrastructure

final public class DefaultUserTests: BaseScenario {
    public override func scenario() -> [(String, BaseScenario.TestMethod)]? {
        return [
            ("Login default user", loginDefaultUser),
            ("Logout", logout),
        ]
    }
}

