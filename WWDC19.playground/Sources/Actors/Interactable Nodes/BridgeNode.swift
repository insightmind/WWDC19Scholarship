import Foundation
import SpriteKit

/// A BridgeNode is used as a blockade which can be
/// enabled or disabled via a switchNode
class BridgeNode: SKShapeNode {
    /// It the bridgeNode is enabled, it is a blockade for Giby
    /// If it is disabled Giby can walk and fly through this node.
    var isEnabled: Bool = false {
        didSet {
            if isEnabled {
                removeAllChildren()
                fillColor = fillColor.withAlphaComponent(1)
                setPhysicsBody()
            } else {
                addDashed()
                fillColor = fillColor.withAlphaComponent(0.2)
                removePhysicsBody()
            }
        }
    }

    /// The activationKey is used to associated this node with a switch node, which should activate it.
    private(set) var activationKey: String
    /// The size of the node
    private var size: CGSize?

    /// Creates a new BridgeNode
    ///
    /// - Parameters:
    ///   - size: The size of the node
    ///   - tint: The tintColor of the node
    ///   - activationKey: The activationKey associated with a switch
    init(size: CGSize, tint: UIColor, activationKey: String) {
        self.activationKey = activationKey
        super.init()
        
        let rect = CGRect(origin: .zero, size: size)
        
        self.path = CGPath(rect: rect, transform: nil)
        self.fillColor = tint.withAlphaComponent(0.2)
        self.strokeColor = .clear
        self.size = size
        self.zPosition = -10

        addDashed()
    }

    /// Dashes the BorderLine of this node
    private func addDashed() {
        guard let path = path else { return }
        let pattern: [CGFloat] = [5.0, 5.0]
        let dashedPath = path.copy(dashingWithPhase: 1, lengths: pattern)
        let shapeNode = SKShapeNode(path: dashedPath)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = fillColor.withAlphaComponent(1)
        shapeNode.lineWidth = 2
        self.addChild(shapeNode)
    }

    /// Sets the physicsBody of this node when enabled.
    private func setPhysicsBody() {
        guard let size = size else { return }
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let physicsBody = SKPhysicsBody(rectangleOf: size, center: center)
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = false
        physicsBody.pinned = true

        self.physicsBody = physicsBody
    }

    /// Removes the physicsBody of this node when disabled
    private func removePhysicsBody() {
        self.physicsBody = nil
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
