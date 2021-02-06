//
//  ViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/03.
//

import UIKit
import AVFoundation
import AudioKit

class ViewController: UIViewController {

    // UI
    @IBOutlet weak var chordLabel: UILabel!
    @IBOutlet weak var chordTextFieldOutlet: UITextField!
    @IBOutlet weak var chordView: GuitarChordView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var bpmSlider: UISlider!
    @IBOutlet weak var bpmLabel: UILabel!
    
    // ETC
    let chordAnalyzer = ChordAnalyzer()
    var chordTones = [Pitch]()
    var metronome: AVAudioPlayer?
    var mTimer : Timer?
    var highSound = AVAudioPlayer()
    var lowSound = AVAudioPlayer()
    var counter: Int = 0
    var isMetronomeOn = false
    var bpm: Int = 120
    let bank = AKPWMOscillatorBank()
    var isPlaying = false
    
    var interval : TimeInterval {
        return TimeInterval(60/Float(bpm))
    }
    
    // File URLs
    let highTickURL = Bundle.main.url(forResource: "high tick", withExtension: "mp3")
    let lowTickURL = Bundle.main.url(forResource: "low tick", withExtension: "mp3")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chordTextFieldOutlet.delegate = self
        playButton.sizeToFit()
        bpmLabel.text = "\(bpm)"
        bpmSlider.minimumValue = 20
        bpmSlider.maximumValue = 240
        bpmSlider.value = Float(bpm)
        
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
    

        bank.pulseWidth = 0.9
        
        bank.attackDuration = 0
        bank.decayDuration = 0.5
        bank.sustainLevel = 0
        bank.releaseDuration = 0.1
        
        let reverb = AKReverb(bank)
        reverb.loadFactoryPreset(.largeHall2)
        reverb.dryWetMix = 0.5
        AKManager.output = reverb
        
        do {
            try AKManager.start()
        } catch {
            print("AKManager starting error occured")
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func isChordPlayButtonPressed(_ sender: Any) {
        playChord(chordInfo: chordTones)
    }
    
    func playChord(chordInfo: [Pitch]) {
        for tone in chordInfo {
            let midinoteNumber = (tone.toneHeight+1) * 12 + chordAnalyzer.toneHeightDict[tone.toneName]!
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.1) {
                self.bank.play(noteNumber: MIDINoteNumber(midinoteNumber), velocity: 127)
            }
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
                self.bank.stop(noteNumber: MIDINoteNumber(midinoteNumber))
            }
        }
    }
    
    @IBAction func isPlayButtonTapped(_ sender: Any) {
        if isMetronomeOn {  // 켜진 상태 -> 일시정지 버튼 모양 나와야 함
            isMetronomeOn = false
            playButton.tintColor = .gray
            onTimerEnd()
        }
        else {          // 꺼진 상태 -> 재생 버튼 모양 나와야 함
            isMetronomeOn = true
            playButton.tintColor = .green
            onTimerStart()
        }
    }
    
    private func playTick(isHighTick : Bool) {
        DispatchQueue.global(qos: .userInteractive).async {
            if isHighTick {
                self.highSound.play()
            } else {
                self.lowSound.play()
            }
        }
    }
    @IBAction func bpmSliderSlided(_ sender: UISlider) {
        bpm = Int(bpmSlider.value)
        bpmLabel.text = "\(bpm)"
        if isMetronomeOn {
            onTimerEnd()
            onTimerStart()
        }
    }
    
    func onTimerStart() {
        if let timer = mTimer {
            //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
            if !timer.isValid {
                /** 1초마다 timerCallback함수를 호출하는 타이머 */
                mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
                mTimer?.tolerance = 0.0001
            }
        } else {
            //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
            /** 1초마다 timerCallback함수를 호출하는 타이머 */
            mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            mTimer?.tolerance = 0.0001
        }
    }

    func onTimerEnd() {
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
            chordTones = tones
            for tone in tones {
                string.append(tone.description + " ")
            }
            chordTones = chordAnalyzer.adjustChordByGuitarShape(chord: tones, closeFret: 0, capo: 0)
            self.chordView.chord = chordTones
            self.chordView.openChord = chordAnalyzer.currentTuning
        }
        self.chordLabel.text = string
        DispatchQueue.main.async {
            self.chordView.setNeedsDisplay()
        }
        return true
    }
}
