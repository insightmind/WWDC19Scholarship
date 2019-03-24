import Foundation
import SpriteKit

public class SettingsScene: FlowableScene {
    /// NodeSelectors are used to describe a specific node in the scene in
    /// a more declarative way.
    enum NodeSelectors: String, NodeSelector {
        case title
        case backButton
        case musicCheckBox
        case musicLabel
        case changeThemeButton

        var isUserInteractable: Bool {
            switch self {
            case .backButton, .musicCheckBox, .changeThemeButton:
                return true

            default:
                return false
            }
        }
    }

    /// The settingsFlowDelegate allows us to alter global game settings
    weak var settingsFlowDelegate: SettingsFlowDelegate?

    // MARK: Nodes
    lazy var titleLabelNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "Settings/Title"))
        node.position = CGPoint(x: 250, y: 630)
        node.addGlow()
        node.name = NodeSelectors.title.rawValue
        return node
    }()

    lazy var backButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "Levels/Assets/BackButton"))
        node.size = CGSize(width: 30, height: 30)
        node.position = CGPoint(x: 60, y: 630)
        node.addGlow()
        node.name = NodeSelectors.backButton.rawValue
        return node
    }()

    lazy var musicCheckBoxNode: CheckBoxNode = {
        let node = CheckBoxNode(isEnabled: true)
        node.position = CGPoint(x: 60, y: 530)
        node.name = NodeSelectors.musicCheckBox.rawValue
        node.addGlow()
        return node
    }()

    lazy var musicLabelNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "Settings/EnableMusicLabel"))
        node.position = CGPoint(x: 250, y: 530)
        node.name = NodeSelectors.musicLabel.rawValue
        node.addGlow()
        return node
    }()

    lazy var changeThemeButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "Settings/ChangeThemeButton"))
        node.position = CGPoint(x: 250, y: 430)
        node.size = CGSize(width: 304, height: 77)
        node.name = NodeSelectors.changeThemeButton.rawValue
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

    private func configureScene() {
        backgroundColor = GameTheme.current.backgroundColor

        // Add necessary child nodes
        addChild(titleLabelNode)
        addChild(backButton)
        addChild(musicCheckBoxNode)
        addChild(musicLabelNode)
        addChild(changeThemeButton)
    }

    // MARK: TouchEvents
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let nodeName = resolveNamedNode(for: touches, with: NodeSelectors.selectableNodes)?.name else { return }

        switch nodeName {
        case NodeSelectors.backButton.rawValue:
            flowDelegate?.changeGameState(to: .menu, with: .push(direction: .down))

        case NodeSelectors.musicCheckBox.rawValue:
            musicCheckBoxNode.animatePop()
            let isEnabled = !musicCheckBoxNode.isEnabled
            musicCheckBoxNode.setIsEnabled(isEnabled)
            settingsFlowDelegate?.toggleMusic(to: isEnabled)

        case NodeSelectors.changeThemeButton.rawValue:
            let newTheme: GameTheme = GameTheme.current == .neon ? .bold : .neon
            settingsFlowDelegate?.changeTheme(to: newTheme)
            
        default:
            return
        }
    }
}
