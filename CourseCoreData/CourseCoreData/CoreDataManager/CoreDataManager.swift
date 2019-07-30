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
    
    func fetchCompanies() -> [Company] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchError {
            print("Failed to fetch companies:", fetchError)
            return []
        }
    }
    
    func saveCompany(_ company: Company, completion: @escaping (Error?) -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            try context.save()
            completion(nil)
        } catch let updateError {
            print("Failed to update company:", updateError)
            completion(updateError)
        }
    }
    
    func deleteCompanies(_ companies: [Company]) -> [IndexPath] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            var indexPaths = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPaths.append(indexPath)
            }
            return indexPaths
        } catch let deleteError {
            print("Failed to delete all companies:", deleteError)
            return []
        }
    }
    
    func saveEmployee(_ employeeName: String, company: Company, completion: @escaping (Error?, Employee?) -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.setValue(employeeName, forKey: "name")
        employee.company = company
        do {
            try context.save()
            completion(nil, employee)
        } catch let saveError {
            print("Failed to save employee:", saveError)
            completion(saveError, nil)
        }
    }
}
