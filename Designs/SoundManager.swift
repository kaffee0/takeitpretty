//
//  SoundManager.swift
//  ReKaffee
//
//  Created by Kae Feuring on 2025/10/17.
//


import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()

    private var player: AVAudioPlayer?

    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("⚠️ Sound file \(soundName).mp3 not found.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Failed to play sound \(soundName): \(error.localizedDescription)")
        }
    }
}