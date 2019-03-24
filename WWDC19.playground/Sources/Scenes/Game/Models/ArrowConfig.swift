import SpriteKit

struct ArrowConfig: Codable {
    var position: CGPoint
    var isReversed: Bool
    var isAlternative: Bool

    func generateNode() -> ArrowNode {
        let arrowNode = ArrowNode()
        arrowNode.position = position
        arrowNode.yScale = (isReversed ? -1 : 1) * abs(arrowNode.yScale)

        if isAlternative {
            arrowNode.zRotation = CGFloat.pi / 2
            arrowNode.removeAllActions()
            arrowNode.alternateAnimateArrow()
        }

        return arrowNode
    }
}

