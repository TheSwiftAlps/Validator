import Foundation
import RequestEngine
import Tests

#if os(Linux)
// Required in Linux to initialize the random number generator.
// The arc4random() family of functions is not available
// outside of BSD-like Unixes.
srandom(UInt32(time(nil)))
#endif

// Get the URL of the server from the command line
let server = CommandLine.arguments[1]
let engine = RequestEngine(server)

let tests = [StatusCodeTests.self, UserTests.self]
let suite = TestSuite(engine: engine, tests: tests)
suite.run()

