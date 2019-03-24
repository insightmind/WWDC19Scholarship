import Foundation
import SpriteKit

/// The startNode represents a star in the LevelCompletion screen. It can be either active or inactive.
class StarNode: SKSpriteNode {
    /// The filePath to the image when the star is active
    private static var enabledFilePath: String { return GameTheme.current.filePath(for: "LevelCompletion/StarActive") }
    /// The filePath to the image when the star is inactive
    private static var disabledFilePath: String { return GameTheme.current.filePath(for: "LevelCompletion/StarInactive") }

    /// The texture used if the star is active
    private var enabledTexture: SKTexture { return SKTexture(imageNamed: StarNode.enabledFilePath) }
    /// The texture used if the star is inactive
    private var disabledTexture: SKTexture { return SKTexture(imageNamed: StarNode.disabledFilePath) }

    /// Determines whether the star is currently active or not.
    private(set) var isEnabled: Bool

    /// Creates a basic star node.
    ///
    /// - Parameter isEnabled: Whether the star is active or not at creation
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled

        let size = CGSize(width: 80, height: 80)
        let texture = SKTexture(imageNamed: isEnabled ? StarNode.enabledFilePath : StarNode.disabledFilePath)

        super.init(texture: texture, color: .clear, size: size)
    }

    /// Changes whether the star is active or not
    ///
    /// - Parameter isEnabled: true to activate star, false to deactivate it
    public func setIsEnabled(_ isEnabled: Bool) {
        self.texture = isEnabled ? enabledTexture : disabledTexture
        self.isEnabled = isEnabled
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
