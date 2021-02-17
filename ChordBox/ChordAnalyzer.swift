//
//  ChordAnalyzer.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/03.
//

import Foundation

struct ChordAnalyzer {
    var chordRecommendationPreference: ChordRecommendPreferenceOption = .adjacent
    static let toneHeightDict: [String:Int] =
        ["B#": 0, "C":0, "C#":1, "Db":1, "D":2, "D#":3, "Eb":3, "E":4, "Fb":4, "E#":5, "F":5, "F#":6, "Gb":6, "G":7, "G#":8, "Ab":8, "A":9, "A#":10, "Bb":10, "B":11, "Cb":11]
    static let heightToneDict: [Int:String] = [0:"C", 1:"C#", 2:"D", 3:"D#", 4:"E", 5:"F", 6:"F#", 7:"G", 8:"G#", 9:"A", 10:"A#", 11:"B"]
    
    var currentTuning = [
        Pitch(toneName: "E", lineNumber: 6, fingerNumber: 0, fretNumber: 0),
        Pitch(toneName: "A", lineNumber: 5, fingerNumber: 0, fretNumber: 0),
        Pitch(toneName: "D", lineNumber: 4, fingerNumber: 0, fretNumber: 0),
        Pitch(toneName: "G", lineNumber: 3, fingerNumber: 0, fretNumber: 0),
        Pitch(toneName: "B", lineNumber: 2, fingerNumber: 0, fretNumber: 0),
        Pitch(toneName: "E", lineNumber: 1, fingerNumber: 0, fretNumber: 0)
    ]
    
    var previousChordFret: Int = 0
    
