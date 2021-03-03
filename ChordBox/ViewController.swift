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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var bpmSlider: UISlider!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var chordName: UILabel!
    @IBOutlet weak var containerView: UIView!

    var chordView = GuitarChordView(frame: .zero)
    var buttonView = UIView(frame: .zero)

    // Button Array
    var btnArr: [UIButton] = []

    // Chord Data
    private var chordAnalyzer = ChordAnalyzer()
    private var chordTones = [Pitch]()
    var chordKey: String = "" {
        didSet {
            chordName.text = chordKey
        }
    }
    var chordIdentifier: String = "" {
        didSet {
            chordName.text = chordKey + chordIdentifier
        }
    }

    // Metronome vars
    private var metronome: AVAudioPlayer?
    private var mTimer: Timer?
    private var highSound = AVAudioPlayer()
    private var lowSound = AVAudioPlayer()
    private var counter: Int = 0
    private var isMetronomeOn = false
    private var bpm: Int = 120
    private var interval: TimeInterval {
        return TimeInterval(60/Float(bpm))
    }

    // Chord player vars
    private let bank = AKPWMOscillatorBank()

    // Metronome File URLs
    private let highTickURL = Bundle.main.url(forResource: "high tick", withExtension: "mp3")
    private let lowTickURL = Bundle.main.url(forResource: "low tick", withExtension: "mp3")

    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.addSubview(chordView)
        containerView.addSubview(buttonView)
        // Do any additional setup after loading the view.
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            buttonView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            buttonView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            buttonView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            buttonView.heightAnchor.constraint(equalToConstant: 200),
            chordView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            chordView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            chordView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            chordView.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: -padding)
        ])
        // set up audio
        setupAudio()

        // Metronome setup
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

        // Chord player setup
        bank.pulseWidth = 0.4
        bank.attackDuration = 0
        bank.decayDuration = 0
        bank.sustainLevel = 1
        bank.releaseDuration = 0.5
        let reverb = AKChowningReverb(bank)
        AKManager.output = reverb
        do {
            try AKManager.start()
        } catch {
            print("AKManager starting error occured")
        }

        makeBtn()

    }

    @IBAction func isChordPlayButtonPressed(_ sender: Any) {
        for (idx, tone) in chordTones.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1*Double(idx)) {
                self.playTone(tone: tone)
            }
        }
    }

    // MARK: - Playing certain pitch
    private func playTone(tone: Pitch) {
        let midinoteNumber = (tone.toneHeight+1) * 12 + ChordAnalyzer.analyzeToneName(toneName: tone.toneName)
        self.bank.play(noteNumber: MIDINoteNumber(midinoteNumber), velocity: 127)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) {
            self.bank.stop(noteNumber: MIDINoteNumber(midinoteNumber))
        }
    }

    @IBAction func isPlayButtonTapped(_ sender: Any) {
        if isMetronomeOn {
            isMetronomeOn = false
            onTimerEnd()
            playButton.tintColor = UIColor.CustomPalette.shadeColor2
        } else {
            isMetronomeOn = true
            onTimerStart()
//            playButton.tintColor = .green
        }
    }

    // MARK: - BPM Slider work

    @IBAction func bpmSliderSlided(_ sender: UISlider) {
        bpm = Int(bpmSlider.value)
        bpmLabel.text = "\(bpm)"
        if isMetronomeOn {
            onTimerEnd()
            onTimerStart()
        }
    }

    // MARK: - Timer initialization
    private func onTimerStart() {
        if let timer = mTimer {
            // timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
            if !timer.isValid {
                /** 1초마다 timerCallback함수를 호출하는 타이머 */
                mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
                mTimer?.tolerance = 0.0001
            }
        } else {
            // timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
            /** 1초마다 timerCallback함수를 호출하는 타이머 */
            mTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            mTimer?.tolerance = 0.0001
        }
    }

    // MARK: - Timer invalidation
    private func onTimerEnd() {
        if let timer = mTimer {
            if timer.isValid {
                timer.invalidate()
            }
        }
        counter = 0
    }

    // MARK: - Callback function of timer initializer
    @objc private func timerCallback() {
        playTick(isHighTick: counter%4 == 0 ? true : false)
        counter += 1
        UIView.animate(withDuration: self.interval/4, delay: 0, options: [.allowUserInteraction, .transitionCrossDissolve], animations: {
            self.playButton.tintColor = UIColor.CustomPalette.pointColor
        }, completion: { _ in
                self.playButton.tintColor = UIColor.CustomPalette.shadeColor2
            }
        )
    }

    private func playTick(isHighTick: Bool) {
        DispatchQueue.global(qos: .userInteractive).async {
            if isHighTick {
                self.highSound.play()
            } else {
                self.lowSound.play()
            }
        }
    }

    private func setupAudio() {
      let audioSession = AVAudioSession.sharedInstance()
        _ = try? audioSession.setCategory(AVAudioSession.Category.playback, options: .duckOthers)
      _ = try? audioSession.setActive(true)
    }

//    func searchChord() {
//        print("search chord")
//        var string = ""
//        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3) {
//            chordTones = tones.pitches
//            for tone in tones.pitches {
//                string.append(tone.toneName + " ")
//            }
//            self.chordView.chord = tones
//            self.chordView.openChord = chordAnalyzer.currentTuning
//        }
//        self.chordLabel.text = string
//        DispatchQueue.main.async {
//            self.chordView.setNeedsDisplay()
//        }
//    }

}
