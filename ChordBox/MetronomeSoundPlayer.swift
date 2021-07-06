//
//  MetronomeSoundPlayer.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/07/02.
//

import Foundation
import AVFoundation

class MetronomeSoundPlayer {
    static let shared = MetronomeSoundPlayer()
    
    var mTimer: DispatchSourceTimer!
    
    // Metronome sound related vars
    
    var highSound = AVAudioPlayer()
    var lowSound = AVAudioPlayer()
    var counter: Int = 0
    
    var isMetronomeOn = false {
        didSet {
            if isMetronomeOn {
                mTimer.resume()
            } else {
                counter = 0
                mTimer.suspend()
            }
        }
    }
    
    let highTickURL = Bundle.main.url(forResource: "high tick", withExtension: "mp3")
    let lowTickURL = Bundle.main.url(forResource: "low tick", withExtension: "mp3")
    
    // delegate
    weak var delegate: AnimateViewControllerFromViewDelegate?
    
    init() {
        let queue = DispatchQueue(label: "com.domain.app.timer", qos: .userInteractive)
        mTimer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        
        mTimer.setEventHandler { [unowned self] in
            if self.counter != 0 {
                self.delegate?.animateView()
                self.playTick(counter: self.counter)
            }
            self.counter += 1
        }
    }
    
    func prepareSound() {
        if let highTickurl = highTickURL, let lowTickurl = lowTickURL {
            do {
                highSound = try AVAudioPlayer(contentsOf: highTickurl)
                lowSound = try AVAudioPlayer(contentsOf: lowTickurl)
                highSound.prepareToPlay()
                lowSound.prepareToPlay()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setInterval(bpm: Int) {
        let interval = TimeInterval(60/Float(bpm))
        mTimer.schedule(deadline: .now() + 0.2, repeating: interval, leeway: .microseconds(1))
    }
    
    private func playTick(counter: Int) {
        if counter%4 == 1 {
            highSound.play()
        } else if counter != 0 {
            lowSound.play()
        }
    }
    
}
