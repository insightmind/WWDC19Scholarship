import CoreGraphics

extension CGVector {
    init(first: CGPoint, second: CGPoint) {
        self.init(dx: second.x - first.x, dy: second.y - first.y)
    }

    func angleX1() -> CGFloat {
        return CGVector.angle(self, CGVector(dx: 1, dy: 0))
    }

    func abs() -> CGFloat {
        return hypot(dx, dy)
    }

    static func angle(_ lhs: CGVector, _ rhs: CGVector) -> CGFloat {
        return atan2(lhs.dy, lhs.dx) - atan2(rhs.dy, rhs.dx)
    }
}

