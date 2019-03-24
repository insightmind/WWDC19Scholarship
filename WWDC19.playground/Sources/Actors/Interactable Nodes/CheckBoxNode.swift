import Foundation
import SpriteKit

/// The CheckBoxNode provides a simple node which displays a checkBox with on and off state.
class CheckBoxNode: SKSpriteNode {
    /// The filepath to the enabled image
    private static var enabledFilePath: String { return GameTheme.current.filePath(for: "Settings/CheckOn") }
    /// The filepath to the disabled image
    private static var disabledFilePath: String { return GameTheme.current.filePath(for: "Settings/CheckOff") }

    /// The texture used if enabled
    private var enabledTexture: SKTexture { return SKTexture(imageNamed: CheckBoxNode.enabledFilePath) }
    /// The texture used if disabled
    private var disabledTexture: SKTexture { return SKTexture(imageNamed: CheckBoxNode.disabledFilePath) }

    /// Determines whether the view is currently enabled or not
    private(set) var isEnabled: Bool

    /// Creates a new CheckBoxNode
    ///
    /// - Parameter isEnabled: Determines whether the CheckBox is enabled or disabled at creation.
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled

        let size = CGSize(width: 30, height: 30)
        let texture = SKTexture(imageNamed: isEnabled ? CheckBoxNode.enabledFilePath : CheckBoxNode.disabledFilePath)

        super.init(texture: texture, color: .clear, size: size)
    }

    /// Changes the state of the CheckBox to the given parameter.
    ///
    /// - Parameter isEnabled: Enables the CheckBox if true otherwise disables it
    public func setIsEnabled(_ isEnabled: Bool) {
        self.texture = isEnabled ? enabledTexture : disabledTexture
        self.isEnabled = isEnabled
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
