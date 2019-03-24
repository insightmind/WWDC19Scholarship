import Foundation
import SpriteKit

/// The GoalNode represents the goal of a level
class GoalNode: SKSpriteNode {
    /// The image of the goalField which tells the user when he solved the level
    private static var goalFieldFilePath: String = "Levels/Assets/Goal"

    /// The arrowNode which shows at which direction the GoalNode is turned.
    lazy var arrowSpriteNode = ArrowNode()

    /// Creates a new GoalNode with the default configuration
    public convenience init() {
        self.init(imageNamed: GameTheme.current.filePath(for: GoalNode.goalFieldFilePath))
        self.size = CGSize(width: 44, height: 64)

        addChild(arrowSpriteNode)
    }

    /// Reverses the arrow of the GoalNode
    ///
    /// - Parameter isReversed: Whether the arrow should be reversed or not.
    public func setReverse(isReversed: Bool) {
        let factor: CGFloat = isReversed ? -1 : 1
        yScale = factor * abs(arrowSpriteNode.yScale)
    }
}
