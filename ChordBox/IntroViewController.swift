//
//  IntroViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/09.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var ChordDictButtonOutlet: UIButton!
    @IBOutlet weak var AddingSongButtonOutlet: UIButton!
    
    var loadingView = LoadingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChordDictButtonOutlet.customizeMyButton(title: "Chord Dictionary")
        AddingSongButtonOutlet.customizeMyButton(title: "Add Song")

        // Do any additional setup after loading the view.
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        loadingView.addViews(frame: view.bounds, title: "Updating Database")
        loadingView.spinner.startAnimating()
        loadingView.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            let clk = clock()
            if !self.getChords() {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.fetchChordsFromJSON()
                    print(clock() - clk)
                    DispatchQueue.main.async {
                        self.loadingView.stopAnimating()
                    }
                }
            } else {
                print(clock() - clk)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.loadingView.stopAnimating()
                }
            }
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
