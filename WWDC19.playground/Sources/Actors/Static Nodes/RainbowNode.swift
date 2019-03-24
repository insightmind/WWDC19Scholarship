import Foundation
import SpriteKit

/// The RainbowNode represents the rainbow animation seen in the levels.
class RainbowNode: SKSpriteNode {
    /// The filePath to the rainbow images
    private static let rainbowFilePath = "Levels/Assets/Rainbow/Rainbow"

    /// Creates a basic rainbow
    convenience init() {
        self.init(imageNamed: GameTheme.current.filePath(for: RainbowNode.rainbowFilePath + "1"))
        self.size = CGSize(width: 60, height: 180)
        startAnimation()
    }

    /// Starts the rainbow animation.
    private func startAnimation() {
        let textures = loadTextures()
        let titleSequence = SKAction.animate(with: textures, timePerFrame: 0.3)
        run(.repeatForever(titleSequence))
    }

    /// Loads all necessary textures for the animation
    ///
    /// - Returns: all textures which can be used to animate the rainbow.
    private func loadTextures() -> [SKTexture] {
        let filePath = GameTheme.current.filePath(for: RainbowNode.rainbowFilePath)
        return (1...10).compactMap { SKTexture(imageNamed: filePath + String($0)) }
    }
}
