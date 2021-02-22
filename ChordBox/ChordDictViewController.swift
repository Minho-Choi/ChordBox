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
        

        view.addSubview(chordName)
        view.addSubview(chordView)
        view.addSubview(buttonView)
        // Do any additional setup after loading the view.
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
        

        // Do any additional setup after loading the view.

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
        for btn in buttonView.btnArr {
            btn.addTarget(self, action: #selector(ChordDictViewController.buttonTouched), for: .touchUpInside)
        }
//        buttonView.setNeedsDisplay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        do {
            try AKManager.stop()
        } catch {
            print("AKManager Stopping Error Occured")
            print(error.localizedDescription)
        }
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
            for view in chordView.subviews {
                view.tintColor = UIColor.CustomPalette.shadeColor2
                if view.tag == chordArrayIndex {
                    view.tintColor = UIColor.CustomPalette.pointColor
                }
            }
        }
        DispatchQueue.main.async {
            self.chordView.setNeedsDisplay()
        }
    }
    
    @objc func setIndexer(_ sender: UIButton) {
        chordArrayIndex = sender.tag
        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3) {
            self.chordView.chord = tones[chordArrayIndex]
            self.chordTones = tones[chordArrayIndex].pitches
        }
        addIndexView()
    }
    
    
    func searchChord() {
        print("search chord \(chordName.text!)")
        chordArrayIndex = 0
//        var string = ""
        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3) {
            chordTones = tones[chordArrayIndex].pitches
//            for tone in tones.pitches {
//                string.append(tone.toneName + " ")
//            }
            searchedChordCount = tones.count
            print("found: \(searchedChordCount) chords")
            self.chordView.chord = tones[chordArrayIndex]
            self.chordView.openChord = chordAnalyzer.currentTuning
        }
        addIndexView()
//        self.chordLabel.text = string
    }

}

extension ChordDictViewController {
    
    @objc func chordTouched() {
        for (idx, tone) in chordTones.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1*Double(idx)) {
                self.playTone(tone: tone)
            }
        }
    }
    
    @objc func chordSwipedLeft() {
        print("swipe left")
        if self.chordArrayIndex == 0 {
            chordArrayIndex = searchedChordCount-1
        } else {
            chordArrayIndex -= 1
        }
        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3) {
            self.chordView.chord = tones[chordArrayIndex]
            self.chordTones = tones[chordArrayIndex].pitches
        }
        addIndexView()
    }
    
    @objc func chordSwipedRight() {
        print("swipe right")
        if self.chordArrayIndex == searchedChordCount - 1 {
            chordArrayIndex = 0
        } else {
            chordArrayIndex += 1
        }
        if let chordText = chordName.text, let tones = chordAnalyzer.analyze(chordString: chordText, toneHeight: 3) {
            self.chordView.chord = tones[chordArrayIndex]
            self.chordTones = tones[chordArrayIndex].pitches
        }
        addIndexView()
    }
    
    @objc func buttonTouched(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "nil")
        if sender.tag == 0 {
            chordKey = sender.titleLabel?.text ?? ""
        } else {
            chordIdentifier = sender.titleLabel?.text ?? ""
            searchChord()
        }
    }
}

extension ChordDictViewController {
    
    private func playTone(tone: Pitch) {
        let midinoteNumber = (tone.toneHeight+1) * 12 + ChordAnalyzer.analyzeToneName(toneName: tone.toneName)
        self.bank.play(noteNumber: MIDINoteNumber(midinoteNumber), velocity: 127)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) {
            self.bank.stop(noteNumber: MIDINoteNumber(midinoteNumber))
        }
    }
    
}
