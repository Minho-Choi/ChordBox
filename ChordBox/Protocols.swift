//
//  Protocols.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/11.
//

import Foundation

// protocol used in calling view animation sync to metronome beat
protocol AnimateViewControllerFromViewDelegate: AnyObject {
    func animateView()
}
