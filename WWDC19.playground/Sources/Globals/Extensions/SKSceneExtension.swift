import Foundation
import SpriteKit

extension SKScene {
    /// Resolves a named node on the specified touch location.
    ///
    /// - Parameter touches:
    ///     - touches: The touches which occurred on the scene.
    ///     - whiteList: A whiteList which will provide which names should be considered only. If empty we dont use it to filter the results.
    /// - Returns: A named node at the specified touch location, if existing.
    func resolveNamedNode(for touches: Set<UITouch>, with whiteList: [String] = []) -> SKNode? {
        // We resolve the location of the first touch
        guard let firstTouch = touches.first else { return nil }
        let location = firstTouch.location(in: self)

        // We find a node if available which has been named.
        return nodes(at: location).first(where: { node -> Bool in
            guard let name = node.name else { return false }

            // If the whiteList is empty we will not consider it.
            if whiteList.isEmpty {
                return true
            } else {
                return whiteList.contains(name)
            }
        })
    }
}
