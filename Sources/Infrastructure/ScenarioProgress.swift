import Foundation

/// Data passed to the main program during the execution of a ScenarioSuite instance.
///
/// - success: Message indicating success.
/// - info: Message indicating information.
/// - error: Message indicating an error.
public enum ScenarioProgress {
    /// Message indicating success.
    case success(message: String)
    /// Message indicating information.
    case info(message: String)
    /// Message indicating an error.
    case error(message: String)
}
