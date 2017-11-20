import Foundation

extension Int {
    /// Returns a random integer between zero and the current number.
    ///
    /// - Returns: A random integer.
    public func randomFromZeroToMe() -> Int {
        #if os(Linux)
            // Nope, no arc4random outside of BSD...
            return Int(UInt32(random()) % self)
        #else
            return Int(arc4random_uniform(UInt32(self)))
        #endif
    }
}
