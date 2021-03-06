//
//  MenuViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/21.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var chordDictButtonOutlet: UIButton!
    @IBOutlet weak var addingSongButtonOutlet: UIButton!

//    var chordDictButton = UIButton(frame: .zero)
//    var addSongButton = UIButton(frame: .zero)
//    var playSongButton = UIButton(frame: .zero)
//    var settingButton = UIButton(frame: .zero)
    var chordDictButton = MenuButtonView(frame: .zero)
    var addSongButton = MenuButtonView(frame: .zero)
    var playSongButton = MenuButtonView(frame: .zero)
    var settingButton = MenuButtonView(frame: .zero)
    var buttonPadding: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "square.grid.2x2")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "square.grid.2x2")

//        chordDictButton.translatesAutoresizingMaskIntoConstraints = false
//        addSongButton.translatesAutoresizingMaskIntoConstraints = false
//        playSongButton.translatesAutoresizingMaskIntoConstraints = false
//        settingButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(chordDictButton)
        view.addSubview(addSongButton)
        view.addSubview(playSongButton)
        view.addSubview(settingButton)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let segueToChordView = UITapGestureRecognizer(target: self, action: #selector(performChordDictSegue))
        let segueToAddView = UITapGestureRecognizer(target: self, action: #selector(performAddSongSegue))
        chordDictButton.addGestureRecognizer(segueToChordView)
        addSongButton.addGestureRecognizer(segueToAddView)
    }

    @objc func performChordDictSegue() {
        performSegue(withIdentifier: "ChordDictSegue", sender: self)
    }
    @objc func performAddSongSegue() {
        performSegue(withIdentifier: "AddSongSegue", sender: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLayoutSubviews() {
//        chordDictButton.customizeMyButton(title: "Chord Dictionary")
//        addSongButton.customizeMyButton(title: "Add Song")
//        playSongButton.customizeMyButton(title: "Play Song")
//        settingButton.customizeMyButton(title: "Settings")
        chordDictButton.updateView(title: "Chord Dictionary", imageName: "character.book.closed")
        addSongButton.updateView(title: "Add Song", imageName: "note.text.badge.plus")
        playSongButton.updateView(title: "Play Song", imageName: "ipad.landscape.badge.play")
        settingButton.updateView(title: "Settings", imageName: "gearshape")
    }

    override func viewWillLayoutSubviews() {

        let minX = view.safeAreaLayoutGuide.leadingAnchor
        let midX = view.safeAreaLayoutGuide.centerXAnchor
        let maxX = view.safeAreaLayoutGuide.trailingAnchor
        let minY = view.safeAreaLayoutGuide.topAnchor
        let midY = view.safeAreaLayoutGuide.centerYAnchor
        let maxY = view.safeAreaLayoutGuide.bottomAnchor

        NSLayoutConstraint.activate([
            chordDictButton.topAnchor.constraint(equalTo: minY, constant: buttonPadding),
            chordDictButton.bottomAnchor.constraint(equalTo: midY, constant: -buttonPadding/2),
            chordDictButton.leadingAnchor.constraint(equalTo: minX, constant: buttonPadding),
            chordDictButton.trailingAnchor.constraint(equalTo: midX, constant: -buttonPadding/2),

            addSongButton.topAnchor.constraint(equalTo: minY, constant: buttonPadding),
            addSongButton.bottomAnchor.constraint(equalTo: midY, constant: -buttonPadding/2),
            addSongButton.leadingAnchor.constraint(equalTo: midX, constant: buttonPadding/2),
            addSongButton.trailingAnchor.constraint(equalTo: maxX, constant: -buttonPadding),

            playSongButton.topAnchor.constraint(equalTo: midY, constant: buttonPadding/2),
            playSongButton.bottomAnchor.constraint(equalTo: maxY, constant: -buttonPadding),
            playSongButton.leadingAnchor.constraint(equalTo: minX, constant: buttonPadding),
            playSongButton.trailingAnchor.constraint(equalTo: midX, constant: -buttonPadding/2),

            settingButton.topAnchor.constraint(equalTo: midY, constant: buttonPadding/2),
            settingButton.bottomAnchor.constraint(equalTo: maxY, constant: -buttonPadding),
            settingButton.leadingAnchor.constraint(equalTo: midX, constant: buttonPadding/2),
            settingButton.trailingAnchor.constraint(equalTo: maxX, constant: -buttonPadding)
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
