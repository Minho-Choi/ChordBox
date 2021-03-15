//
//  String+Localized.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/03/15.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localized", value: self, comment: "")
    }
}
