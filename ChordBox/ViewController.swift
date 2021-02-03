//
//  ViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chordLabel: UILabel!
    @IBOutlet weak var chordTextFieldOutlet: UITextField!
    let chordAnalyzer = ChordAnalyzer()
    var chordTones = [Pitch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chordTextFieldOutlet.delegate = self
        // Do any additional setup after loading the view.
        
//        let chordToAnalyze = ["D", "DM7/C#", "D7/C", "G/B", "G", "D/F#", "E7", "Asus4"]
//        for chord in chordToAnalyze {
//            print("Analyze: ",chord)
//            if let elements = chordAnalyzer.analyze(chordString: chord, toneHeight: 3) {
//                for element in elements {
//                    print(element.description)
//                }
//            } else {
//                print("analysis failed")
//            }
//            print("---------------------")
//        }
        
    }
    

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var string = ""
        if let tones = chordAnalyzer.analyze(chordString: chordTextFieldOutlet.text ?? "", toneHeight: 3) {
            self.chordTones = tones
            for tone in tones {
                string.append(tone.description + " ")
            }
        }
        chordLabel.text = string
        return true
    }
}