    mutating func analyze(chordString: String, toneHeight: Int) -> [Chord]? {
        var availableChords = [Chord]()
        if chordString.isEmpty {
            return nil
        }
        var chordSeparatorStartIndex = chordString.index(chordString.startIndex, offsetBy: 1)
        var base = String(chordString[chordString.startIndex])
        var newBase : String? = nil
        var identifier = "maj"
        
        if ChordAnalyzer.toneHeightDict[base] == nil {
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

        if let slashChordIdx = chordString.firstIndex(of: "/") {
            let newIdentifier = String(chordString[chordSeparatorStartIndex..<slashChordIdx])
            if newIdentifier != "" { identifier = newIdentifier }
            newBase = String(chordString[chordString.index(slashChordIdx, offsetBy: 1)..<chordString.endIndex])
        } else {
            let newIdentifier = String(chordString[chordSeparatorStartIndex..<chordString.endIndex])
            if newIdentifier != "" { identifier = newIdentifier }

        }
        let chordData = CoreDataManager.shared.getChords(base: base, type: identifier, ascending: true)
        
        for chordInfo in chordData {
            var chord = Chord(pitches: [], structure: chordInfo.structure!, chordRoot: chordInfo.root!, chordType: chordInfo.type!)
            if let fingerPositions = chordInfo.fingerPositions?.split(separator: ","),
               let noteNames = chordInfo.noteNames?.split(separator: ",") {
                var stringIndex = 0
                for (index, finger) in fingerPositions.enumerated() {
                    if finger != "x" {
                        let fretNumber = calculateFretNumber(lineNumber: 6-index, toneName: String(noteNames[stringIndex]))
                        chord.pitches.append(Pitch(
                                                toneName: String(noteNames[stringIndex]),
                                                lineNumber: 6-index,
                                                fingerNumber: Int(finger)!,
                                                fretNumber: fretNumber)
                        )
                        stringIndex += 1
                    }
                    
                }
            }
            availableChords.append(chord)
        }
        var chordsToReturn: [Chord]
        if availableChords.isEmpty {
            return nil
        }
        if availableChords.count > 5 {
            availableChords = availableChords.filter { $0.maxFret - $0.nonZeroMinFret <= 3 }
        }
        if identifier != "5" {
            availableChords = availableChords.filter { $0.pitches.count >= 4}
        }
        switch chordRecommendationPreference {
        case .open: do {
            chordsToReturn = availableChords.sorted(by: { $0.nonZeroMinFret < $1.nonZeroMinFret })
            previousChordFret = chordsToReturn.first?.minFret ?? 0
            break
        }
        case .adjacent: do {
            chordsToReturn = availableChords.sorted(by: { abs($0.nonZeroMinFret-previousChordFret) < abs($1.nonZeroMinFret-previousChordFret)})
            previousChordFret = chordsToReturn.first?.nonZeroMinFret ?? 0
            
            break
        }
        case .wide: do {
            chordsToReturn = availableChords.sorted(by: { $0.wideness > $1.wideness})
            previousChordFret = chordsToReturn.first?.nonZeroMinFret ?? 0
            break
        }
        }
        for (idx, chordToReturn) in chordsToReturn.enumerated() {
            if newBase != nil {
                let index = chordToReturn.baseIndex
                let baseToRemove = chordToReturn.pitches[index]
                chordsToReturn[idx].pitches.remove(at: index)
                if let baseToAppend = findNewBase(
                    finger: baseToRemove.fingerNumber,
                    minFret: chordToReturn.minFret,
                    newTone: newBase!,
                    availableStrings: chordToReturn.unusedStrings
                ) {
                    chordsToReturn[idx].pitches.insert(baseToAppend, at: index)
                }
            } else {
                if chordToReturn.baseIndex >= 0 {
                    chordsToReturn[idx].pitches[chordToReturn.baseIndex].isBase = true
                }
            }
        }
        return chordsToReturn
    }
    
    func calculateFretNumber(lineNumber: Int, toneName: String) -> Int {
        var openTone = currentTuning[6-lineNumber]
        let toneName2 = ChordAnalyzer.heightToneDict[ChordAnalyzer.analyzeToneName(toneName: toneName)]
        while openTone.toneName != toneName && openTone.toneName != toneName2{
            openTone = openTone.detune(by: 1)
            if openTone.fretNumber > 24 {
                print("fret number calculation error in \(toneName)")
                break
            }
        }
        return openTone.fretNumber
    }
    
    static func analyzeToneName(toneName: String) -> Int {
        if toneName.contains("bb") {
            return (ChordAnalyzer.toneHeightDict[String(toneName.dropLast())]! - 1)%12
        } else if toneName.contains("##") {
            return (ChordAnalyzer.toneHeightDict[String(toneName.dropLast())]! + 1)%12
        } else {
            return ChordAnalyzer.toneHeightDict[toneName]!
        }
    }
    func findNewBase(finger: Int, minFret: Int, newTone: String, availableStrings: [Int]) -> Pitch? {
        var candidate = [Pitch]()
        for string in availableStrings {
            let fretNumber = calculateFretNumber(lineNumber: string, toneName: newTone)
            candidate.append(
                Pitch(
                    toneName: newTone,
                    lineNumber: string,
                    fingerNumber: 0,
                    fretNumber: fretNumber,
                    isBase: true
            ))
        }
        return candidate.first ?? nil
    }
}


struct Pitch : Comparable, CustomStringConvertible, Hashable {
    
    static let toneHeightDict: [String:Int] = ["C":0, "C#":1, "Db":1, "D":2, "D#":3, "Eb":3, "E":4, "F":5, "F#":6, "Gb":6, "G":7, "G#":8, "Ab":8, "A":9, "A#":10, "Bb":10, "B":11]
    static let heightToneDict: [Int:String] = [0:"C", 1:"C#", 2:"D", 3:"D#", 4:"E", 5:"F", 6:"F#", 7:"G", 8:"G#", 9:"A", 10:"A#", 11:"B"]
    
