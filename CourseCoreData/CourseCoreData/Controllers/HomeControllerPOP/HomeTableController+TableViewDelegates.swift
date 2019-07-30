//
//  HomeTableController+TableViewDelegates.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 26/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

extension HomeTableController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesController = EmployeesController()
        employeesController.company = companies[indexPath.row]
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "No companies available\n\n\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        attributedString.append(NSMutableAttributedString(string: "Please create some companies by using the Add \nbutton near the top", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
        label.numberOfLines = 0
        label.attributedText = attributedString
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.isEmpty ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandlerAction)
        deleteAction.backgroundColor = .lightRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerAction)
        editAction.backgroundColor = .darkBlue
        return [deleteAction, editAction]
    }
    
    fileprivate func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) {
        let company = self.companies[indexPath.row]
        self.companies.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(company)
        do {
            try context.save()
        } catch let saveError {
            print("Failed to save deleting:", saveError)
        }
    }
    
    fileprivate func editHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) {
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: companyCellId, for: indexPath) as! CompanyCell
        let company = companies[indexPath.row]
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
