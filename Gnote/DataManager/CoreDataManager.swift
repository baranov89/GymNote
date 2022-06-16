//
//  CoreDataManager.swift
//  Gnote
//
//  Created by alex on 06.04.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    var contaner: NSPersistentContainer
    var context: NSManagedObjectContext
    
    init() {
        contaner = NSPersistentContainer(name: "DataBase")
        contaner.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
        context = contaner.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Filed to save MusclGroup \(error.localizedDescription)")
        }
    }
    
    func clearDatabase() {
        let storeContainer = contaner.persistentStoreCoordinator
        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(at: store.url!, ofType: store.type, options: nil)
            } catch let error {
                print("Filed deleted story \(error.localizedDescription)")
            }
        }
        contaner = NSPersistentContainer(name: "DataBase")
        contaner.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
        context = contaner.viewContext
    }
}
