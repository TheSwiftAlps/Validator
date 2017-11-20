import Foundation

final public class DefaultUserTests: APITest {
    override func scenario() -> [(String, APITest.TestMethod)]? {
        return [
            ("Login default user", loginDefaultUser),
            ("Logout", logout),
        ]
    }
}

