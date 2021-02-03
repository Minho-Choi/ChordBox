//
//  GuitarChordView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/03.
//

import UIKit

@IBDesignable
class GuitarChordView: UIView {
    
    override func draw(_ rect: CGRect) {
        let chordWidth = rect.width * GuitarChordViewConstants.widthPropotion
        let lineWidth = chordWidth / 5
        let chordHeight = rect.height * GuitarChordViewConstants.heightProportion
        let fretHeight = chordHeight / 4
        let startPoint = CGPoint(x: (rect.width - chordWidth)/2, y: (rect.height - chordHeight)/2)
        let path = UIBezierPath()
        #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setStroke()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: startPoint.y))
        path.lineWidth = chordWidth * GuitarChordViewConstants.thickThickness
        path.lineJoinStyle = .miter
        path.lineCapStyle = .square
        path.stroke()

        path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: startPoint.y + chordHeight))
        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + chordHeight))
        path.close()
        
        
        for idx in 1..<5 {
            let linePositionX = startPoint.x + lineWidth*CGFloat(idx)
            path.move(to: CGPoint(x: linePositionX, y: startPoint.y))
            path.addLine(to: CGPoint(x: linePositionX, y: startPoint.y + chordHeight))
        }
        
        for idx in 1..<4 {
            let linePositionY = startPoint.y + fretHeight * CGFloat(idx)
            path.move(to: CGPoint(x: startPoint.x ,y: linePositionY))
            path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: linePositionY))
        }
        path.lineWidth = chordWidth * GuitarChordViewConstants.thinThickness
        path.stroke()
    }
}

extension GuitarChordView {
    struct GuitarChordViewConstants {
        static let widthPropotion: CGFloat = 0.8
        static let heightProportion: CGFloat = 0.8
        static let thickThickness: CGFloat = 0.02
        static let thinThickness: CGFloat = 0.005
    }
}
