import Foundation
import SpriteKit

public class GameScene: FlowableScene {
    // MARK: Constants
    /// The duration of which the arrow particle effect should be shown after reversing gravity.
    internal let arrowVisibilityTime: TimeInterval = 2.0

    // MARK: Private Properties
    /// Defines whether the user is currently in the moving state.
    internal var willMove: Bool = false
    /// The timer used to hide a the particle effect after the given duration
    internal var particleTimer: Timer?
    /// Used to determine if giby was moved and so for to reduce unintended reversing.
    internal var savedGibyPosition: CGPoint?
    /// Used to determine rating if user finishes
    internal var startTime: TimeInterval?

    // MARK: Level Model
    /// The levelModel specifies the basic layout and bodys of the level.
    internal var levelModel: LevelModel

    /// The gameSceneFlowDelegate is used to propagate data if the level was solved.
    internal weak var gameSceneFlowDelegate: GameSceneFlowDelegate?

    // MARK: Lazy Properties and Nodes
    /// The cameraNode is used to keep focus on giby.
    lazy var cameraNode: SKCameraNode = {
        let node = SKCameraNode()
        node.setScale(0.8)
        return node
    }()

    /// Gravity up particle effect, shown after gravity was set to reverse.
    lazy var gravityUpParticle: SKEmitterNode = {
        let emitter = SKEmitterNode(fileNamed: "Shared/GravityUp")!
        emitter.particleTexture = SKTexture(imageNamed: GameTheme.current.filePath(for: "Levels/Assets/ArrowUp"))
        emitter.position = CGPoint(x: 250, y: -50)
        emitter.targetNode = self
        emitter.numParticlesToEmit = 0
        emitter.zPosition = 5
        emitter.particleAlpha = -1
        return emitter
    }()

    /// Gravity up particle effect, shown after gravity was set to normal.
    lazy var gravityDownParticle: SKEmitterNode = {
        let emitter = SKEmitterNode(fileNamed: "Shared/GravityDown")!
        emitter.particleTexture = SKTexture(imageNamed: GameTheme.current.filePath(for: "Levels/Assets/ArrowDown"))
        emitter.position = CGPoint(x: 250, y: 1050)
        emitter.targetNode = self
        emitter.numParticlesToEmit = 0
        emitter.zPosition = 5
        emitter.particleAlpha = -1
        return emitter
    }()

    /// The actual playable character, and the most sweet creature in the world, GIBY!
    lazy var gibyNode: GibyNode = {
        let giby = GibyNode()
        giby.position = self.levelModel.layoutStructure.startPosition
        giby.name = GameNodeSelectors.giby.rawValue
        giby.zPosition = 4
        giby.setReverse(isReversed: self.levelModel.layoutStructure.isStartReversed)
        return giby
    }()

