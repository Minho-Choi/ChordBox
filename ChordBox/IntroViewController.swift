//
//  IntroViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/09.
//

import UIKit

class IntroViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchChordsFromJSON()
//        getChords()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func getChords() {
        let chords: [ChordForm] = CoreDataManager.shared.getChords(base: "A", type: "7", ascending: true)
        let chordNames: [String] = chords.map({$0.root! + $0.type!})
        print("allChords = \(chordNames)")
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
