//
//  ViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/03.
//

import UIKit
import AVFoundation



class ViewController: UIViewController {

    // UI
    @IBOutlet weak var chordLabel: UILabel!
    @IBOutlet weak var chordTextFieldOutlet: UITextField!
    @IBOutlet weak var chordView: GuitarChordView!
    @IBOutlet weak var playButton: UIButton!
    
    // ETC
    let chordAnalyzer = ChordAnalyzer()
    var chordTones = [Pitch]()
    var metronome: AVAudioPlayer?
    var mTimer : Timer?
    var highSound = AVAudioPlayer()
    var lowSound = AVAudioPlayer()
    var counter: Int = 0
    var isMetronomeOn = false
    var bpm: Int8 = 120
    
    // File URLs
    let highTickURL = Bundle.main.url(forResource: "high tick", withExtension: "mp3")
    let lowTickURL = Bundle.main.url(forResource: "low tick", withExtension: "mp3")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chordTextFieldOutlet.delegate = self
        playButton.setImage(UIImage(systemName: "pause.rectangle"), for: .selected)
        playButton.setImage(UIImage(systemName: "play.rectangle"), for: .normal)
        if let highTickurl = highTickURL, let lowTickurl = lowTickURL {
            do {
                highSound = try AVAudioPlayer(contentsOf: highTickurl)
                lowSound = try AVAudioPlayer(contentsOf: lowTickurl)
//                guard let sound = metronome else { return }
//                sound.prepareToPlay()
//                sound.play()
                highSound.prepareToPlay()
                lowSound.prepareToPlay()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func isPlayButtonTapped(_ sender: UIButton) {
        if isMetronomeOn {  // 켜진 상태 -> 일시정지 버튼 모양 나와야 함
            isMetronomeOn = false
            playButton.isSelected = false
            onTimerEnd(sender)
        }
        else {          // 꺼진 상태 -> 재생 버튼 모양 나와야 함
            isMetronomeOn = true
            playButton.isSelected = true
            onTimerStart(sender)
        }
    }
    
    private func playTick(isHighTick : Bool) {
        if isHighTick {
            highSound.play()
        } else {
            lowSound.play()
        }
    }
    
    func onTimerStart(_ sender: Any) {
        if let timer = mTimer {
            //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
            if !timer.isValid {
                /** 1초마다 timerCallback함수를 호출하는 타이머 */
                mTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
                mTimer?.tolerance = 0.001
            }
        } else {
            //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
            /** 1초마다 timerCallback함수를 호출하는 타이머 */
            mTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            mTimer?.tolerance = 0.001
        }
    }

    func onTimerEnd(_ sender: Any) {
        if let timer = mTimer {
            if(timer.isValid){
                timer.invalidate()
            }
        }
        
        counter = 0
//        txtTime.text = String(counter)
    }
    
    @objc func timerCallback(){
        playTick(isHighTick: counter%4 == 0 ? true : false)
        counter += 1
//        txtTime.text = String(counter)
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var string = ""
        if let tones = chordAnalyzer.analyze(chordString: chordTextFieldOutlet.text ?? "", toneHeight: 3) {
            self.chordTones = tones
            for tone in tones {
                string.append(tone.description + " ")
            }
            chordView.chord = chordAnalyzer.adjustChordByGuitarShape(chord: tones, closeFret: 0, capo: 0)
            chordView.openChord = chordAnalyzer.currentTuning
        }
        chordLabel.text = string
        DispatchQueue.main.async {
            self.chordView.setNeedsDisplay()
        }
        return true
    }
}
