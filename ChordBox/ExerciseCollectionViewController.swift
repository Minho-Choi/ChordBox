//
//  ExerciseCollectionViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/23.
//

import UIKit

class ExerciseCollectionViewController: UIViewController {

    var lyrics =
        """
So are you happy now?
Finally happy now, are you?
뭐 그대로야 난
다 잃어버린 것 같아
모든 게 맘대로 왔다가 인사도 없이 떠나
이대로는 무엇도 사랑하고 싶지 않아
다 해질 대로 해져버린
기억 속을 여행해
우리는 오렌지 태양 아래
그림자 없이 함께 춤을 춰
정해진 이별 따위는 없어
아름다웠던 그 기억에서 만나
Forever young
우우우 우우우우
우우우 우우우우
Forever, we young
우우우 우우우우
이런 악몽이라면 영영 깨지 않을게
섬 그래 여긴 섬
서로가 만든 작은 섬
예 음 forever young
영원이란 말은 모래성
작별은 마치 재난문자 같지
그리움과 같이 맞이하는 아침
서로가 이 영겁을 지나
꼭 이 섬에서 다시 만나
지나듯 날 위로하던 누구의 말대로 고작
한 뼘짜리 추억을 잊는 게 참 쉽지 않아
시간이 지나도 여전히
날 붙드는 그곳에
우리는 오렌지 태양 아래
그림자 없이 함께 춤을 춰
정해진 안녕 따위는 없어
아름다웠던 그 기억에서 만나
우리는 서로를 베고 누워
슬프지 않은 이야기를 나눠
우울한 결말 따위는 없어
난 영원히 널 이 기억에서 만나
Forever young
우우우 우우우우
우우우 우우우우
Forever, we young
우우우 우우우우
이런 악몽이라면 영영 깨지 않을게
"""
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
            lyricsView.bottomAnchor.constraint(equalTo: noteView.topAnchor, constant: -20),

            noteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteView.topAnchor.constraint(equalTo: lyricsView.bottomAnchor),
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
        if sender.tag == 0  || sender.tag == 1 {
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
        case 4:
            chordLength = "1/2"
            noteView.disselectAllButtons()
            sender.isSelected = true
        case 2:
            chordLength = "1/4"
            noteView.disselectAllButtons()
            sender.isSelected = true
        case 1:
            chordLength = "1/8"
            noteView.disselectAllButtons()
            sender.isSelected = true
        default:
            chordLength = ""
        }
    }
}
