import Foundation
import AVFoundation

/// The AudioManager is used to keep track of the backgroundMusic
class AudioManager {
    /// FilePath of the BackgroundMusic
    private let backgroundFilePath = "Shared/Audio/BackgroundMusic"
    /// The AVAudioPlayer which plays the backgroundMusic
    private var audioPlayer: AVAudioPlayer?

    /// Is true if backgroundMusic is currently on, otherwise false
    private(set) var isBackgroundMusicOn: Bool = false

    /// Starts the BackgroundMusic if not already playing
    func startBackgroundMusic() {
        guard !isBackgroundMusicOn else { return }

        guard let url = Bundle.main.url(forResource: backgroundFilePath, withExtension: FileTypes.mp3.rawValue) else { return }
        guard let avPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
        
        audioPlayer = avPlayer
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()

        isBackgroundMusicOn = true
    }

    /// Stops backgroundMusic music if not already off.
    func stopBackgroundMusic() {
        guard isBackgroundMusicOn else { return }
        
        audioPlayer?.stop()
        isBackgroundMusicOn = false
    }
}
