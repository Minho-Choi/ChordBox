//
//  ButtonView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/16.
//

import UIKit

class ChordButtonsView: UIView {
    
    var btnArr: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.CustomPalette.backgroundColor.cgColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func makeBtn(frame: CGRect) {
        let buttonHeight = frame.height/7.2
        for index: Int in 0..<ChordButtonData.chordKeys1.count {
            let buttonWidth = frame.width/CGFloat(ChordButtonData.chordKeys1.count)
            let btn = UIButton()
            btn.tag = 0
            self.addSubview(btn)
            btn.backgroundColor = UIColor.CustomPalette.textColor
            btn.layer.borderColor = UIColor.CustomPalette.shadeColor2.cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
            btn.setTitle("\(ChordButtonData.chordKeys1[index])", for: .normal)
            btn.frame = CGRect(
                x: frame.minX + CGFloat(index)*buttonWidth,
                y: frame.minY,
                width: buttonWidth,
                height: buttonHeight
            )
            btnArr.append(btn)
        }
        for index: Int in 0..<ChordButtonData.chordKeys2.count {
            let buttonWidth = frame.width/CGFloat(ChordButtonData.chordKeys2.count)
            let btn = UIButton()
            btn.tag = 0
            self.addSubview(btn)
            btn.backgroundColor = UIColor.CustomPalette.backgroundColor
            btn.setTitleColor(UIColor.CustomPalette.textColor, for: .normal)
            btn.layer.borderColor = UIColor.CustomPalette.shadeColor2.cgColor
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
            btn.setTitle("\(ChordButtonData.chordKeys2[index])", for: .normal)
            btn.frame = CGRect(
                x: frame.minX + CGFloat(index)*buttonWidth,
                y: frame.minY + buttonHeight,
                width: buttonWidth,
                height: buttonHeight
            )
            btnArr.append(btn)
        }
        
        for (index, array) in ChordButtonData.chordTypes.enumerated() {
            for chordNameIndex in 0..<array.count {
                let buttonWidth = frame.width/CGFloat(array.count)
                let btn = UIButton()
                btn.tag = 1
                addSubview(btn)
                btn.backgroundColor = UIColor.CustomPalette.shadeColor2
                btn.setTitleColor(UIColor.CustomPalette.backgroundColor, for: .normal)
                btn.layer.borderColor = UIColor.CustomPalette.backgroundColor.cgColor
                btn.layer.borderWidth = 1
                btn.layer.cornerRadius = 5
                btn.setTitle("\(ChordButtonData.chordTypes[index][chordNameIndex])", for: .normal)
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btn.frame = CGRect(
                    x: frame.minX + CGFloat(chordNameIndex)*buttonWidth,
                    y: frame.minY + buttonHeight*CGFloat((2.2+Double(index))),
                    width: buttonWidth,
                    height: buttonHeight
                )
                btnArr.append(btn)
            }
        }
    }
}
