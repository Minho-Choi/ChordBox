//
//  MetronomeView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/06.
//

import UIKit

class MetronomeView: UIView {
    
    var bpm: Int = 120
    var metronomeView = MetronomeWeight(frame: .zero)
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        addSubview(metronomeView)
        layer.borderWidth = 2.0
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            metronomeView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            metronomeView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            metronomeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            metronomeView.heightAnchor.constraint(equalTo: metronomeView.widthAnchor, multiplier: 0.5)
        ])
        setNeedsDisplay()
    }
    

}

class MetronomeWeight: UIView {
    
    let shapeMask = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.CustomPalette.shadeColor2.cgColor, UIColor.CustomPalette.textColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = shapeMask
        self.layer.insertSublayer(gradient, at: 0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.65, y: rect.minY), controlPoint: CGPoint(x: rect.midX, y: rect.minY + rect.height/5))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.8, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.maxY))
        path.close()
        shapeMask.path = path.cgPath
        #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).setFill()
        path.fill()
    }
}
