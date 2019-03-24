import SpriteKit

struct RainbowConfig: Codable {
    var position: CGPoint
    var rotation: CGFloat

    func generateNode() -> RainbowNode {
        let node = RainbowNode()
        node.position = position
        node.zRotation = rotation
        return node
    }
}
