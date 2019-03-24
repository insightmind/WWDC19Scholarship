import Foundation

protocol SettingsFlowDelegate: AnyObject {
    func changeTheme(to theme: GameTheme)
    func toggleMusic(to isActive: Bool)
}
