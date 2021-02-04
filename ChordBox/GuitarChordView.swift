//
//  GuitarChordView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/03.
//

import UIKit
@IBDesignable
class GuitarChordView: UIView {
    
    var openChord: [Pitch] = []
    var chord: [Pitch] = []
    
    override func draw(_ rect: CGRect) {
        let chordWidth = rect.width * GuitarChordViewConstants.widthPropotion
        let fretWidth = chordWidth / 4
        let chordHeight = rect.height * GuitarChordViewConstants.heightProportion
        let stringWidth = chordHeight / 5
        let startPoint = CGPoint(x: 3*(rect.width - chordWidth)/4, y: (rect.height - chordHeight)/3)
        let dotRadius = fretWidth * GuitarChordViewConstants.dotRadiusProportion
        let smallDotRadius = fretWidth * GuitarChordViewConstants.smallDotRadiusProportion
        let dotStartPoint = CGPoint(x: startPoint.x + fretWidth/2-dotRadius, y: startPoint.y - dotRadius)
        let smallDotStartPoint = CGPoint(x: startPoint.x + fretWidth/2-smallDotRadius, y: startPoint.y - smallDotRadius)
        let path = UIBezierPath()
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setStroke()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + chordHeight))
        path.lineWidth = chordWidth * GuitarChordViewConstants.thickThicknessProportion
        path.lineJoinStyle = .miter
        path.lineCapStyle = .square
        path.stroke()

        path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: startPoint.y + chordHeight))
        path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: startPoint.y))
        path.close()
        
        
        for idx in 1..<4 {
            let linePositionX = startPoint.x + fretWidth*CGFloat(idx)
            path.move(to: CGPoint(x: linePositionX, y: startPoint.y))
            path.addLine(to: CGPoint(x: linePositionX, y: startPoint.y + chordHeight))
        }
        
        for idx in 1..<5 {
            let linePositionY = startPoint.y + stringWidth * CGFloat(idx)
            path.move(to: CGPoint(x: startPoint.x ,y: linePositionY))
            path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: linePositionY))
        }
        path.lineWidth = chordWidth * GuitarChordViewConstants.thinThicknessProportion
        path.stroke()
        
        var openChordCounter = openChord.map { $0.lineNumber }
        for tone in chord {
            let line = tone.lineNumber!-1
            let fret = tone.distance(from: openChord[5-line])-1
            if fret > -1 {
                path.append(createDot(CGRect(x: dotStartPoint.x + CGFloat(fret) * fretWidth, y: dotStartPoint.y + CGFloat(line)*stringWidth, width: dotRadius*2, height: dotRadius*2),
                                      isBase: tone.isBase))
            } else {
                path.append(createCircle(CGRect(x: smallDotStartPoint.x - fretWidth*0.8, y: smallDotStartPoint.y + CGFloat(line)*stringWidth, width: smallDotRadius*2, height: smallDotRadius*2),
                                      isBase: tone.isBase))
            }
            openChordCounter = openChordCounter.filter { $0 != tone.lineNumber }
        }
        for muted in openChordCounter {
            let line = muted! - 1
            path.append(createX(CGRect(x: smallDotStartPoint.x - fretWidth*0.8, y: smallDotStartPoint.y + CGFloat(line)*stringWidth, width: smallDotRadius*2, height: smallDotRadius*2)))
        }
    }
    
    func createDot(_ rect: CGRect, isBase: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setFill()
        if isBase {
            #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1).setFill()
        }
        path.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: CGFloat.zero, endAngle: CGFloat.pi*2, clockwise: false)
        path.fill()
        return path
    }
    
    func createCircle(_ rect: CGRect, isBase: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setStroke()
        if isBase {
            #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1).setStroke()
        }
        path.lineWidth = GuitarChordViewConstants.smallDotLineWidthProportion * rect.width
        path.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: CGFloat.zero, endAngle: CGFloat.pi*2, clockwise: false)
        path.stroke()
        return path
    }
    
    func createX(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setStroke()
        path.lineWidth = GuitarChordViewConstants.smallDotLineWidthProportion * rect.width
        path.lineCapStyle = .butt
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.stroke()
        return path
    }
}

extension GuitarChordView {
    struct GuitarChordViewConstants {
        static let widthPropotion: CGFloat = 0.8
        static let heightProportion: CGFloat = 0.6
        static let thickThicknessProportion: CGFloat = 0.02
        static let thinThicknessProportion: CGFloat = 0.005
        static let dotRadiusProportion: CGFloat = 0.3
        static let smallDotRadiusProportion: CGFloat = 0.2
        static let smallDotLineWidthProportion: CGFloat = 0.1
    }
}
