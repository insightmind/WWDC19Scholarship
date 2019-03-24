import Foundation
import CoreGraphics

struct LevelModel: Codable {
    var levelNum: Int
    var layoutStructure: LevelNodeStructure
    var ratingOptions: RatingOptions

    var switches: [SwitchConfig]
    var bridges: [BridgeConfig]
    var physicsBodys: [PhysicsBodyConfig]
    var arrows: [ArrowConfig]
    var rainbows: [RainbowConfig]

    static var empty: LevelModel {
        return LevelModel(
            levelNum: -1,
            layoutStructure: LevelNodeStructure.empty,
            ratingOptions: RatingOptions.empty,
            switches: [],
            bridges: [],
            physicsBodys: [],
            arrows: [],
            rainbows: []
        )
    }
}

struct RatingOptions: Codable {
    /// Maximum time in seconds to get single rating
    var single: TimeInterval
    /// Maximum time in seconds to get double rating
    var double: TimeInterval
    /// Maximum time in seconds to get triple rating
    var triple: TimeInterval

    func getRating(for time: TimeInterval) -> Rating {
        if time <= triple {
            return .triple
        } else if time <= double {
            return .double
        } else if time <= single {
            return .single
        } else {
            return .empty
        }
    }

    static var empty: RatingOptions {
        return RatingOptions(single: -1, double: -1, triple: -1)
    }
}

struct LevelNodeStructure: Codable {
    var overlayPath: String
    var physicsBorderPath: String
    var levelRect: CGRect
    var startPosition: CGPoint
    var isStartReversed: Bool
    var finishPosition: CGPoint
    var isFinishReversed: Bool

    static var empty: LevelNodeStructure {
        return LevelNodeStructure(
            overlayPath: "",
            physicsBorderPath: "",
            levelRect: .zero,
            startPosition: .zero,
            isStartReversed: false,
            finishPosition: .zero,
            isFinishReversed: false
        )
    }
}
