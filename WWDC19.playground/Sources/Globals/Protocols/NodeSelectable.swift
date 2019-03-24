import Foundation

typealias NodeSelector = NodeSelectable & CaseIterable

protocol NodeSelectable {
    var isUserInteractable: Bool { get }
}

extension NodeSelectable where Self: CaseIterable & RawRepresentable {
    static var selectableNodes: [Self.RawValue] {
        return allCases.filter {
            $0.isUserInteractable
        }.compactMap {
            $0.rawValue
        }
    }
}
