//
//  UIButton+CustomButtonShape.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/19.
//

import UIKit

extension UIButton {
    
    func customizeMyButton(title: String) {
        
        self.setTitleColor(UIColor.CustomPalette.backgroundColor, for: .normal)
        let attrTitle = NSMutableAttributedString(string: title)
        attrTitle.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title1), range: (title as NSString).range(of: title))
        attrTitle.addAttribute(.foregroundColor, value: UIColor.CustomPalette.backgroundColor, range: (title as NSString).range(of: title))
        self.setAttributedTitle(attrTitle, for: .normal)
//        self.frame = CGRect(
//            x: self.frame.midX - self.frame.width * 0.75,
//            y: self.frame.midY - self.frame.height * 0.75,
//            width: self.frame.width * 1.5,
//            height: self.frame.height * 1.5)
//        self.layer.backgroundColor = UIColor.clear.cgColor
//        self.backgroundRect(forBounds: )
//        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let gradient = CAGradientLayer()
        gradient.cornerRadius = 10
        gradient.colors = [UIColor.CustomPalette.shadeColor2.cgColor, UIColor.CustomPalette.shadeColor1.cgColor]
        gradient.frame = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.intrinsicContentSize.width, height: self.intrinsicContentSize.height)
        self.layer.addSublayer(gradient)
        
    }
}
