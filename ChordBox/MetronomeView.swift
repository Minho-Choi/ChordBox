//
//  MetronomeView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/06.
//

import UIKit

class MetronomeView: UIView {
    
    var bpm: Int = 40 {
        didSet {
            bpmLabel.text = "\(bpm)"
            weightLocationRatio = CGFloat(bpm - 40)/200
            updateLocation()
        }
    }     // bpm range: 40 to 240
    var metronomeWeight = MetronomeWeight()
    var metronomeRod = MetronomeRod()
    var bpmLabel = UILabel()
    
    var metronomeRodHeight: CGFloat = 0
    var rodAspectRatio: CGFloat = 0.05
    var metronomeWeightHeight: CGFloat = 0
    var weightLocationRatio: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        layer.borderWidth = 1.0
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        addSubview(metronomeRod)
        addSubview(metronomeWeight)
        addSubview(bpmLabel)
        metronomeRodHeight = 0.75 * bounds.height
        metronomeWeightHeight = 0.15 * bounds.height
        weightLocationRatio = CGFloat(bpm - 40)/200
                                      
        bpmLabel.frame = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: bounds.width,
            height: bounds.height * 0.2)
        bpmLabel.text = "\(bpm)"
        bpmLabel.adjustsFontSizeToFitWidth = true
        bpmLabel.textAlignment = .center
        
        metronomeWeight.frame = CGRect(
            x: bounds.midX - metronomeWeightHeight * 0.8,
            y: (0.2 + weightLocationRatio * 0.6) * bounds.height,
            width: 1.6 * metronomeWeightHeight,
            height: metronomeWeightHeight)
        metronomeWeight.addGradient()
        
        metronomeRod.frame = CGRect(
            x: bounds.midX - metronomeRodHeight * rodAspectRatio / 2,
            y: 0.2 * bounds.height,
            width: metronomeRodHeight * rodAspectRatio,
            height: metronomeRodHeight)
        metronomeRod.addGradient()
    }
    
    func updateLocation() {
        metronomeWeight.frame = CGRect(
            x: bounds.midX - metronomeWeightHeight * 0.8,
            y: (0.2 + weightLocationRatio * 0.6) * bounds.height,
            width: 1.6 * metronomeWeightHeight,
            height: metronomeWeightHeight)
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            let tapPose = position.y - frame.height * 0.25
            let bpm = Int(((tapPose / frame.height)) * 300) + 40
            if 40...240 ~= bpm {
                self.bpm = bpm
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            let tapPose = position.y - frame.height * 0.25
            let bpm = Int(((tapPose / frame.height)) * 300) + 40
            if 40...240 ~= bpm {
                self.bpm = bpm
            }
        }
    }
    
}

class MetronomeWeight: UIView {
    
    let shapeMask = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        clipsToBounds = true
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
//        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
//        path.fill()
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [#colorLiteral(red: 0.8450841308, green: 0.8081151247, blue: 0.06854876131, alpha: 1).cgColor, UIColor.CustomPalette.textColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
    }
}

class MetronomeRod: UIView {
    
    let shapeMask = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.close()
        shapeMask.path = path.cgPath
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.systemGray.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = shapeMask
        self.layer.addSublayer(gradient)
    }
}
