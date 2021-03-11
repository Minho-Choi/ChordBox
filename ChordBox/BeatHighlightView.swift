//
//  BeatHighlightView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/11.
//

import UIKit

class BeatHighlightView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(frame: CGRect) {
        layer.sublayers?.removeAll()
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.type = .axial
        gradient.colors = [UIColor.systemTeal.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.3)
        layer.addSublayer(gradient)
    }

}
