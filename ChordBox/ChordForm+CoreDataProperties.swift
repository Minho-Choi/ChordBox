//
//  ChordForm+CoreDataProperties.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/09.
//
//

import Foundation
import CoreData


extension ChordForm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChordForm> {
        return NSFetchRequest<ChordForm>(entityName: "ChordForm")
    }

    @NSManaged public var root: String?
    @NSManaged public var type: String?
    @NSManaged public var structure: String?
    @NSManaged public var fingerPositions: String?
    @NSManaged public var noteNames: String?
    @NSManaged public var id: UUID?

}

extension ChordForm : Identifiable {

}
