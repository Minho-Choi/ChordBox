//
//  MetronomeView+Audio.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/08.
//

import UIKit
import AVFoundation

extension MetronomeView {
    
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

    func onTimerStart() {
        if let timer = mTimer {
            // timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
            if !timer.isValid {
                // 1초마다 timerCallback함수를 호출하는 타이머
                mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
                mTimer?.tolerance = 0.0001
            }
        } else {
            // timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
            // 1초마다 timerCallback함수를 호출하는 타이머
            mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            mTimer?.tolerance = 0.0001
        }
    }
    
    // MARK: - Timer invalidation
    func onTimerEnd() {
        if let timer = mTimer {
            if timer.isValid {
                timer.invalidate()
            }
        }
        counter = 0
        highSound.stop()
        lowSound.stop()
    }

    // MARK: - Callback function of timer initializer
    @objc private func timerCallback() {
        delegate?.animateView()
        playTick(isHighTick: counter%4 == 0 ? true : false)
        counter += 1
    }
    
    private func playTick(isHighTick: Bool) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if isHighTick {
                self?.highSound.play()
            } else {
                self?.lowSound.play()
            }
        }
    }

}
