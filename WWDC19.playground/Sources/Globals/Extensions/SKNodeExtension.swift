import Foundation
import SpriteKit

extension SKNode {
    func animatePop() {
        let popInAnimation = SKAction.scale(by: 0.8, duration: 0.05)
        let popOutAnimation = SKAction.scale(by: 1.25, duration: 0.05)

        let sequence = SKAction.sequence([popOutAnimation, popInAnimation])
        run(sequence)
    }
}

