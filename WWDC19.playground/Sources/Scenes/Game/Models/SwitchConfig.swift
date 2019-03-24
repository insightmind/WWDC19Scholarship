import SpriteKit

struct SwitchConfig: Codable {
    var key: String
    var color: Color
    var position: CGPoint
    var isReversed: Bool
    var name: String
    var isActive: Bool

    init(key: String, color: UIColor, position: CGPoint, isReversed: Bool, name: String, isActive: Bool) {
        self.key = key
        self.color = Color(color: color)
        self.position = position
        self.isReversed = isReversed
        self.name = name
        self.isActive = isActive
    }

    func generateNode() -> SwitchNode {
        let node = SwitchNode(tint: color.uiColor, activationKey: key)
        node.position = position
        node.isReversed = isReversed
        node.name = name

        return node
    }
}
