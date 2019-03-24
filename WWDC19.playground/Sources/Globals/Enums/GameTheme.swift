import UIKit

/// Enum representing the themes of the game
public enum GameTheme: Int, CaseIterable {
    case neon
    case bold

    /// The current theme of the game
    static var current: GameTheme = .bold

    /// The filePathPrefix used to find the correct files depending the current theme
    var filePathPrefix: String {
        switch self {
        case .neon:
            return "Neon"

        case .bold:
            return "Bold"
        }
    }

    /// Defines whether glow is allowed in the game to be applied
    var allowsGlow: Bool {
        switch self {
        case .neon:
            // Turned of because of performance issues
            return false

        case .bold:
            return false
        }
    }

    /// The backgroundColor of the game depending the state
    var backgroundColor: UIColor {
        switch self {
        case .neon:
            return UIColor.blueishBlack

        case .bold:
            return UIColor.white
        }
    }

    /// Creates a file path with the gameTheme prefix
    ///
    /// - Parameter path: The path which should be prefixed
    /// - Returns: The prefixed path which can be used to get resources.
    func filePath(for path: String) -> String {
        return filePathPrefix + "/" + path
    }
}