    /// Indicates the user that giby is moving to the dragged direction.
    lazy var dragStripNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "Giby/DragSprite"))
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        node.zPosition = 3
        node.position = self.levelModel.layoutStructure.startPosition
        node.isHidden = true
        return node
    }()

    /// This node represents the area at which a level can be solved.
    /// If Giby enters this area, the level has been solved.
    lazy var goalNode: GoalNode = {
        let goal = GoalNode()
        goal.position = self.levelModel.layoutStructure.finishPosition
        goal.zPosition = 1
        goal.setReverse(isReversed: self.levelModel.layoutStructure.isFinishReversed)
        return goal
    }()

    /// The overlay node is a basic non physics based overlay used to add decoration to the current level
    lazy var overlayNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: self.levelModel.layoutStructure.overlayPath))
        node.size = self.levelModel.layoutStructure.levelRect.size
        node.position = self.levelModel.layoutStructure.levelRect.origin
        node.zPosition = 2
        return node
    }()

    /// The physics border is used to determine the basic physics layout of the level.
    /// We generate the body from the texture provided.
    lazy var physicsBorder: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: self.levelModel.layoutStructure.physicsBorderPath))
        node.size = self.levelModel.layoutStructure.levelRect.size
        node.position = self.levelModel.layoutStructure.levelRect.origin

        let texture = SKTexture(imageNamed: GameTheme.current.filePath(for: self.levelModel.layoutStructure.physicsBorderPath))
        let physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        physicsBody.isDynamic = false
        physicsBody.restitution = 0.0
        node.physicsBody = physicsBody
        
        return node
    }()

    /// The reset button allows the user to reset the current level
    lazy var resetButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "Levels/Assets/ResetButton"))
        node.size = CGSize(width: 20, height: 20)
        node.name = GameNodeSelectors.resetButton.rawValue
        node.addGlow()
        node.zPosition = 200
        return node
    }()

    /// The back button allows the user to go back to the menu
    lazy var backButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameTheme.current.filePath(for: "Levels/Assets/BackButton"))
        node.size = CGSize(width: 20, height: 20)
        node.name = GameNodeSelectors.backButton.rawValue
        node.addGlow()
        node.zPosition = 200
        return node
    }()

    // MARK: Initializers
    /// Creates a new level or gameScene with the given size and flowDelegate
    ///
    /// - Parameters:
    ///   - size: The size of the scene
    ///   - flowDelegate: flowDelegate to change the current scene.
    required public init(size: CGSize, flowDelegate: GameFlowDelegate) {
        self.levelModel = .empty
        super.init(size: size, flowDelegate: flowDelegate)
        configureLevel()
    }

    /// Creates a new level or gameScene with the given size and flowDelegate.
    /// This initializer also generates a new level.
    ///
    /// - Parameters:
    ///   - size: The size of the scene
    ///   - flowDelegate: flowDelegate to change the current scene.
    ///   - viewModel: the level specific viewModel
    internal init(size: CGSize, flowDelegate: GameFlowDelegate, viewModel: LevelModel) {
        self.levelModel = viewModel
        super.init(size: size, flowDelegate: flowDelegate)
        configureLevel()
    }

    /// This initializer is required, however should not be used, as we don't use StoryBoards inside Swift Playground
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }

    // MARK: Configuration
    /// Configures the whole GameScene by adding all necessary SKNodes
    private func configureLevel() {
        backgroundColor = GameTheme.current.backgroundColor

        // Add all necessary childs
        addChild(physicsBorder)
        addChild(overlayNode)
        addChild(gibyNode)
        addChild(gravityDownParticle)
        addChild(gravityUpParticle)
        addChild(dragStripNode)
        addChild(goalNode)
        addChild(resetButton)
        addChild(backButton)

        // Assign camera
        camera = cameraNode

        // Configure Physics
        configurePhysicsWorld()

        // Configure Level
        // Add level specific nodes
        levelModel.physicsBodys.forEach { addChild($0.generateNode()) }
        levelModel.rainbows.forEach { addChild($0.generateNode()) }

        // Bridges
        levelModel.bridges.forEach { addChild($0.generateNode()) }

        // Arrows
        levelModel.arrows.forEach { addChild($0.generateNode()) }

        // Switches
        levelModel.switches.forEach { addChild($0.generateNode()) }
        configureSwitchActivation()
    }

    private func configureSwitchActivation() {
        guard let switchNodes = children.filter({ return $0 is SwitchNode }) as? [SwitchNode] else { return }
        levelModel.switches.forEach { nodeConfig in
            guard nodeConfig.isActive else { return }
            guard let switchNode = switchNodes.first(where: { return $0.activationKey == nodeConfig.key }) else { return }
            self.toggleSwitch(switchNode, force: true)
        }
    }

    /// Configures the PhysicsWorld depending the start reversion.
    private func configurePhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: (levelModel.layoutStructure.isStartReversed ? 1 : -1) * 5)
    }

    // MARK: Updating Scene Content
    /// Updates the scene before executing physics calculations.
    ///
    /// - Parameter currentTime: The currentTime of the game
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        if startTime == nil { startTime = currentTime }

        gibyNode.updatePhysics()

        // If Giby intersects with the goal node, the user solved the level
        if goalNode.contains(gibyNode.position) {
            didCompleteLevel(currentTime: currentTime)
        }

        guard let allSwitchNodes = children.filter({ return $0 is SwitchNode }) as? [SwitchNode] else { return }
        allSwitchNodes.forEach { [weak self] switchNode in
            guard let self = self else { return }
            self.enableSwitchIfNeeded(switchNode)
        }
    }

    // MARK: Physics
    /// Simulates the physics for each cycle
    public override func didSimulatePhysics() {
        super.didSimulatePhysics()
        cameraNode.position = gibyNode.position
        dragStripNode.position = gibyNode.position

        let relativeCenter = cameraNode.position
        gravityDownParticle.position = CGPoint(x: relativeCenter.x, y: relativeCenter.y + size.height / 2)
        gravityUpParticle.position = CGPoint(x: relativeCenter.x, y: relativeCenter.y - size.height / 2)
        resetButton.position = CGPoint(x: relativeCenter.x + size.width / 3, y: relativeCenter.y - size.height / 3)
        backButton.position = CGPoint(x: relativeCenter.x - size.width / 3, y: relativeCenter.y - size.height / 3)
    }

    // MARK: LevelCompletion
    /// Handles all events, which occur if the user completes the level.
    func didCompleteLevel(currentTime: TimeInterval) {
        isPaused = true

        let timeNeeded = currentTime - (startTime ?? 0)
        let rating = levelModel.ratingOptions.getRating(for: timeNeeded)

        gameSceneFlowDelegate?.didCompleteLevel(at: levelModel.levelNum, with: rating)
    }

    // MARK: SwitchActivation
    /// Toggles a SwitchNode and all its associated bridges
    ///
    /// - Parameter switchNode: The switchNode which should be toggled.
    func toggleSwitch(_ switchNode: SwitchNode, force: Bool = false) {
        guard switchNode.isEnabled || force else { return }
        let key = switchNode.activationKey

        // Search all associated bridges
        guard let allKeyBridges = children.filter({ node in
            guard let bridge = node as? BridgeNode else { return false }
            return bridge.activationKey == key
        }) as? [BridgeNode] else { return }

        // Toggle the switch
        switchNode.isActivated.toggle()
        switchNode.animatePop()
        allKeyBridges.forEach { $0.isEnabled = switchNode.isActivated }
    }

    /// Checks whether Giby is in the distance to push a switch
    ///
    /// - Parameter switchNode: The switch node which will be checked.
    func enableSwitchIfNeeded(_ switchNode: SwitchNode) {
        let distanceVector = CGVector(first: gibyNode.position, second: switchNode.position)

        if distanceVector.abs() <= 60 {
            switchNode.setIsEnabled(true)
        } else {
            switchNode.setIsEnabled(false)
        }
    }

    // MARK: Reset
    /// Resets the current game
    func reset() {
        gameSceneFlowDelegate?.reset()
    }

    // MARK: Segues
    func goBackToMenu() {
        flowDelegate?.changeGameState(to: .menu, with: .crossDisolve)
    }
}
