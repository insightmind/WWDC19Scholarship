import Foundation
import SpriteKit

/// This not represents our main protagonist Giby and handles all features for animating
/// when Giby walks or reverses gravity.
class GibyNode: SKSpriteNode {
    // MARK: FilePaths
    /// FilePath to image when Giby stands and is in reverse
    private static var standReveresFilePath: String { return GameTheme.current.filePath(for: "Giby/Giby_Side_Stand_Reversed") }
    /// FilePath to image when Giby stands and is not in reverse
    private static var standFilePath: String { return GameTheme.current.filePath(for: "Giby/Giby_Side_Stand") }
    /// FilePath to image when Giby walks and is in reverse
    private static var walkReveresFilePath: String { return GameTheme.current.filePath(for: "Giby/Giby_Side_Walk_Reversed") }
    /// FilePath to image when Giby walks and is not in reverse
    private static var walkFilePath: String { return GameTheme.current.filePath(for: "Giby/Giby_Side_Walk") }

    // MARK: Textures
    /// The texture applied if Giby stands and is in reverse
    private let reverseStandTexture = SKTexture(imageNamed: GibyNode.standReveresFilePath)
    /// The texture applied if Giby stands and is not in reverse
    private let standTexture = SKTexture(imageNamed: GibyNode.standFilePath)
    /// The texture applied if Giby walks and is in reverse
    private let reverseWalkTexture = SKTexture(imageNamed: GibyNode.walkReveresFilePath)
    /// The texture applied if Giby walks and is not in reverse
    private let walkTexture = SKTexture(imageNamed: GibyNode.walkFilePath)

    /// Determines the move textures depending if Giby is in reverse.
    private var moveTextures: [SKTexture] {
        if isReversed {
            return [reverseStandTexture, reverseWalkTexture]
        } else {
            return [standTexture, walkTexture]
        }
    }

    // MARK: Constants
    /// The maximum walking and falling speed of Giby
    private let maxSpeed: CGFloat = 100
    /// The key used to determine the walk animation.
    private let moveActionKey: String = "GIBY_MOVE_ACTION"

    // MARK: Properties
    /// Determines whether Giby is moving or not
    private var isMoving: Bool = false
    /// Determines whether Giby is in reverse or not
    private var isReversed = false
    /// Determines the current looking direction of Giby
    private var direction: Direction = .left

    // MARK: Initialization
    /// Creates a basic preconfigured Giby node
    public convenience init() {
        self.init(imageNamed: GibyNode.standFilePath)

        size = CGSize(width: 35, height: 35)
        physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
    }

    // MARK: Walking and Reversing

    /// Tells Giby to go in moveMode and walk to the given direction
    ///
    /// - Parameter direction: The direction to walk to.
    public func walkToDirection(to direction: Direction) {
        // If Giby already moves we don't need to run the texture animation as it already runs.
        if !isMoving {
            run(.repeatForever(.animate(with: moveTextures, timePerFrame: 0.1)), withKey: moveActionKey)
        }

        // We mirror the texture depending the direction and if Giby is reversed
        xScale = abs(xScale) * (isReversed ? -1.0 : 1.0) * CGFloat(direction.rawValue)

        // We save the direction so we can use it in the keep pace function.
        self.direction = direction

        isMoving = true
    }

    /// Keeps the current pace of Giby
    private func keepPace() {
        guard let physicsBody = physicsBody else { return }
        physicsBody.velocity = CGVector(dx: maxSpeed * -CGFloat(direction.rawValue), dy: physicsBody.velocity.dy)
    }


    /// Sets whether Giby should reverse or not.
    ///
    /// - Parameter isReversed: true if Giby should be reversed otherwise false
    public func setReverse(isReversed: Bool) {
        let angle: CGFloat = isReversed ? CGFloat.pi : 0
        run(.rotate(toAngle: angle, duration: 0.3))

        self.isReversed = isReversed

        texture = isReversed ? reverseStandTexture : standTexture
    }

    /// Stops to walk immediately and also resets velocity.
    public func stopWalk() {
        guard let physicsBody = physicsBody else { return }
        removeAction(forKey: moveActionKey)
        texture = isReversed ? reverseStandTexture : standTexture

        physicsBody.velocity = CGVector(dx: 0.0, dy: physicsBody.velocity.dy)

        isMoving = false
    }

    // MARK: Physics
    /// Updates the physics of Giby so Giby keeps moving.
    /// This also checks that Giby cannot move while falling.
    public func updatePhysics() {
        guard let physicsBody = physicsBody else { return }

        // If Giby is falling we should not allow to move Giby
        guard isMoving && abs(physicsBody.velocity.dy) <= 1 else { return }
        keepPace()
    }
}
