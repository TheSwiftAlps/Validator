import Foundation

/// Data passed to the main program during the execution of a ScenarioSuite instance.
///
/// - success: Message indicating success.
/// - info: Message indicating information.
/// - error: Message indicating an error.
public enum ScenarioProgress {
    case success(message: String)
    case info(message: String)
    case error(message: String)
}
