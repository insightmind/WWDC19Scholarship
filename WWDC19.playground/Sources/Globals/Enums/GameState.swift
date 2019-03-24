import Foundation
import SpriteKit

/// Enum representing each state of the game
///
/// - menu: Defines that the game shows the menu
/// - settings: Defines that the game shows the settings
/// - levels: Defines that the game shows the levelSelection
/// - levelCompletion: Defines that the game shows the levelCompletion
/// - play: Defines that the game shows the a level specified by the levelNum
public enum GameState: Equatable {
    case menu
    case settings
    case levels
    case levelCompletion
    case play(level: Int)

    /// Loads the scene type associated with the state
    ///
    /// - Returns: the type of scene used to represent this state.
    func loadScene() -> FlowableScene.Type {
        switch self {
        case .menu:
            return MenuScene.self

        case .levelCompletion:
            return LevelCompletionScene.self

        case .levels:
            return LevelSelectionScene.self

        case .settings:
            return SettingsScene.self

        case .play(_):
            return GameScene.self
        }
    }

    /// Generates the levelNum for the current state.
    ///
    /// - Returns: Returns number of level if in state .play, otherwise returns -1
    func generateLevelNum() -> Int {
        switch self {
        case let .play(num):
            return num

        default:
            return -1
        }
    }
}
