import Foundation
import Infrastructure
import Scenarios

#if os(Linux)
// Required in Linux to initialize the random number generator.
// The arc4random() family of functions is not available
// outside of BSD-like Unixes.
srandom(UInt32(time(nil)))
#endif

// Get the URL of the server from the command line
let server = CommandLine.arguments[1]

let scenarios = [
    StatusCodeTests.self,
    UserTests.self,
    DefaultUserTests.self,
    PublishingTests.self,
    SearchTests.self,
]
let suite = ScenarioSuite(server: server, scenarios: scenarios)
suite.run()
