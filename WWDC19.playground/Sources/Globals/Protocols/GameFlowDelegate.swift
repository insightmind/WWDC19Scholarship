import Foundation
import SpriteKit

public protocol GameFlowDelegate: AnyObject {
    func transition(to scene: SKScene, with transition: SKTransition)
    func changeGameState(to state: GameState, with transition: Transition)
}
