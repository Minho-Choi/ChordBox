//
//  ShowLyricsViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/19.
//

import UIKit

class ShowLyricsViewController: UIViewController {

    // lyrics and chord names
    var songInfo: Sheet = Sheet(title: "TEST TITLE", singer: "TEST SINGER", lyricsString: "TEST LYRICS TEST LYRICS")
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
                noteView.chordName = chordKey + chordIdentifier + "\n" + chordLength
            }
        }
    }
    var chordLength: String = "1" {
        didSet {
            if chordLength.isNotEmpty {
                noteView.chordName = chordKey + chordIdentifier + "\n" + chordLength
            }
        }
    }

    // subviews
    let lyricsView = LyricsView(frame: .zero)
    let noteView = ChordNoteSelectView(frame: .zero)
    let chordButtonView = ChordButtonsView(frame: .zero)

    // nav bar buttons
//    lazy var undoBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward"), style: .plain, target: self, action: #selector(undoButtonTouched))
//    lazy var redoBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.forward"), style: .plain, target: self, action: #selector(redoButtonTouched))
//    lazy var multiSelectBarButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: self, action: #selector(multiSelectButtonTouched(_:)))
    lazy var undoBarButton = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(undoButtonTouched(_:)))
    lazy var redoBarButton = UIBarButtonItem(title: "Redo", style: .plain, target: self, action: #selector(redoButtonTouched))
    lazy var multiSelectBarButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(multiSelectButtonTouched(_:)))
    lazy var doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTouched))
    var editModePicker = UISegmentedControl(items: ["Copy", "Move", "Delete"])
    lazy var editModeBarItem = UIBarButtonItem(customView: editModePicker)

    // multitouch boolean
    var isMultiSelectEnabled = false
    var editMode = EditMode(rawValue: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(lyricsView)
        self.view.addSubview(noteView)
        self.view.addSubview(chordButtonView)
        
        self.navigationItem.leftBarButtonItems = [undoBarButton, redoBarButton, multiSelectBarButton]
        self.navigationItem.setHidesBackButton(false, animated: true)
        editModePicker.selectedSegmentIndex = 0
        editModePicker.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
        self.navigationItem.setRightBarButton(doneBarButton, animated: true)
        
        view.isUserInteractionEnabled = true
        noteView.isUserInteractionEnabled = true
        self.noteView.chordNameLabel.isUserInteractionEnabled = true
        lyricsView.isUserInteractionEnabled = true
        lyricsView.collectionView?.isUserInteractionEnabled = true
        lyricsView.collectionView?.dragInteractionEnabled = true
        let drag = UIDragInteraction(delegate: noteView)
        self.noteView.chordNameLabel.addInteraction(drag)
        drag.isEnabled = true
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        NSLayoutConstraint.activate([

            lyricsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lyricsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lyricsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lyricsView.bottomAnchor.constraint(equalTo: noteView.topAnchor),

            noteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteView.topAnchor.constraint(equalTo: lyricsView.bottomAnchor),
            noteView.bottomAnchor.constraint(equalTo: chordButtonView.topAnchor),
            noteView.heightAnchor.constraint(equalToConstant: 40),

            chordButtonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chordButtonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chordButtonView.topAnchor.constraint(equalTo: noteView.bottomAnchor),
            chordButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chordButtonView.heightAnchor.constraint(equalToConstant: 240)

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
        lyricsView.setLayout(lyrics: songInfo.lyricsString)
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

    @objc func undoButtonTouched(_ sender: UIButton) {
        self.lyricsView.undo()
    }

    @objc func redoButtonTouched(_ sender: UIButton) {
        self.lyricsView.redo()
    }

    @objc func multiSelectButtonTouched(_ sender: UIButton) {
        isMultiSelectEnabled = multiSelectBarButton.style == UIBarButtonItem.Style.plain
        lyricsView.isMultiSelectEnabled = isMultiSelectEnabled
        multiSelectBarButton.style =  isMultiSelectEnabled ? UIBarButtonItem.Style.done : UIBarButtonItem.Style.plain
        if isMultiSelectEnabled {
            self.navigationItem.setRightBarButtonItems([editModeBarItem], animated: true)
        } else {
            self.editModePicker.selectedSegmentIndex = 0
//            self.editModePicker.selectedSegmentTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.navigationItem.setRightBarButton(self.doneBarButton, animated: true)
            self.lyricsView.updateEditMode(mode: self.editModePicker.selectedSegmentIndex)
        }
    }

    @objc func segmentControlChanged() {
        editMode = EditMode(rawValue: editModePicker.selectedSegmentIndex)
        if editMode?.rawValue == 2 {
            UIView.animate(withDuration: 1, animations: {
                self.editModePicker.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
//                self.editModePicker.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
//                self.editModePicker.selectedSegmentTintColor = UIColor.white
                self.editModePicker.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            })
        }
        lyricsView.updateEditMode(mode: editMode!.rawValue)
    }

    @objc func doneButtonTouched() {
        performSegue(withIdentifier: "SaveSheetSegue", sender: self)
    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSheetSegue" {
            let vc = segue.destination as! PlaySongViewController
            songInfo.chordLyricsData = self.lyricsView.lyrics
            vc.songData = songInfo
        }
    }

}

enum EditMode: Int {
    case copy = 0
    case move = 1
    case delete = 2
}
