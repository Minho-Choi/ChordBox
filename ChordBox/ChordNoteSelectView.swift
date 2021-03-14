//
//  ChordNoteSelectView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/24.
//

import UIKit

class ChordNoteSelectView: UIView, UIDragInteractionDelegate {

    var chordName: String = "" {
        didSet {
            chordNameLabel.text = self.chordName
        }
    }

    var chordNameLabel = UILabel()
    var wholeNoteButton = UIButton()
    var halfNoteButton = UIButton()
    var quarterNoteButton = UIButton()
    var eighthNoteButton = UIButton()
    var buttons = [UIButton]()

    let padding: CGFloat = 4

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        chordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wholeNoteButton.translatesAutoresizingMaskIntoConstraints = false
        halfNoteButton.translatesAutoresizingMaskIntoConstraints = false
        quarterNoteButton.translatesAutoresizingMaskIntoConstraints = false
        eighthNoteButton.translatesAutoresizingMaskIntoConstraints = false
        buttons = [wholeNoteButton, halfNoteButton, quarterNoteButton, eighthNoteButton]
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }

    func createView() {
        addSubview(chordNameLabel)
        addSubview(wholeNoteButton)
        addSubview(halfNoteButton)
        addSubview(quarterNoteButton)
        addSubview(eighthNoteButton)
        NSLayoutConstraint.activate([
            chordNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            chordNameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            chordNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            chordNameLabel.trailingAnchor.constraint(equalTo: wholeNoteButton.leadingAnchor, constant: -padding),

            wholeNoteButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            wholeNoteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            wholeNoteButton.leadingAnchor.constraint(equalTo: chordNameLabel.trailingAnchor, constant: padding),
            wholeNoteButton.trailingAnchor.constraint(equalTo: halfNoteButton.leadingAnchor, constant: -padding),
            wholeNoteButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.1),

            halfNoteButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            halfNoteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            halfNoteButton.leadingAnchor.constraint(equalTo: wholeNoteButton.trailingAnchor, constant: padding),
            halfNoteButton.trailingAnchor.constraint(equalTo: quarterNoteButton.leadingAnchor, constant: -padding),
            halfNoteButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.1),

            quarterNoteButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            quarterNoteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            quarterNoteButton.leadingAnchor.constraint(equalTo: halfNoteButton.trailingAnchor, constant: padding),
            quarterNoteButton.trailingAnchor.constraint(equalTo: eighthNoteButton.leadingAnchor, constant: -padding),
            quarterNoteButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.1),

            eighthNoteButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            eighthNoteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            eighthNoteButton.leadingAnchor.constraint(equalTo: quarterNoteButton.trailingAnchor, constant: padding),
            eighthNoteButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            eighthNoteButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.1)
        ])
        chordNameLabel.text = chordName
        chordNameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        chordNameLabel.adjustsFontSizeToFitWidth = true
        chordNameLabel.textAlignment = .center
        chordNameLabel.layer.borderColor = UIColor.CustomPalette.pointColor.cgColor
        chordNameLabel.layer.borderWidth = 2.0
        chordNameLabel.layer.cornerRadius = 10

        let wholeImage = UIImage(named: "whole")?.withRenderingMode(.alwaysTemplate)
        let halfImage = UIImage(named: "half")?.withRenderingMode(.alwaysTemplate)
        let quarterImage = UIImage(named: "quarter")?.withRenderingMode(.alwaysTemplate)
        let eighthImage = UIImage(named: "eight")?.withRenderingMode(.alwaysTemplate)

        wholeNoteButton.setImage(wholeImage, for: .normal)
        halfNoteButton.setImage(halfImage, for: .normal)
        quarterNoteButton.setImage(quarterImage, for: .normal)
        eighthNoteButton.setImage(eighthImage, for: .normal)
        
        wholeNoteButton.tag = 8
        halfNoteButton.tag = 4
        quarterNoteButton.tag = 2
        eighthNoteButton.tag = 1

        for btn in buttons {
            btn.backgroundColor = UIColor.CustomPalette.shadeColor1
            btn.setTitleColor(UIColor.CustomPalette.pointColor, for: .selected)
            btn.setTitleColor(UIColor.CustomPalette.textColor, for: .normal)
            btn.layer.cornerRadius = 10
            btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            btn.imageView?.contentMode = .scaleAspectFit
        }
    }

    func disselectAllButtons() {
        for btn in buttons {
            btn.isSelected = false
        }
    }

    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        session.localContext = self.chordNameLabel
        return dragItems()
    }

    private func dragItems() -> [UIDragItem] {
        // cellForItem: Returns the visible cell object at the specified index path.
        let string = "^" + self.chordName
        let item = UIDragItem(itemProvider: NSItemProvider(object: string as NSString))
        item.localObject = string
        return [item]
    }
}
