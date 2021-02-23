//
//  IntroViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/09.
//

import UIKit

class IntroViewController: UIViewController {
    
    var loadingView = LoadingView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "square.grid.2x2")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "square.grid.2x2")

        // Do any additional setup after loading the view.
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        loadingView.addViews(frame: view.bounds, title: "Updating Database")
        loadingView.startAnimating()
        loadingView.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
//        DispatchQueue.global(qos: .userInitiated).async {
        let clk = clock()
        if !self.getChords() {
            self.fetchChordsFromJSON()
            print(clock() - clk)
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.performSegue(withIdentifier: "LoadingEndedSegue", sender: nil)
            }
        } else {
            print(clock() - clk)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadingView.stopAnimating()
                self.performSegue(withIdentifier: "LoadingEndedSegue", sender: nil)
            }
        }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func getChords() -> Bool {
        let chords: [ChordForm] = CoreDataManager.shared.getChords(base: "A", type: "7", ascending: true)
        let chordNames: [String] = chords.map({$0.root! + $0.type!})
        print("allChords = \(chordNames)")
        if chords.isEmpty {
            return false
        }
        return true
    }
    
    // 새로운 유저 등록
    fileprivate func saveChord(id: UUID, root: String, type: String, structure: String, fingerPositions: String, noteNames: String) {
        CoreDataManager.shared
            .saveChord(id: id, root: root, type: type, structure: structure, fingerPositions: fingerPositions, noteNames: noteNames) { onSuccess in
                print("saved: \(onSuccess)")
            }
    }
    
    fileprivate func fetchChordsFromJSON() {
        struct Chord: Decodable {
            var CHORD_ROOT: String
            var CHORD_TYPE: String
            var CHORD_STRUCTURE: String
            var FINGER_POSITIONS: String
            var NOTE_NAMES: String
        }
        struct ChordBox: Decodable {
            var result: [Chord]
        }
        if let filePath = Bundle.main.url(forResource: "chord_fingers", withExtension: "json") {
            do {
                let data = try Data(contentsOf: filePath)
                let decoder = JSONDecoder()
                let chords = try decoder.decode([Chord].self, from: data)
                for chord in chords {
                    saveChord(
                        id: UUID(),
                        root: chord.CHORD_ROOT,
                        type: chord.CHORD_TYPE,
                        structure: chord.CHORD_STRUCTURE,
                        fingerPositions: chord.FINGER_POSITIONS,
                        noteNames: chord.NOTE_NAMES
                    )
                }
            } catch {
                print("error: \(error)")
            }
        }
    }

}


