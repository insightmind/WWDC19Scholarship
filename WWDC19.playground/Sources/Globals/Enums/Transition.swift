import Foundation
import SpriteKit

/// Easier access to SKTransitions with predefined values
public enum Transition {
    case crossDisolve
    case moveIn(direction: SKTransitionDirection)
    case push(direction: SKTransitionDirection)
    case reveal(direction: SKTransitionDirection)

    /// Returns the associated SKTransition
    var skTransition: SKTransition {
        switch self {
        case .crossDisolve:
            return SKTransition.crossFade(withDuration: 0.5)

        case let .push(direction):
            return SKTransition.push(with: direction, duration: 0.5)

        case let .moveIn(direction):
            return SKTransition.moveIn(with: direction, duration: 0.5)

        case let .reveal(direction):
            return SKTransition.reveal(with: direction, duration: 0.5)
        }
    }
}
