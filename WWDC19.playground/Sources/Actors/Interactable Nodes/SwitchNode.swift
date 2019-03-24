import Foundation
import SpriteKit

/// The SwitchNode represents a switch inside the game to turn on or off associated
/// bridges
class SwitchNode: SKSpriteNode {
    /// The filePath to the image when the switch is active
    private static var powerOnFilePath: String { return GameTheme.current.filePath(for: "Levels/Assets/PowerOn") }
    /// The filePath to the image when the switch is not active
    private static var powerOffFilePath: String { return GameTheme.current.filePath(for: "Levels/Assets/PowerOff") }

    /// The texture applied to the node if the node is active
    private var powerOnTexture: SKTexture { return SKTexture(imageNamed: SwitchNode.powerOnFilePath) }
    /// The texture applied to the node if the node is not active
    private var powerOffTexture: SKTexture { return SKTexture(imageNamed: SwitchNode.powerOffFilePath) }

    /// The activation key is used to associate bridges with this node, so only they are triggered.
    private(set) var activationKey: String = ""
    /// Determines whether the switch in range of Giby so it can be tapped.
    private(set) var isEnabled: Bool = false

    /// Determines whether the switch is active or not
    var isActivated: Bool = false {
        didSet {
            if isActivated {
                texture = powerOnTexture
            } else {
                texture = powerOffTexture
            }
        }
    }

    /// Determines whether the switch is render upside down
    var isReversed: Bool = false {
        didSet {
            let factor: CGFloat = isReversed ? -1 : 1
            yScale = factor * abs(yScale)
        }
    }

    /// Creates a new SwitchNode with the specified color and key
    ///
    /// - Parameters:
    ///   - tint: The color which is applied to the node
    ///   - activationKey: The activation key which is used to associated bridges with this switch.
    public init(tint: UIColor, activationKey: String) {
        self.activationKey = activationKey

        let size = CGSize(width: 30, height: 30)
        let texture = SKTexture(imageNamed: SwitchNode.powerOffFilePath)
        super.init(texture: texture, color: tint, size: size)

        // We need to set the colorBlendFactor to on, so our tintColor is used instead of the image colors.
        self.colorBlendFactor = 1
        self.color = tint

        configurePhysicsBody()
    }

    /// Enables or disables the switch
    ///
    /// - Parameter isEnabled: true if it should be enabled otherwise false
    public func setIsEnabled(_ isEnabled: Bool) {
        color = self.color.withAlphaComponent(isEnabled ? 1 : 0.5)
        self.isEnabled = isEnabled
    }

    /// Configures the physicsBody of the Switch so Giby cannot walk through it.
    private func configurePhysicsBody() {
        let physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody.affectedByGravity = false
        physicsBody.pinned = true
        physicsBody.isDynamic = false

        self.physicsBody = physicsBody
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

