//
//  ButtonView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/16.
//

import UIKit

class ChordButtonsView: UIView {

    var btnArr = [[UIButton]]()

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
        let buttonHeight = frame.height/7.1
        var firstRowButtons = [UIButton]()
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
            firstRowButtons.append(btn)
        }
        btnArr.append(firstRowButtons)
        var secondRowButtons = [UIButton]()
        for index: Int in 0..<ChordButtonData.chordKeys2.count {
            let buttonWidth = frame.width/CGFloat(ChordButtonData.chordKeys2.count)
            let btn = UIButton()
            btn.tag = 1
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
            secondRowButtons.append(btn)
        }
        btnArr.append(secondRowButtons)
        for (index, array) in ChordButtonData.chordTypes.enumerated() {
            var rowButtons = [UIButton]()
            for chordNameIndex in 0..<array.count {
                let buttonWidth = frame.width/CGFloat(array.count)
                let btn = UIButton()
                btn.tag = index + 2
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
                    y: frame.minY + buttonHeight*CGFloat((2.1+Double(index))),
                    width: buttonWidth,
                    height: buttonHeight
                )
                rowButtons.append(btn)
            }
            btnArr.append(rowButtons)
        }
    }

    func updateButtonLayout() {
        for (row, btnRow) in btnArr.enumerated() {
            for (index, btn) in btnRow.enumerated() {
                btn.frame = CGRect(
                    x: bounds.minX + CGFloat(index)*frame.width/CGFloat(btnRow.count),
                    y: bounds.minY + frame.height/7.1 * CGFloat((Double(row) + (row > 1 ? 0 : 0.1))),
                    width: frame.width/CGFloat(btnRow.count),
                    height: frame.height/7.1)
            }
        }
    }
}
