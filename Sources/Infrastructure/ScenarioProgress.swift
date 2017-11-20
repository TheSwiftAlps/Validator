import Foundation

public enum ScenarioProgress {
    case success(message: String)
    case info(message: String)
    case error(message: String)
}
