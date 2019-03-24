import Foundation
import SpriteKit

/// Extension of GameScene which handles explicitly the touch based events.
extension GameScene {
    // MARK: TouchEvents
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let node = resolveNamedNode(for: touches) else { return }

        if let switchNode = node as? SwitchNode {
            toggleSwitch(switchNode)
            return
        }

        // If Giby was selected the user may want to change gravity or move giby.
        guard let nodeName = node.name else { return }

        switch nodeName {
        case GameNodeSelectors.giby.rawValue:
            willMove = true
            savedGibyPosition = gibyNode.position

        case GameNodeSelectors.backButton.rawValue:
            backButton.animatePop()
            goBackToMenu()

        case GameNodeSelectors.resetButton.rawValue:
            resetButton.animatePop()
            reset()

        default:
            break
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard willMove, let touch = touches.first else { return }
        updateGibyMoving(to: touch.location(in: self))
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        willMove = false
        dragStripNode.isHidden = true
        gibyNode.stopWalk()
    }


    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        willMove = false
        dragStripNode.isHidden = true
        gibyNode.stopWalk()

        guard let node = resolveNamedNode(for: touches, with: GameNodeSelectors.selectableNodes) else { return }

        if node.name == GameNodeSelectors.giby.rawValue {
            updateReverseIfNeeded()
        }

    }

    /// Updates whether the scene needs to be reversed after a tap.
    private func updateReverseIfNeeded() {
        guard let oldGibyPosition = savedGibyPosition else { return }
        let moveDistance = CGVector(first: oldGibyPosition, second: gibyNode.position).abs()

        // The user moved giby less than 20 points we allow them to reverse the scene, otherwise it may feel like strange behaviour
        guard moveDistance <= 20 else { return }

        particleTimer?.fire()

        physicsWorld.gravity = CGVector(dx: physicsWorld.gravity.dx, dy: -physicsWorld.gravity.dy)

        let isReversed = physicsWorld.gravity.dy > 0

        gibyNode.setReverse(isReversed: isReversed)
        animateParticleFade(isReversed: isReversed)
    }

    /// Updates Gibys Moving and DragSprite rotation and scale
    ///
    /// - Parameter location: The location at which a touch moved.
    private func updateGibyMoving(to location: CGPoint) {
        let nonAbsXDistance = gibyNode.position.x - location.x
        let vector = CGVector(first: gibyNode.position, second: location)
        let angle = vector.angleX1()

        dragStripNode.zRotation = angle

        let newWidth = vector.abs()
        dragStripNode.size = CGSize(width: newWidth, height: 15)

        // If the distance to giby is to small we won't show the drag and won't move as we cannot
        // be sure if the user intends to walk or to just tap.
        guard newWidth >= 2 * gibyNode.size.width / 3 else {
            gibyNode.stopWalk()
            dragStripNode.isHidden = true
            return
        }

        // If everthing looks fine we can show the drag.
        dragStripNode.isHidden = false
        gibyNode.walkToDirection(to: nonAbsXDistance < 0 ? .right : .left)
    }

    // MARK: Animations
    /// Animates the particle fade, so the arrows only are visible for a short amount of time
    ///
    /// - Parameter isReversed: Whether the current scene is reversed or not.
    private func animateParticleFade(isReversed: Bool) {
        gravityDownParticle.particleAlpha = !isReversed ? 0.5 : -1
        gravityUpParticle.particleAlpha = isReversed ? 0.5 : -1

        particleTimer = Timer.scheduledTimer(withTimeInterval: arrowVisibilityTime, repeats: false) { timer in
            timer.invalidate()

            self.gravityDownParticle.particleAlpha = -1
            self.gravityUpParticle.particleAlpha = -1
        }
    }
}
