//
//  ChordDictViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/16.
//

import UIKit
import AudioKit

class ChordDictViewController: UIViewController {
    
    // Custom Views
    var chordView = GuitarChordView(frame: .zero)
    var buttonView = ChordButtonsView(frame: .zero)
    var metronomeView = MetronomeView(frame: CGRect(x: 0, y: 100, width: 70, height: 300))
    let backgroundHighlightView = BeatHighlightView()
    
    // Labels and Buttons
    var chordNameLabel = UILabel(frame: .zero)
    lazy var metronomePlayBarButton = UIBarButtonItem(image: UIImage(systemName: "play.circle"), style: .plain, target: self, action: #selector(playButtonTouched))
    lazy var metronomeSetBarButton = UIBarButtonItem(image: UIImage(systemName: "metronome"), style: .plain, target: self, action: #selector(metronomeButtonTouched))
    
    // Analyzer Model
    private var chordAnalyzer: ChordAnalyzer?
    
    // Sound Player
    weak var chordSoundPlayer: AKPWMOscillatorBank?
    
    // vars
    private var chordTones = [Pitch]()
    var currentChordIndex = 0
    var numberOfChordsSearched = 0
    
    var chordKey: String = "" {
        didSet {
            chordNameLabel.text = chordKey
        }
    }
    var chordIdentifier: String = "" {
        didSet {
            chordNameLabel.text = chordKey + chordIdentifier
        }
    }
    var isMetronomeViewPopped = true {
        didSet {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    if self.isMetronomeViewPopped {
                        self.metronomeView.transform = CGAffineTransform(translationX: self.view.frame.maxX, y: 0)
                    } else {
                        self.metronomeView.transform = CGAffineTransform(translationX: self.view.frame.maxX - 80, y: 0)
                    }
                },
                completion: nil
            )
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chordAnalyzer = ChordAnalyzer.shared
        
        metronomeSetBarButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        metronomePlayBarButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        navigationItem.rightBarButtonItems = [metronomeSetBarButton, metronomePlayBarButton]
        MetronomeSoundPlayer.shared.delegate = self
        backgroundHighlightView.isUserInteractionEnabled = false

        view.addSubview(chordNameLabel)
        view.addSubview(chordView)
        view.addSubview(buttonView)
        view.addSubview(backgroundHighlightView)
        view.addSubview(metronomeView)
        metronomeView.transform = CGAffineTransform(translationX: self.view.frame.maxX, y: 0)
        
        setChordNameLabel()
        setBackgroundHighlightView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutSubviews()
        buttonView.makeBtn(frame: buttonView.bounds)
        metronomeView.setConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addGestureToChordView()
        addTargetToEachButtons()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            chordNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            chordNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            chordNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            chordNameLabel.bottomAnchor.constraint(equalTo: chordView.topAnchor, constant: -padding),
            chordNameLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 70),

            buttonView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            buttonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            buttonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            buttonView.heightAnchor.constraint(equalToConstant: 300),

            chordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            chordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            chordView.topAnchor.constraint(equalTo: chordNameLabel.bottomAnchor, constant: padding),
            chordView.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: -padding),
            
        ])
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        buttonView.updateButtonLayout()
        updateIndexView()
        chordView.setNeedsDisplay()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if MetronomeSoundPlayer.shared.isMetronomeOn {
            MetronomeSoundPlayer.shared.isMetronomeOn.toggle()
        }
    }
}

// MARK: - Function Implementations

extension ChordDictViewController {
    
