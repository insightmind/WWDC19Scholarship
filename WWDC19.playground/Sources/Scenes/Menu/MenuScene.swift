import Foundation
import SpriteKit

public class MenuScene: FlowableScene {
    // MARK: NodeSelectors
    /// NodeSelectors are used to describe a specific node in the scene in
    /// a more declarative way.
    ///
    /// - title: Describes the titleNode
    /// - startButton: Describes the startButtonNode
    /// - settingsButton: Describes the settingsButtonNode
    enum NodeSelectors: String, NodeSelector {
        case title
        case startButton
        case settingsButton

        var isUserInteractable: Bool {
            switch self {
            case .startButton, .settingsButton:
                return true

            default:
                return false
            }
        }
    }

    // MARK: FilePaths
    private let titleFilePath = GameTheme.current.filePath(for: "Menu/Title/Title")
    private let startButtonFilePath = GameTheme.current.filePath(for: "Menu/StartButton")
    private let settingsButtonFilePath = GameTheme.current.filePath(for: "Menu/SettingsButton")

    // MARK: Nodes
    private lazy var titleNode: SKSpriteNode = {
        // We want to load only the first image at the beginning of the scene
        let node = SKSpriteNode(imageNamed: self.titleFilePath + "1")
        node.position = CGPoint(x: 250, y: 524)
        node.size = CGSize(width: 420, height: 140)
        node.name = NodeSelectors.title.rawValue
        node.addGlow()
        return node
    }()

    private lazy var startButtonNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: self.startButtonFilePath)
        node.position = CGPoint(x: 250, y: 322)
        node.size = CGSize(width: 304, height: 77)
        node.name = NodeSelectors.startButton.rawValue
        node.addGlow()
        return node
    }()

    private lazy var settingsButtonNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: self.settingsButtonFilePath)
        node.position = CGPoint(x: 250, y: 182)
        node.size = CGSize(width: 304, height: 77)
        node.name = NodeSelectors.settingsButton.rawValue
        node.addGlow()
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

        addChild(titleNode)
        addChild(startButtonNode)
        addChild(settingsButtonNode)
        
        configureTitleAnimation()
    }

    /// Starts and configures the animation of the title
    private func configureTitleAnimation() {
        let textures = loadTitleImages()
        let titleSequence = SKAction.animate(with: textures, timePerFrame: 0.3)
        titleNode.run(.repeatForever(titleSequence))
    }

    // MARK: UserInteraction
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let node = resolveNamedNode(for: touches, with: NodeSelectors.selectableNodes) else { return }
        didSelect(node)
    }

    /// Handles and coordinates touch action of the given node.
    ///
    /// - Parameter node: The node which has been selected.
    func didSelect(_ node: SKNode) {
        guard let name = node.name else { return }

        switch name {
        case NodeSelectors.settingsButton.rawValue:
            settingsButtonNode.animatePop()
            flowDelegate?.changeGameState(to: .settings, with: .push(direction: .up))

        case NodeSelectors.startButton.rawValue:
            startButtonNode.animatePop()
            flowDelegate?.changeGameState(to: .levels, with: .push(direction: .down))

        default:
            return
        }
    }

    // MARK: ResourceLoading

    /// Loads all necessary textures for the title animation
    ///
    /// - Returns: All title textures.
    private func loadTitleImages() -> [SKTexture] {
        let filePath = GameTheme.current.filePath(for: "Menu/Title/Title")
        return (1...8).compactMap { SKTexture(imageNamed: filePath + String($0)) }
    }
}
