//
//  ChordAnalyzer.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/03.
//

import Foundation

struct ChordAnalyzer {
    let toneHeightDict: [String:Int] =
        ["C":0, "C#":1, "Db":1, "D":2, "D#":3, "Eb":3, "E":4, "F":5, "F#":6, "Gb":6, "G":7, "G#":8, "Ab":8, "A":9, "A#":10, "Bb":10, "B":11]
    let chordStructureDict: [String:[Int]] =
        [
            ""      :   [4, 7, 12],
            "m"     :   [3, 7, 12],
            "dim"   :   [3, 6, 12],
            "aug"   :   [4, 8, 12],
            "sus4"  :   [5, 7, 12],
            
            "maj7"  :   [4, 7, 11],
            "Maj7"  :   [4, 7, 11],
            "Δ7"    :   [4, 7, 11],
            "Ma7"   :   [4, 7, 11],
            "M7"    :   [4, 7, 11],
            
            "-7"    :   [3, 7, 10],
            "min7"  :   [3, 7, 10],
            "m7"    :   [3, 7, 10],
            "mi7"   :   [3, 7, 10],
            
            "-7b5"  :   [3, 6, 10],
            "min7b5":   [3, 6, 10],
            "m7b5"  :   [3, 6, 10],
            
            "7"     :   [4, 7, 10],
            
            "dim7"  :   [3, 6, 9],
            "o7"    :   [3, 6, 9],
            
            "aug7"  :   [4, 8, 10],
            "+7"    :   [4, 8, 10],
            "7#5"   :   [4, 8, 10],
            
            "7b5"   :   [4, 6, 10],
            "7alt"  :   [4, 6, 10],
            
            "+maj7" :   [4, 8, 11],
            "maj7#5":   [4, 8, 11],
            "maj7+5":   [4, 8, 11],
            
            "-maj7" :   [3, 7, 11],
            "minmaj7":  [3, 7, 11],
            "mmaj7" :   [3, 7, 11],
            "mM7"   :   [3, 7, 11],
            
            "7sus4" :   [5, 7, 10],
            
            "6"     :   [4, 7, 9],
            
            "-6"    :   [3, 7, 9],
            "min6"  :   [3, 7, 9],
            "m6"    :   [3, 7, 9]
        ]
    
    func analyze(chordString: String, toneHeight: Int) -> [Pitch]? {
        var chord = [Pitch]()
        var chordSeparatorStartIndex = chordString.index(chordString.startIndex, offsetBy: 1)
        var base = String(chordString[chordString.startIndex])
        
        if toneHeightDict[base] == nil {
            print("Wrong Chord Name!")
            return nil
        }
        if chordString.count >= 2 {
            let flatOrSharp = String(chordString[chordString.index(chordString.startIndex, offsetBy: 1)])
            if flatOrSharp == "b" || flatOrSharp == "#" {
                base.append(flatOrSharp)
                chordSeparatorStartIndex = chordString.index(chordString.startIndex, offsetBy: 2)
            }
        }
        let basePitch = Pitch(toneName: base, toneHeight: toneHeight)
        if let slashChordIdx = chordString.firstIndex(of: "/") {
            let identifier = String(chordString[chordSeparatorStartIndex..<slashChordIdx])
            let newBase = String(chordString[chordString.index(slashChordIdx, offsetBy: 1)..<chordString.endIndex])
            let newBasePitches = [Pitch(toneName: newBase, toneHeight: toneHeight), Pitch(toneName: newBase, toneHeight: toneHeight-1),  Pitch(toneName: newBase, toneHeight: toneHeight+1)]
            var interval = 90000
            var index = 0
            for (idx, tone) in newBasePitches.enumerated() {
                if tone.distance(from: basePitch) < interval {
                    interval = tone.distance(from: basePitch)
                    index = idx
                }
            }
            chord.append(newBasePitches[index])
            if let intervals = chordStructureDict[identifier] {
                for interval in intervals {
                    chord.append(Pitch(toneName: base, toneHeight: toneHeight, distanceFromBase: interval))
                }
            }
        } else {
            let identifier = String(chordString[chordSeparatorStartIndex..<chordString.endIndex])
            chord.append(basePitch)
            if let intervals = chordStructureDict[identifier] {
                for interval in intervals {
                    chord.append(Pitch(toneName: base, toneHeight: toneHeight, distanceFromBase: interval))
                }
            }
        }
        return chord
    }
}


struct Pitch : Comparable, CustomStringConvertible {
    
    var toneName: String
    var toneHeight: Int
    let distanceFromBase: Int = 0
    var description: String {
        return "\(toneName)\(toneHeight)"
    }
    static let toneHeightDict: [String:Int] = ["C":0, "C#":1, "Db":1, "D":2, "D#":3, "Eb":3, "E":4, "F":5, "F#":6, "Gb":6, "G":7, "G#":8, "Ab":8, "A":9, "A#":10, "Bb":10, "B":11]
    static let heightToneDict: [Int:String] = [0:"C", 1:"C#", 2:"D", 3:"D#", 4:"E", 5:"F", 6:"F#", 7:"G", 8:"G#", 9:"A", 10:"A#", 11:"B"]
    
    init(toneName: String, toneHeight: Int) {
        self.toneName = toneName
        self.toneHeight = toneHeight
    }
    
    init(toneName: String, toneHeight: Int, distanceFromBase: Int) {
        let nameToNum = Pitch.toneHeightDict[toneName] ?? 0
        let newToneHeight = toneHeight + (nameToNum + distanceFromBase)/12
        let newToneName = Pitch.heightToneDict[(nameToNum + distanceFromBase)%12] ?? "C"
        self.toneName = newToneName
        self.toneHeight = newToneHeight
    }
    
    static func < (lhs: Pitch, rhs: Pitch) -> Bool {
        if lhs.toneHeight < rhs.toneHeight {
            return true
        } else if lhs.toneHeight > rhs.toneHeight {
            return false
        } else {
            return toneHeightDict[lhs.toneName]! < toneHeightDict[rhs.toneName]!
        }
    }
    
    func distance(from compare: Pitch) -> Int {
        let difference = Pitch.toneHeightDict[self.toneName]! - Pitch.toneHeightDict[compare.toneName]!
        if self.toneHeight == compare.toneHeight {
            return abs(difference)
        } else {
            return abs((self.toneHeight - compare.toneHeight)*12 + difference)
        }
    }
}


extension String {
    func getFirstIndex(of char: Character) -> String.Index? {
        for (idx, character) in self.enumerated() {
            if character == char {
                return self.index(self.startIndex, offsetBy: idx)
            }
        }
        return nil
    }
}
