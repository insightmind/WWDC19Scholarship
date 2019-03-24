import Foundation
import SpriteKit

public class FlowableScene: SKScene, GameFlowable {
    weak var flowDelegate: GameFlowDelegate?

    required public init(size: CGSize, flowDelegate: GameFlowDelegate) {
        super.init(size: size)
        self.flowDelegate = flowDelegate
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
