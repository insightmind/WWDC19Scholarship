import Foundation
import SpriteKit

public class LevelSelectionScene: FlowableScene {
    /// NodeSelectors are used to describe a specific node in the scene in
    /// a more declarative way.
    enum NodeSelectors: String, NodeSelector {
        case levelOne
        case levelTwo
        case levelThree
        case levelFour
        case levelFive
        case backButton
        case title

        var isUserInteractable: Bool {
            switch self {
            case .title:
                return false

            default:
                return true
            }
        }
    }

    // MARK: Nodes
    lazy var titleLabelNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelSelection/LevelTitle"))
        node.size = GameTheme.current == .neon ? CGSize(width: 215, height: 60) : CGSize(width: 153, height: 60)
        node.position = CGPoint(x: 250, y: 630)
        node.addGlow()
        node.name = NodeSelectors.title.rawValue
        return node
    }()

    // MARK: LevelButtons
    lazy var level1Button: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelSelection/Level1"))
        node.size = CGSize(width: 304, height: 77)
        node.position = CGPoint(x: 250, y: 530)
        node.addGlow()
        node.name = NodeSelectors.levelOne.rawValue
        return node
    }()

    lazy var level2Button: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelSelection/Level2"))
        node.size = CGSize(width: 304, height: 77)
        node.position = CGPoint(x: 250, y: 430)
        node.addGlow()
        node.name = NodeSelectors.levelTwo.rawValue
        return node
    }()

    lazy var level3Button: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelSelection/Level3"))
        node.size = CGSize(width: 304, height: 77)
        node.position = CGPoint(x: 250, y: 330)
        node.addGlow()
        node.name = NodeSelectors.levelThree.rawValue
        return node
    }()

    lazy var level4Button: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelSelection/Level4"))
        node.size = CGSize(width: 304, height: 77)
        node.position = CGPoint(x: 250, y: 230)
        node.addGlow()
        node.name = NodeSelectors.levelFour.rawValue
        return node
    }()

    lazy var level5Button: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelSelection/Level5"))
        node.size = CGSize(width: 304, height: 77)
        node.position = CGPoint(x: 250, y: 130)
        node.addGlow()
        node.name = NodeSelectors.levelFive.rawValue
        return node
    }()

    // MARK: BackButton
    lazy var backButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "Levels/Assets/BackButton"))
        node.size = CGSize(width: 30, height: 30)
        node.position = CGPoint(x: 60, y: 630)
        node.addGlow()
        node.name = NodeSelectors.backButton.rawValue
        return node
    }()

    // MARK: LifeCycle
    required public init(size: CGSize, flowDelegate: GameFlowDelegate) {
        super.init(size: size, flowDelegate: flowDelegate)
        configureScene()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureScene()
    }

    // MARK: Configuration
    private func configureScene() {
        backgroundColor = GameTheme.current.backgroundColor

        // Add necessary child nodes
        addChild(titleLabelNode)
        addChild(backButton)
        addChild(level1Button)
        addChild(level2Button)
        addChild(level3Button)
        addChild(level4Button)
        addChild(level5Button)
    }

    // MARK: TouchEvents
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let nodeName = resolveNamedNode(for: touches, with: NodeSelectors.selectableNodes)?.name else { return }

        switch nodeName {
        case NodeSelectors.backButton.rawValue:
            flowDelegate?.changeGameState(to: .menu, with: .push(direction: .up))

        case NodeSelectors.levelOne.rawValue:
            flowDelegate?.changeGameState(to: .play(level: 1), with: .crossDisolve)

        case NodeSelectors.levelTwo.rawValue:
            flowDelegate?.changeGameState(to: .play(level: 2), with: .crossDisolve)

        case NodeSelectors.levelThree.rawValue:
            flowDelegate?.changeGameState(to: .play(level: 3), with: .crossDisolve)

        case NodeSelectors.levelFour.rawValue:
            flowDelegate?.changeGameState(to: .play(level: 4), with: .crossDisolve)

        case NodeSelectors.levelFive.rawValue:
            flowDelegate?.changeGameState(to: .play(level: 5), with: .crossDisolve)
            
        default:
            return
        }
    }
}
