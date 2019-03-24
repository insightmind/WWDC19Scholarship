import Foundation
import SpriteKit

public class LevelCompletionScene: FlowableScene {
    /// NodeSelectors are used to describe a specific node in the scene in
    /// a more declarative way.
    enum NodeSelectors: String, NodeSelector {
        case retryButton
        case nextButton
        case menuButton

        var isUserInteractable: Bool {
            return true
        }
    }

    public struct ViewModel {
        var levelNum: Int
        var rating: Rating
    }

    private(set) var viewModel: ViewModel?
    private var titleNode: SKSpriteNode?
    private var stars: [StarNode] = []

    /// The settingsFlowDelegate allows us to alter global game settings
    weak var settingsFlowDelegate: SettingsFlowDelegate?

    // MARK: Nodes
    lazy var nextButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelCompletion/NextButton"))
        node.size = CGSize(width: 304, height: 77)
        node.position = CGPoint(x: 250, y: 300)
        node.addGlow()
        node.name = NodeSelectors.nextButton.rawValue
        return node
    }()

    lazy var retryButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelCompletion/RetryButton"))
        node.size = CGSize(width: 304, height: 77)
        node.position = CGPoint(x: 250, y: 200)
        node.addGlow()
        node.name = NodeSelectors.retryButton.rawValue
        return node
    }()

    lazy var menuButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelCompletion/MenuButton"))
        node.size = CGSize(width: 304, height: 77)
        node.position = CGPoint(x: 250, y: 100)
        node.addGlow()
        node.name = NodeSelectors.menuButton.rawValue
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
        addChild(nextButton)
        addChild(retryButton)
        addChild(menuButton)
    }

    public func setViewModel(to viewModel: ViewModel) {
        titleNode?.removeFromParent()
        titleNode = nil

        stars.forEach { $0.removeFromParent() }
        stars.removeAll()

        configureTitle(for: viewModel.levelNum)
        configureStars(for: viewModel.rating)

        if viewModel.levelNum >= 5 { nextButton.removeFromParent() }
        self.viewModel = viewModel
    }

    private func configureTitle(for levelNum: Int) {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "LevelCompletion/LevelTitle\(levelNum)"))
        node.position = CGPoint(x: 250, y: 570)
        node.addGlow()
        addChild(node)

        titleNode = node
    }

    private func configureStars(for rating: Rating) {
        let numOfActiveStars = rating.rawValue
        for index in 1 ... 3 {
            let starNode = StarNode(isEnabled: index <= numOfActiveStars)
            starNode.position = CGPoint(x: (500 / 4) * index, y: 430)
            addChild(starNode)
            stars.append(starNode)
        }
    }

    // MARK: TouchEvents
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let nodeName = resolveNamedNode(for: touches, with: NodeSelectors.selectableNodes)?.name else { return }

        switch nodeName {
        case NodeSelectors.retryButton.rawValue:
            guard let model = viewModel else { break }
            flowDelegate?.changeGameState(to: .play(level: model.levelNum), with: .crossDisolve)

        case NodeSelectors.menuButton.rawValue:
            flowDelegate?.changeGameState(to: .menu, with: .crossDisolve)

        case NodeSelectors.nextButton.rawValue:
            guard let model = viewModel else { break }
            flowDelegate?.changeGameState(to: .play(level: model.levelNum + 1), with: .crossDisolve)

        default:
            return
        }
    }
}
