//
//  ChordSoundPlayer.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/12.
//

import Foundation
import AudioKit

class ChordSoundPlayer {
    static let shared = ChordSoundPlayer()
    
    var player: AKPWMOscillatorBank
    
    init() {
        player = AKPWMOscillatorBank()
        player.pulseWidth = 0.2
        player.attackDuration = 0
        player.decayDuration = 0
        player.sustainLevel = 1
        player.releaseDuration = 0.5
        let reverb = AKChowningReverb(player)
        AKManager.output = reverb
        do {
            try AKManager.start()
        } catch {
            print("AKManager starting error occured")
            print(error.localizedDescription)
        }
    }
    
    func playTone(tone: Pitch) {
        let midinoteNumber = (tone.toneHeight+1) * 12 + ChordAnalyzer.analyzeToneName(toneName: tone.toneName)
        player.play(noteNumber: MIDINoteNumber(midinoteNumber), velocity: 127)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.player.stop(noteNumber: MIDINoteNumber(midinoteNumber))
        }
    }
    
}
