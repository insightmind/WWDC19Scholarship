import Foundation
import SpriteKit

extension SKSpriteNode {
    func addGlow(radius: Float = 10) {
        guard GameTheme.current.allowsGlow else { return }

        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.position = CGPoint(x: -2, y: -2)
        addChild(effectNode)
        
        let childNode = SKSpriteNode(texture: texture)
        childNode.size = size
        effectNode.addChild(childNode)

        effectNode.filter = CIFilter(
            name: "CIGaussianBlur",
            parameters: [
                "inputRadius": radius
            ]
        )
    }
}
