import Foundation
import AVFoundation
import SpriteKit

/// This class represents the main game. It handles all cases such as current gameState, the gameView etc.
public class GibysTravelGame {
    /// The ViewSize of the Game
    private let viewSize: CGSize = CGSize(width: 500, height: 700)
    /// The audioManager which handles the backgroundMusci
    internal let audioManager = AudioManager()
    
    /// Local access whether the backgroundMusic is currently on.
    private var isMusicOn: Bool {
        return audioManager.isBackgroundMusicOn
    }

    /// The current state of the game
    private(set) var gameState: GameState = .menu
    /// The last played level of the game
    private var lastCompletedLevel = LevelCompletionScene.ViewModel(levelNum: 1, rating: .empty)

    /// The actual gameView which is used to present the different scenes
    public lazy var view: SKView = {
        let frame = CGRect(origin: .zero, size: self.viewSize)
        let view = SKView(frame: frame)
        view.backgroundColor = UIColor.blueishBlack

        // We load the menu immediately
        let scene = gameState.loadScene().init(size: viewSize, flowDelegate: self)
        setSceneDelegates(for: scene)
        view.presentScene(scene)

        return view
    }()

    /// The currently displayed scene
    private var scene: SKScene?

    /// Creates a new Game Instance
    ///
    /// - Parameters:
    ///   - isDebug: `true` to show SpriteKits debug overlay
    ///   - enableAudio: `true` to play background music
    public init(isDebug: Bool = false, enableAudio: Bool = true) {
        view.showsFPS = isDebug
        view.showsFields = isDebug
        view.showsDrawCount = isDebug
        view.showsPhysics = isDebug
        view.showsNodeCount = isDebug
        view.showsQuadCount = isDebug

        guard enableAudio else { return }
        audioManager.startBackgroundMusic()
    }

    /// Reloads the current gameState
    ///
    /// - Parameter transition: the transition which should be applied for the reload
    public func reload(with transition: SKTransition) {
        let levelNum = gameState.generateLevelNum()
        if levelNum >= 0 {
            guard let fileURL = Bundle.main.url(forResource: "Shared/Levels/Level\(levelNum)", withExtension: FileTypes.json.rawValue) else { return }
            guard let data = try? Data(contentsOf: fileURL), let levelModel = try? JSONDecoder().decode(LevelModel.self, from: data) else { return }
            let scene = GameScene(size: viewSize, flowDelegate: self, viewModel: levelModel)
            self.setSceneDelegates(for: scene)
            self.transition(to: scene, with: transition)
        } else {
            let scene = gameState.loadScene().init(size: viewSize, flowDelegate: self)
            setSceneDelegates(for: scene)
            self.transition(to: scene, with: transition)
        }
    }

    /// Assign specific delegates or viewModels to the scene
    private func setSceneDelegates(for scene: SKScene) {
        if let gameScene = scene as? GameScene {
            gameScene.gameSceneFlowDelegate = self
        } else if let settingsScene = scene as? SettingsScene {
            settingsScene.settingsFlowDelegate = self
            settingsScene.musicCheckBoxNode.setIsEnabled(isMusicOn)
        } else if let levelCompletionScene = scene as? LevelCompletionScene {
            levelCompletionScene.setViewModel(to: lastCompletedLevel)
        }
    }
}

// MARK: - GameFlowDelegate
extension GibysTravelGame: GameFlowDelegate {
    public func transition(
        to scene: SKScene,
        with transition: SKTransition = .crossFade(withDuration: 0.5)
    ) {
        view.presentScene(scene, transition: transition)
        self.scene = scene
    }

    public func changeGameState(
        to state: GameState,
        with transition: Transition = .crossDisolve
    ) {
        gameState = state
        reload(with: transition.skTransition)
    }
}

// MARK: - GameSceneFlowDelegate
extension GibysTravelGame: GameSceneFlowDelegate {
    public func didCompleteLevel(at levelNum: Int, with rating: Rating) {
        lastCompletedLevel = LevelCompletionScene.ViewModel(levelNum: levelNum, rating: rating)
        changeGameState(to: .levelCompletion, with: .crossDisolve)
    }

    public func reset() {
        reload(with: Transition.crossDisolve.skTransition)
    }
}

// MARK: - SettingsFlowDelegate
extension GibysTravelGame: SettingsFlowDelegate {
    public func toggleMusic(to isActive: Bool) {
        if isActive {
            audioManager.startBackgroundMusic()
        } else {
            audioManager.stopBackgroundMusic()
        }
    }

    public func changeTheme(to theme: GameTheme) {
        guard GameTheme.current != theme else { return }

        GameTheme.current = theme
        reload(with: Transition.crossDisolve.skTransition)
    }
}

