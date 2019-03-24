import SpriteKit

struct PhysicsBodyConfig: Codable {
    var rect: CGRect

    func generateNode() -> SKShapeNode {
        let node = SKShapeNode(rect: rect)
        let physicsBody = SKPhysicsBody(rectangleOf: rect.size)
        physicsBody.affectedByGravity = false
        physicsBody.pinned = true
        physicsBody.isDynamic = false

        node.physicsBody = physicsBody
        node.fillColor = .clear
        node.strokeColor = .clear
        node.position = rect.origin

        return node
    }
}
