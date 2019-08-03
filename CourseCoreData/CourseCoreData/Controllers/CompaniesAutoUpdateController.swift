//
//  CompaniesAutoUpdateController.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 03/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    // warning: this code here is going to be a bit of monster
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let fetchError {
            print("Failed to fecth:", fetchError)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        navigationItem.title = "Company Auto Updates"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        ]
        
        fetchedResultsController.fetchedObjects?.forEach({ (company) in
            print(company.name ?? "")
        })
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc fileprivate func handleDelete() {
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS %@", "B")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let companiesWithB = try? context.fetch(request)
        companiesWithB?.forEach({ (company) in
            context.delete(company)
        })
        try? context.save()
        
    }
    
    @objc fileprivate func handleAdd() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = Company(context: context)
        company.name = "ZZZ"
        do {
            try context.save()
        } catch let addError {
            print("Failed to add BMW:", addError)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = HeaderLabel()
        label.text = fetchedResultsController.sectionIndexTitles[section]
        label.backgroundColor = .lightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        let company = fetchedResultsController.object(at: indexPath)
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension CompaniesAutoUpdateController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    // Methods of AutoUpdateUI 
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
