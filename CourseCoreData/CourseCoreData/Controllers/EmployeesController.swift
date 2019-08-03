//
//  EmployeesController.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 30/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let customRect = rect.inset(by: .init(top: 0, left: 16, bottom: 0, right: 0))
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController {
    fileprivate let cellId = "employeeCell"
    public var company: Company! {
        didSet {
            navigationItem.title = company.name
        }
    }
    
    fileprivate var allEmployees = [[Employee]]()
    fileprivate let employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        fetchEmployees()
    }
    
    fileprivate func fetchEmployees() {
        allEmployees = []
        guard let employees = company.employees?.allObjects as? [Employee] else { return }
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                employees.filter {$0.type == employeeType}
            )
        }
    }
    
    @objc fileprivate func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true)
    }
    
    // MARK:- UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = HeaderLabel()
        label.text = employeeTypes[section]
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = allEmployees[indexPath.section][indexPath.row]
        cell.textLabel?.text = employee.name
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "")    \(dateFormatter.string(from: birthday))"
        }
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        return cell
    }
}

extension EmployeesController: CreateEmployeeControllerDelegate {
    func saveEmployee(employee: Employee) {
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let indexPath = IndexPath(row: row, section: section)
        
        allEmployees[section].append(employee)
        tableView.insertRows(at: [indexPath], with: .middle)
    }
}
