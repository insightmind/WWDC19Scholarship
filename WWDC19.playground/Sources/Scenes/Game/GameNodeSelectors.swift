import Foundation

/// NodeSelectors are used to describe a specific node in the scene in
/// a more declarative way.
public enum GameNodeSelectors: String, NodeSelector {
    case giby
    case backButton
    case resetButton

    var isUserInteractable: Bool { return true }
}
