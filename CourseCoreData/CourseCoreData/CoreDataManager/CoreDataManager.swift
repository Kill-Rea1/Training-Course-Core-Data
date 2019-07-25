//
//  CoreDataManager.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 25/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CourseCoreDataModels")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Loading to store failed:", error)
                return
            }
        }
        return container
    }()
}
