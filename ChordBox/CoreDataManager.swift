//
//  CoreDataManager.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/09.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared : CoreDataManager = CoreDataManager()
    
    let appDelegate : AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "ChordForm"
    
    func getChords(base: String, type: String, ascending: Bool = false) -> [ChordForm] {
        var models = [ChordForm]()
        
        if let context = context {
            let idSort: NSSortDescriptor = NSSortDescriptor(key: "root", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [idSort]
            fetchRequest.predicate = NSPredicate(format: "root == %@ AND type == %@", base, type)
            
            do {
                if let fetchResult: [ChordForm] = try context.fetch(fetchRequest) as? [ChordForm] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Fetch error: \(error.userInfo)")
            }
        }
        return models
    }
    
    func saveChord(id: UUID, root: String, type: String, structure: String, fingerPositions: String, noteNames: String, onSuccess: @escaping((Bool) -> Void)) {
        if let context = context, let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            if let chordform: ChordForm = NSManagedObject(entity: entity, insertInto: context) as? ChordForm {
                chordform.id = id
                chordform.root = root
                chordform.type = type
                chordform.structure = structure
                chordform.fingerPositions = fingerPositions
                chordform.noteNames = noteNames
                
                contextSave { success in
                    onSuccess(success)
                }
            }
        }
    }
}

extension CoreDataManager {
    fileprivate func contextSave(onSuccess: ((Bool)-> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Save error: \(error.userInfo)")
            onSuccess(false)
        }
    }
}
