import SpriteKit

struct BridgeConfig: Codable {
    var key: String
    var color: Color
    var rect: CGRect

    init(key: String, color: UIColor, rect: CGRect) {
        self.key = key
        self.color = Color(color: color)
        self.rect = rect
    }

    func generateNode() -> BridgeNode {
        let bridge = BridgeNode(size: rect.size, tint: color.uiColor, activationKey: key)
        bridge.position = rect.origin
        return bridge
    }
}

struct Color: Codable {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0

    var uiColor : UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(color: UIColor) {
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}
