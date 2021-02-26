//
//  CGFloat+FontSize.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/26.
//

import UIKit

extension CGFloat {
    static var fontHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            return 15
        } else {
            return 30
        }
    }
    
    static var fontWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            return 10
        } else {
            return 20
        }
    }
}
