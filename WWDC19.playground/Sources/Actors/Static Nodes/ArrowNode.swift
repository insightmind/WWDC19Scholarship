import Foundation
import SpriteKit

/// The arrowNode represents a simple arrow in the game
class ArrowNode: SKSpriteNode {
    /// The filePath to the arrow image
    private static var arrowFilePath: String = "Levels/Assets/ArrowUp"

    /// Creates a new ArrowNode with the basic configuration
    public convenience init() {
        self.init(imageNamed: GameTheme.current.filePath(for: ArrowNode.arrowFilePath))
        self.size = CGSize(width: 16, height: 28)
        
        animateArrow()
    }

    /// Animates the arrowNode from left to right and back. If you want to use this instead of the default,
    /// make sure to remove other animations beforehand.
    public func alternateAnimateArrow() {
        let rightAction = SKAction.moveBy(x: 10, y: 0, duration: 0.8)
        let leftAction = SKAction.moveBy(x: -5, y: 0, duration: 0.4)

        let sequence = SKAction.sequence([leftAction, rightAction, leftAction])
        self.run(.repeatForever(sequence))
    }

    /// Animates the arrowNode from top to bottom and back. Is used as Default.
    private func animateArrow() {
        let upAction = SKAction.moveBy(x: 0, y: 10, duration: 0.8)
        let downAction = SKAction.moveBy(x: 0, y: -5, duration: 0.4)

        let sequence = SKAction.sequence([downAction, upAction, downAction])
        self.run(.repeatForever(sequence))
    }
}
