//
//  ChordDictViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/16.
//

import UIKit
import AudioKit

class ChordDictViewController: UIViewController {

    var chordView = GuitarChordView(frame: .zero)
    var buttonView = ChordButtonsView(frame: .zero)
    var chordName = UILabel(frame: .zero)
    lazy var playButton = UIBarButtonItem(image: UIImage(systemName: "play.circle"), style: .plain, target: self, action: #selector(playButtonTouched))
    lazy var metronomeSetButton = UIBarButtonItem(image: UIImage(systemName: "metronome"), style: .plain, target: self, action: #selector(metronomeButtonTouched))
    var metronomeView = MetronomeView()
    let beatHighlightView = BeatHighlightView()
    
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
    var chordArrayIndex = 0
    var searchedChordCount = 0

    // chord sound player
    private let bank = AKPWMOscillatorBank()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chordName.font = .systemFont(ofSize: 32)
        chordName.textAlignment = .center
        chordName.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.rightBarButtonItems = [metronomeSetButton, playButton]
        metronomeView.delegate = self

        view.addSubview(chordName)
        view.addSubview(chordView)
        view.addSubview(buttonView)
        
        beatHighlightView.frame = self.view.frame
        view.insertSubview(beatHighlightView, at: 0)
        beatHighlightView.fill(frame: self.view.frame)
        beatHighlightView.alpha = 0
        viewWillLayoutSubviews()

        bank.pulseWidth = 0.2
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
            print(error.localizedDescription)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutSubviews()
        buttonView.makeBtn(frame: buttonView.bounds)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let chordSoundPlay = UITapGestureRecognizer(target: self, action: #selector(chordTouched))
        let chordChangeBack = UISwipeGestureRecognizer(target: self, action: #selector(chordSwipedLeft))
        chordChangeBack.direction = .left
        let chordChangeForward = UISwipeGestureRecognizer(target: self, action: #selector(chordSwipedRight))
        chordChangeForward.direction = .right
        chordView.addGestureRecognizer(chordSoundPlay)
        chordView.addGestureRecognizer(chordChangeBack)
        chordView.addGestureRecognizer(chordChangeForward)

        // bounds를 참조해야 함(frame은 global property이므로)
        for btnRow in buttonView.btnArr {
            for btn in btnRow {
                btn.addTarget(self, action: #selector(ChordDictViewController.buttonTouched), for: .touchUpInside)

            }
        }
//        buttonView.setNeedsDisplay()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            chordName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            chordName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            chordName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            chordName.bottomAnchor.constraint(equalTo: chordView.topAnchor, constant: -padding),
            chordName.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 70),

            buttonView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            buttonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            buttonView.heightAnchor.constraint(equalToConstant: 300),

            chordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            chordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            chordView.topAnchor.constraint(equalTo: chordName.bottomAnchor, constant: padding),
            chordView.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: -padding)
            
        ])
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonView.updateButtonLayout()
        addIndexView()
        beatHighlightView.frame = view.frame
        beatHighlightView.fill(frame: self.view.frame)
        beatHighlightView.alpha = 0
        chordView.setNeedsDisplay()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        metronomeView.onTimerEnd()
        do {
            try AKManager.stop()
        } catch {
            print("AKManager Stopping Error Occured")
            print(error.localizedDescription)
        }
        metronomeView.removeFromSuperview()
    }

    func addIndexView() {
        if chordView.subviews.isEmpty || chordView.subviews.count != searchedChordCount {
            for childView in chordView.subviews {
                childView.removeFromSuperview()
            }
            let imageWidth = chordView.bounds.width/15
            for index in 0..<searchedChordCount {
                let image = UIImage(systemName: "circle.fill")
                let indexer = UIButton()
                indexer.setImage(image, for: .normal)
                if index == chordArrayIndex {
                    indexer.tintColor = UIColor.CustomPalette.pointColor
                } else {
                    indexer.tintColor = UIColor.CustomPalette.shadeColor2
                }
                indexer.tag = index
                indexer.addTarget(self, action: #selector(ChordDictViewController.setIndexer), for: .touchUpInside)
                indexer.frame = CGRect(
                    x: chordView.bounds.maxX - imageWidth*CGFloat(index + 1),
                    y: chordView.bounds.maxY - chordView.bounds.height/15,
                    width: chordView.bounds.height/15,
                    height: chordView.bounds.height/15
                )
                chordView.addSubview(indexer)
            }

        } else {
            for (index, view) in chordView.subviews.enumerated() {
                view.tintColor = UIColor.CustomPalette.shadeColor2
                if view.tag == chordArrayIndex {
                    view.tintColor = UIColor.CustomPalette.pointColor
                }
                let imageWidth = chordView.bounds.width/15
                view.frame = CGRect(
                    x: chordView.bounds.maxX - imageWidth*CGFloat(index + 1),
                    y: chordView.bounds.maxY - chordView.bounds.height/15,
                    width: chordView.bounds.height/15,
                    height: chordView.bounds.height/15
                )
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.chordView.setNeedsDisplay()
        }
    }

    @objc func setIndexer(_ sender: UIButton) {
        chordArrayIndex = sender.tag
        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3) {
            chordView.chord = tones[chordArrayIndex]
            chordTones = tones[chordArrayIndex].pitches
        }
        addIndexView()
    }

    func searchChord() {
        print("search chord \(chordName.text!)")
        chordArrayIndex = 0
        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3), tones.isNotEmpty {
            chordTones = tones[chordArrayIndex].pitches
            searchedChordCount = tones.count
            print("found: \(searchedChordCount) chords")
            chordView.chord = tones[chordArrayIndex]
            chordView.openChord = chordAnalyzer.currentTuning
        }
        addIndexView()
    }

}

extension ChordDictViewController {

