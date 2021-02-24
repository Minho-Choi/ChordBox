//
//  ShowLyricsViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/19.
//

import UIKit

class ShowLyricsViewController: UIViewController {
    var lyrics = ""
    var chordKey: String = "" {
        didSet {
            if chordKey.isNotEmpty {
                noteView.chordName = chordKey
            }
        }
    }
    var chordIdentifier: String = "" {
        didSet {
            if chordIdentifier.isNotEmpty {
                noteView.chordName = chordKey + chordIdentifier + " | " + chordLength
            }
        }
    }
    var chordLength: String = "1" {
        didSet {
            if chordLength.isNotEmpty {
                noteView.chordName = chordKey + chordIdentifier + " | " + chordLength
            }
        }
    }
    let lyricsView = LyricsView(frame: .zero)
    let noteView = ChordNoteSelectView(frame: .zero)
    let chordButtonView = ChordButtonsView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(lyricsView)
        self.view.addSubview(noteView)
        self.view.addSubview(chordButtonView)
        
        noteView.isUserInteractionEnabled = true
        lyricsView.isUserInteractionEnabled = true
        lyricsView.collectionView?.isUserInteractionEnabled = true
        lyricsView.collectionView?.dragInteractionEnabled = true
        let drag = UIDragInteraction(delegate: noteView)
        drag.isEnabled = true
        self.noteView.chordNameLabel.addInteraction(drag)
        self.noteView.chordNameLabel.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        viewWillLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([
            
            lyricsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lyricsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lyricsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lyricsView.bottomAnchor.constraint(equalTo: noteView.topAnchor, constant: -80),
            
            noteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteView.topAnchor.constraint(equalTo: lyricsView.bottomAnchor, constant: 80),
            noteView.bottomAnchor.constraint(equalTo: chordButtonView.topAnchor),
            noteView.heightAnchor.constraint(equalToConstant: 60),
            
            chordButtonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chordButtonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chordButtonView.topAnchor.constraint(equalTo: noteView.bottomAnchor),
            chordButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chordButtonView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lyricsView.updateLayout()
        chordButtonView.updateButtonLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutSubviews()
        lyricsView.setLayout(lyrics: lyrics)
        noteView.createView()
        chordButtonView.makeBtn(frame: chordButtonView.bounds)
        
        for btnRow in chordButtonView.btnArr {
            for btn in btnRow {
                btn.addTarget(self, action: #selector(chordButtonTouched), for: .touchUpInside)
            }
        }
        noteView.wholeNoteButton.addTarget(self, action: #selector(noteButtonTouched), for: .touchUpInside)
        noteView.halfNoteButton.addTarget(self, action: #selector(noteButtonTouched), for: .touchUpInside)
        noteView.quarterNoteButton.addTarget(self, action: #selector(noteButtonTouched), for: .touchUpInside)
        noteView.eighthNoteButton.addTarget(self, action: #selector(noteButtonTouched), for: .touchUpInside)
        noteView.wholeNoteButton.isSelected = true
    }
    
    
    @objc func chordButtonTouched(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "nil")
        if sender.tag == 0  || sender.tag == 1{
            chordKey = sender.titleLabel?.text ?? ""
        } else {
            chordIdentifier = sender.titleLabel?.text ?? ""
        }
    }
    
    @objc func noteButtonTouched(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "nil")
        switch sender.tag {
        case 8:
            chordLength = "1"
            noteView.disselectAllButtons()
            sender.isSelected = true
            break
        case 4:
            chordLength = "1/2"
            noteView.disselectAllButtons()
            sender.isSelected = true
            break
        case 2:
            chordLength = "1/4"
            noteView.disselectAllButtons()
            sender.isSelected = true
            break
        case 1:
            chordLength = "1/8"
            noteView.disselectAllButtons()
            sender.isSelected = true
            break
        default:
            chordLength = ""
            break
        }
    }
}