    var toneName: String
    var lineNumber: Int
    var fingerNumber: Int
    var fretNumber: Int
    var isBase: Bool = false
    var description: String {
        return "\(toneName) in line \(lineNumber), fret \(fretNumber)\n"
    }
    var toneHeight: Int {
        switch self.lineNumber {
        case 1: do {
            if fretNumber >= 20 { return 6 }
            else if fretNumber >= 8 { return 5 }
            else { return 4 }
        }
        case 2: do {
            if fretNumber >= 13 { return 5 }
            else if fretNumber >= 1 { return 4 }
            else { return 3 }
        }
        case 3: do {
            if fretNumber >= 17 { return 5 }
            else if fretNumber >= 5 { return 4 }
            else { return 3 }
        }
        case 4: do {
            if fretNumber >= 22 { return 5 }
            else if fretNumber >= 10 { return 4 }
            else { return 3 }
        }
        case 5: do {
            if fretNumber >= 15 { return 4 }
            else if fretNumber >= 3 { return 3 }
            else { return 2 }
        }
        case 6: do {
            if fretNumber >= 20 { return 4 }
            else if fretNumber >= 8 { return 3 }
            else { return 2 }
        }
        default: return 0
        }
    }
    
    func detune(by pitch: Int) -> Pitch {
        let newToneName = Pitch.heightToneDict[(Pitch.toneHeightDict[self.toneName]! + pitch)%12]!
        return Pitch(toneName: newToneName, lineNumber: self.lineNumber, fingerNumber: 0, fretNumber: self.fretNumber + pitch)
    }
    
    static func < (lhs: Pitch, rhs: Pitch) -> Bool {
        if lhs.toneName == rhs.toneName {
            return lhs.lineNumber > rhs.lineNumber
        }
        else {
            return toneHeightDict[lhs.toneName]! < toneHeightDict[rhs.toneName]!
        }
    }
    
    static func == (lhs: Pitch, rhs: Pitch) -> Bool {
        return lhs.toneName == rhs.toneName && lhs.fretNumber == rhs.fretNumber && lhs.lineNumber == rhs.lineNumber
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

extension Array {
    func firstIndex(matching: Element) -> Int? where Element: Equatable{
        for (idx, elem) in self.enumerated() {
            if elem == matching {
                return idx
            }
        }
        return nil
    }
    func howManyItContains(matching: Element) -> Int where Element: Equatable {
        var count = 0
        for elem in self {
            if elem == matching {
                count += 1
            }
        }
        return count
    }
}

struct Chord {
    var pitches: [Pitch]
    var structure: String
    var chordRoot: String
    var chordType: String
    var wideness: Int {
        pitches.count
    }
    var minFret: Int {
        pitches.min(by: { $0.fretNumber < $1.fretNumber })!.fretNumber
    }
    var nonZeroMinFret: Int {
        pitches.filter{ $0.fretNumber != 0 }.min(by: { $0.fretNumber < $1.fretNumber })?.fretNumber ?? 1
    }
    var maxFret: Int {
        pitches.max(by: { $0.fretNumber < $1.fretNumber })?.fretNumber ?? 1
    }
    var baseIndex: Int {
        for (idx, pitch) in pitches.enumerated() {
//            print(pitch.toneName, self.chordRoot)
            if isEqualToneName(lhs: pitch.toneName, rhs: self.chordRoot) {
                return idx
            }
        }
        print("Base Tone Index Not Found")
        return -1
    }
    var unusedStrings: [Int] {
        var strings = [1, 2, 3, 4, 5, 6]
        for pitch in pitches {
            strings.remove(at: strings.firstIndex(matching: pitch.lineNumber)!)
        }
        return strings.sorted(by: >)
    }
    
    func isEqualToneName(lhs: String, rhs: String) -> Bool {
        let lhsNum = ChordAnalyzer.analyzeToneName(toneName: lhs)
        let rhsNum = ChordAnalyzer.analyzeToneName(toneName: rhs)
//        print(lhs, rhs, lhsNum, rhsNum)
        return lhsNum == rhsNum
    }
}

enum ChordRecommendPreferenceOption {
    case open
    case adjacent
    case wide
}