    @objc func chordTouched() {
        for (idx, tone) in chordTones.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1*Double(idx)) { [weak self] in
                self?.playTone(tone: tone)
            }
        }
    }

    @objc func chordSwipedLeft() {
        print("swipe left")
        if chordArrayIndex == 0 {
            chordArrayIndex = searchedChordCount-1
        } else {
            chordArrayIndex -= 1
        }
        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3) {
            chordView.chord = tones[chordArrayIndex]
            chordTones = tones[chordArrayIndex].pitches
        }
        addIndexView()
    }

    @objc func chordSwipedRight() {
        print("swipe right")
        if chordArrayIndex == searchedChordCount - 1 {
            chordArrayIndex = 0
        } else {
            chordArrayIndex += 1
        }
        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3) {
            chordView.chord = tones[chordArrayIndex]
            chordTones = tones[chordArrayIndex].pitches
        }
        addIndexView()
    }

    @objc func buttonTouched(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "nil")
        if sender.tag == 0 || sender.tag == 1 {
            chordKey = sender.titleLabel?.text ?? ""
        } else {
            chordIdentifier = sender.titleLabel?.text ?? ""
            searchChord()
        }
    }
    
    @objc func playButtonTouched() {
        metronomeView.isMetronomeOn.toggle()
    }
    
    @objc func metronomeButtonTouched() {
    }
}

extension ChordDictViewController {

    private func playTone(tone: Pitch) {
        let midinoteNumber = (tone.toneHeight+1) * 12 + ChordAnalyzer.analyzeToneName(toneName: tone.toneName)
        bank.play(noteNumber: MIDINoteNumber(midinoteNumber), velocity: 127)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.bank.stop(noteNumber: MIDINoteNumber(midinoteNumber))
        }
    }

}

extension ChordDictViewController: AnimateButtonDelegate {
    func animateView() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseOut], animations: {
            self.beatHighlightView.alpha = 1
        }, completion: { done in
            if done {
                self.beatHighlightView.alpha = 0
            }
        }
        )
    }
}
