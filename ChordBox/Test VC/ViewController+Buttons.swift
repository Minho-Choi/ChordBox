//
//  ViewController+Buttons.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/16.
//

import UIKit

extension ViewController {

    func makeBtn() {
        let buttonHeight = buttonView.frame.height/7.2
        for index: Int in 0..<ChordButtonData.chordKeys1.count {
            let buttonWidth = buttonView.frame.width/CGFloat(ChordButtonData.chordKeys1.count)
            let btn = UIButton()
            btn.tag = 0
            self.view.addSubview(btn)
            btn.backgroundColor = UIColor.CustomPalette.textColor
            btn.layer.borderColor = UIColor.CustomPalette.shadeColor2.cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
            btn.setTitle("\(ChordButtonData.chordKeys1[index])", for: .normal)
            btn.frame = CGRect(
                x: buttonView.frame.minX + CGFloat(index)*buttonWidth,
                y: buttonView.frame.minY,
                width: buttonWidth,
                height: buttonHeight
            )
            btn.addTarget(self, action: #selector(ViewController.buttonTouched), for: .touchUpInside)
            btnArr.append(btn)
        }
        for index: Int in 0..<ChordButtonData.chordKeys2.count {
            let buttonWidth = buttonView.frame.width/CGFloat(ChordButtonData.chordKeys2.count)
            let btn = UIButton()
            btn.tag = 0
            self.view.addSubview(btn)
            btn.backgroundColor = UIColor.CustomPalette.backgroundColor
            btn.setTitleColor(UIColor.CustomPalette.textColor, for: .normal)
            btn.layer.borderColor = UIColor.CustomPalette.shadeColor2.cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
            btn.setTitle("\(ChordButtonData.chordKeys2[index])", for: .normal)
            btn.frame = CGRect(
                x: buttonView.frame.minX + CGFloat(index)*buttonWidth,
                y: buttonView.frame.minY + buttonHeight,
                width: buttonWidth,
                height: buttonHeight
            )
            btn.addTarget(self, action: #selector(ViewController.buttonTouched), for: .touchUpInside)
            btnArr.append(btn)
        }

        for (index, array) in ChordButtonData.chordTypes.enumerated() {
            for chordNameIndex in 0..<array.count {
                let buttonWidth = buttonView.frame.width/CGFloat(array.count)
                let btn = UIButton()
                btn.tag = 1
                self.view.addSubview(btn)
                btn.backgroundColor = UIColor.CustomPalette.shadeColor2
                btn.setTitleColor(UIColor.CustomPalette.backgroundColor, for: .normal)
                btn.layer.borderColor = UIColor.CustomPalette.backgroundColor.cgColor
                btn.layer.borderWidth = 1
                btn.layer.cornerRadius = 5
                btn.setTitle("\(ChordButtonData.chordTypes[index][chordNameIndex])", for: .normal)
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btn.frame = CGRect(
                    x: buttonView.frame.minX + CGFloat(chordNameIndex)*buttonWidth,
                    y: buttonView.frame.minY + buttonHeight*CGFloat((2.2+Double(index))),
                    width: buttonWidth,
                    height: buttonHeight
                )
                btn.addTarget(self, action: #selector(ViewController.buttonTouched), for: .touchUpInside)
                btnArr.append(btn)
            }
        }
    }

    @objc func buttonTouched(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "nil")
        if sender.tag == 0 {
            chordKey = sender.titleLabel?.text ?? ""
        } else {
            chordIdentifier = sender.titleLabel?.text ?? ""
//            searchChord()
        }
//        sender.isEnabled = true
//        sender.layer.borderColor = UIColor.CustomPalette.pointColor.cgColor
    }
}

struct ChordButtonData {
    static let chordKeys1 = ["C#", "D#", "F#", "G#", "A#"]
    static let chordKeys2 = ["C", "D", "E", "F", "G", "A", "B"]
    static let chordTypes = [["maj", "m", "7", "sus4", "dim", "aug", "sus2"],
                             ["maj7", "m7", "7b5", "7sus4", "dim7", "13", "9"],
                             ["maj9", "m7b5", "7(#11)", "7(b13)", "5", "13(#11)", "9(#11)"],
                             ["maj13", "m9", "7(#5)", "7(b9)", "6", "13(#9)", "9b5"],
                             ["m6", "m11", "7(#9)", "11", "6add9", "13(b9)", "add9"]]
}
