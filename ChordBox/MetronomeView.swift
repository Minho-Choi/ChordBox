//
//  MetronomeView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/06.
//

import UIKit
import AVFoundation

class MetronomeView: UIView {
    
    var bpm: Int = 120 {
        didSet {
            bpmLabel.text = "\(bpm)"
            weightLocationRatio = CGFloat(bpm - 40)/200
            updateLocation()
            MetronomeSoundPlayer.shared.setInterval(bpm: bpm)
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
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.7
        layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOffset = CGSize(width: 5, height: 5)
        MetronomeSoundPlayer.shared.prepareSound()
        MetronomeSoundPlayer.shared.setInterval(bpm: bpm)
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
        bpmLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        metronomeWeight.frame = CGRect(
            x: bounds.midX - metronomeWeightHeight * 0.7,
            y: (0.2 + weightLocationRatio * 0.6) * bounds.height,
            width: 1.4 * metronomeWeightHeight,
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
            x: bounds.midX - metronomeWeightHeight * 0.7,
            y: (0.2 + weightLocationRatio * 0.6) * bounds.height,
            width: 1.4 * metronomeWeightHeight,
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
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.05, y: rect.minY + rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.35, y: rect.minY + rect.height * 0.1))
        path.addQuadCurve(to: CGPoint(x: rect.minX + rect.width * 0.65, y: rect.minY + rect.height * 0.1), controlPoint: CGPoint(x: rect.midX, y: rect.minY + rect.height/4))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.95, y: rect.minY + rect.height * 0.1))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.8, y: rect.minY + rect.height * 0.9))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY + rect.height * 0.9))
        path.close()
        shapeMask.path = path.cgPath
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        gradient.colors = [#colorLiteral(red: 0.8931563497, green: 0.7706534266, blue: 0.4693405628, alpha: 1).cgColor, #colorLiteral(red: 0.7288641334, green: 0.6141987443, blue: 0.2094997764, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
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