    func setChordNameLabel() {
        chordNameLabel.font = .systemFont(ofSize: 32)
        chordNameLabel.textAlignment = .center
        chordNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setBackgroundHighlightView() {
        backgroundHighlightView.frame = self.view.frame
        backgroundHighlightView.fill(frame: self.view.frame)
        backgroundHighlightView.alpha = 0
    }
    
    func addGestureToChordView() {
        let chordSoundPlay = UITapGestureRecognizer(target: self, action: #selector(chordTouched))
        let chordChangeBack = UISwipeGestureRecognizer(target: self, action: #selector(chordSwipedLeft))
        chordChangeBack.direction = .left
        let chordChangeForward = UISwipeGestureRecognizer(target: self, action: #selector(chordSwipedRight))
        chordChangeForward.direction = .right
        chordView.addGestureRecognizer(chordSoundPlay)
        chordView.addGestureRecognizer(chordChangeBack)
        chordView.addGestureRecognizer(chordChangeForward)
    }
    
    func addTargetToEachButtons() {
        for btnRow in buttonView.btnArr {
            for btn in btnRow {
                btn.addTarget(self, action: #selector(ChordDictViewController.buttonTouched), for: .touchUpInside)
            }
        }
    }

    func updateIndexView() {
        if chordView.subviews.isEmpty || chordView.subviews.count != numberOfChordsSearched {
            for childView in chordView.subviews {
                childView.removeFromSuperview()
            }
            let imageWidth = chordView.bounds.width/15
            for index in 0..<numberOfChordsSearched {
                let image = UIImage(named: "")
                let indexer = UIButton()
                indexer.setImage(image, for: .normal)
                if index == currentChordIndex {
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
                if view.tag == currentChordIndex {
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

    func searchChord() {
        print("search chord \(chordNameLabel.text!)")
        currentChordIndex = 0
        if let chordText = chordNameLabel.text, let tones = chordAnalyzer?.analyze(chordString: chordText, toneHeight: 3), tones.isNotEmpty {
            chordTones = tones[currentChordIndex].pitches
            numberOfChordsSearched = tones.count
            print("found: \(numberOfChordsSearched) chords")
            chordView.chord = tones[currentChordIndex]
            chordView.openChord = chordAnalyzer!.currentTuning
        }
        updateIndexView()
    }

}

// MARK: - Selector Functions

extension ChordDictViewController {
    
    @objc func setIndexer(_ sender: UIButton) {
        currentChordIndex = sender.tag
        if let chordText = chordNameLabel.text, let tones = chordAnalyzer?.analyze(chordString: chordText, toneHeight: 3) {
            chordView.chord = tones[currentChordIndex]
            chordTones = tones[currentChordIndex].pitches
        }
        updateIndexView()
    }

    @objc func chordTouched() {
        for (idx, tone) in chordTones.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1*Double(idx)) {
                ChordSoundPlayer.shared.playTone(tone: tone)
            }
        }
    }

    @objc func chordSwipedLeft() {
        print("swipe left")
        if currentChordIndex == 0 {
            currentChordIndex = numberOfChordsSearched-1
        } else {
            currentChordIndex -= 1
        }
        if let chordText = chordNameLabel.text, let tones = chordAnalyzer?.analyze(chordString: chordText, toneHeight: 3) {
            chordView.chord = tones[currentChordIndex]
            chordTones = tones[currentChordIndex].pitches
        }
        updateIndexView()
    }

    @objc func chordSwipedRight() {
        print("swipe right")
        if currentChordIndex == numberOfChordsSearched - 1 {
            currentChordIndex = 0
        } else {
            currentChordIndex += 1
        }
        if let chordText = chordNameLabel.text, let tones = chordAnalyzer?.analyze(chordString: chordText, toneHeight: 3) {
            chordView.chord = tones[currentChordIndex]
            chordTones = tones[currentChordIndex].pitches
        }
        updateIndexView()
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
        MetronomeSoundPlayer.shared.isMetronomeOn.toggle()
        if MetronomeSoundPlayer.shared.isMetronomeOn {
            metronomePlayBarButton.tintColor = UIColor.CustomPalette.pointColor
        } else {
            metronomePlayBarButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }
    
    @objc func metronomeButtonTouched() {
        isMetronomeViewPopped.toggle()
        if !isMetronomeViewPopped {
            metronomeSetBarButton.tintColor = UIColor.CustomPalette.pointColor
        } else {
            metronomeSetBarButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }
}

// MARK: - View highlight delegate implementation

extension ChordDictViewController: AnimateViewControllerFromViewDelegate {
    
    func animateView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.backgroundHighlightView.alpha = 0.5
            }, completion: { done in
                if done {
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                        self.backgroundHighlightView.alpha = 0
                    })
                }
            }
            )
        }
    }
}
