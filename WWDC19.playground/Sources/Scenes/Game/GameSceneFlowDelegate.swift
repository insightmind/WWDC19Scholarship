import Foundation

protocol GameSceneFlowDelegate: AnyObject {
    func didCompleteLevel(at levelNum: Int, with rating: Rating)
    func reset()
}
