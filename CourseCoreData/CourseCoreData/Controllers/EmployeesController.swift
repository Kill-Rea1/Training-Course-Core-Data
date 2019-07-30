//
//  EmployeesController.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 30/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController {
    fileprivate let cellId = "employeeCell"
    public var company: Company! {
        didSet {
            navigationItem.title = company.name
        }
    }
    
    fileprivate var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        fetchEmployees()
    }
    
    fileprivate func fetchEmployees() {
        guard let employees = company.employees?.allObjects as? [Employee] else { return }
        self.employees = employees
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//        do {
//            let employees = try context.fetch(request)
//            self.employees = employees
//            tableView.reloadData()
//        } catch let fetchError {
//            print("Failed to fetch employees:", fetchError)
//        }
    }
    
    @objc fileprivate func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true)
    }
    
    // MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        if let company = employee.company?.name {
            cell.textLabel?.text = "\(employee.name ?? "")            \(company)"
        }
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        return cell
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    func saveEmployee(employee: Employee) {
        employees.append(employee)
        let indexPath = IndexPath(row: employees.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
