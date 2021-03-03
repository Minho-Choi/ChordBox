//
//  GuitarChordView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/03.
//

import UIKit

class GuitarChordView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.CustomPalette.backgroundColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }

    var openChord: [Pitch] = []
    var chord: Chord = Chord(pitches: [], structure: "", chordRoot: "", chordType: "")

    override func draw(_ rect: CGRect) {
        let chordWidth = rect.width * GuitarChordViewConstants.widthPropotion
        let fretWidth = chordWidth / 4
        let chordHeight = rect.height * GuitarChordViewConstants.heightProportion
        let stringWidth = chordHeight / 5
        let startPoint = CGPoint(x: 3*(rect.width - chordWidth)/4, y: (rect.height - chordHeight)/3)
        let dotRadius = stringWidth * GuitarChordViewConstants.dotRadiusProportion
        let smallDotRadius = stringWidth * GuitarChordViewConstants.smallDotRadiusProportion
        let dotStartPoint = CGPoint(x: startPoint.x + fretWidth/2-dotRadius, y: startPoint.y - dotRadius)
        let smallDotStartPoint = CGPoint(x: startPoint.x + fretWidth/2-smallDotRadius, y: startPoint.y - smallDotRadius)
        let path = UIBezierPath()
        UIColor.CustomPalette.chordColor.setStroke()

        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + chordHeight))
        path.lineWidth = chordWidth * GuitarChordViewConstants.thickThicknessProportion
        path.lineJoinStyle = .miter
        path.lineCapStyle = .square
        path.stroke()

        path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: startPoint.y + chordHeight))
        path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: startPoint.y))
        path.close()

        // inner line
        for idx in 1..<4 {
            let linePositionX = startPoint.x + fretWidth*CGFloat(idx)
            path.move(to: CGPoint(x: linePositionX, y: startPoint.y))
            path.addLine(to: CGPoint(x: linePositionX, y: startPoint.y + chordHeight))
        }

        for idx in 1..<5 {
            let linePositionY = startPoint.y + stringWidth * CGFloat(idx)
            path.move(to: CGPoint(x: startPoint.x, y: linePositionY))
            path.addLine(to: CGPoint(x: startPoint.x + chordWidth, y: linePositionY))
        }
        path.lineWidth = chordWidth * GuitarChordViewConstants.thinThicknessProportion
        path.stroke()

        // finger positions and numbers
        var openChordCounter = openChord.map { $0.lineNumber }
        for tone in chord.pitches {
            let line = tone.lineNumber-1
//            print(chord.nonZeroMinFret, chord.minFret)
            var fret = tone.fretNumber
            if chord.maxFret > 4 {
                fret -= (chord.nonZeroMinFret - 1)
            }
//            print(fret)
            if fret >= 1 {
                path.append(createDot(CGRect(x: dotStartPoint.x + CGFloat(fret-1) * fretWidth, y: dotStartPoint.y + CGFloat(line)*stringWidth, width: dotRadius*2, height: dotRadius*2),
                                      isBase: tone.isBase))
                let string = "\(tone.fingerNumber)"
                let stringToDraw = NSMutableAttributedString(string: string)
                stringToDraw.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: GuitarChordViewConstants.fontSizeProportion * frame.height), range: (string as NSString).range(of: string))
                stringToDraw.addAttribute(.foregroundColor, value: UIColor.CustomPalette.backgroundColor, range: (string as NSString).range(of: string))
                let rectToDraw = CGRect(x: dotStartPoint.x + CGFloat(fret-1) * fretWidth + fretWidth * 0.15, y: dotStartPoint.y + CGFloat(line)*stringWidth + stringWidth * 0.05, width: dotRadius*2, height: dotRadius*2)
                stringToDraw.draw(in: rectToDraw)
            } else {
                path.append(createCircle(CGRect(x: smallDotStartPoint.x - fretWidth*0.8, y: smallDotStartPoint.y + CGFloat(line)*stringWidth, width: smallDotRadius*2, height: smallDotRadius*2),
                                      isBase: tone.isBase))
            }
            openChordCounter = openChordCounter.filter { $0 != tone.lineNumber }
        }
        for muted in openChordCounter {
            let line = muted - 1
            path.append(createX(CGRect(x: smallDotStartPoint.x - fretWidth*0.8, y: smallDotStartPoint.y + CGFloat(line)*stringWidth, width: smallDotRadius*2, height: smallDotRadius*2)))
        }
//        print(chord.maxFret)
        // fret number
        if chord.maxFret > 4 {
            let fretNum = "\(chord.nonZeroMinFret)"
            let attributedFretNum = NSMutableAttributedString(string: fretNum)
            attributedFretNum.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: GuitarChordViewConstants.fontSizeProportion * frame.height), range: (fretNum as NSString).range(of: fretNum))
            attributedFretNum.addAttribute(.foregroundColor, value: UIColor.CustomPalette.textColor, range: (fretNum as NSString).range(of: fretNum))
            let rectToDraw = CGRect(x: startPoint.x + fretWidth/3, y: startPoint.y + 5.5*stringWidth, width: fretWidth, height: stringWidth)
            attributedFretNum.draw(in: rectToDraw)
        }
    }

    private func createDot(_ rect: CGRect, isBase: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        UIColor.CustomPalette.chordColor.setFill()
        if isBase {
            UIColor.CustomPalette.pointColor.setFill()
        }
        path.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: CGFloat.zero, endAngle: CGFloat.pi*2, clockwise: false)
        path.fill()
        return path
    }

    private func createCircle(_ rect: CGRect, isBase: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        UIColor.CustomPalette.chordColor.setStroke()
        if isBase {
            UIColor.CustomPalette.pointColor.setStroke()
        }
        path.lineWidth = GuitarChordViewConstants.smallDotLineWidthProportion * rect.width
        path.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: CGFloat.zero, endAngle: CGFloat.pi*2, clockwise: false)
        path.stroke()
        return path
    }

    private func createX(_ rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        UIColor.CustomPalette.chordColor.setStroke()
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

        static let heightProportion: CGFloat = 0.7

        static let thickThicknessProportion: CGFloat = 0.02

        static let thinThicknessProportion: CGFloat = 0.005

        static let dotRadiusProportion: CGFloat = 0.4

        static let smallDotRadiusProportion: CGFloat = 0.3

        static let smallDotLineWidthProportion: CGFloat = 0.1

        static let fontSizeProportion: CGFloat = 0.07
    }
}
