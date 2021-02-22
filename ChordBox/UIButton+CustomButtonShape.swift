//
//  UIButton+CustomButtonShape.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/19.
//

import UIKit

extension UIButton {
    
    func customizeMyButton(title: String) {
        
        self.layer.sublayers?.remove(at: 0)
        self.clipsToBounds = true
        
        self.setTitleColor(UIColor.CustomPalette.backgroundColor, for: .normal)
        let attrTitle = NSMutableAttributedString(string: title)
        attrTitle.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .headline), range: (title as NSString).range(of: title))
        attrTitle.addAttribute(.foregroundColor, value: UIColor.CustomPalette.backgroundColor, range: (title as NSString).range(of: title))
        self.setAttributedTitle(attrTitle, for: .normal)

        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.CustomPalette.backgroundColor.cgColor, UIColor.CustomPalette.textColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        self.layer.insertSublayer(gradient, at: 0)
        
        layer.cornerRadius = 10
    }
}
