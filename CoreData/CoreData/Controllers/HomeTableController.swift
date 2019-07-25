//
//  ViewController.swift
//  CoreData
//
//  Created by Кирилл Иванов on 25/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class HomeTableController: UITableViewController {
    
    fileprivate let companyCellId = "companyCell"
    fileprivate var companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationItem()
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleResetCompanies))
    }
    
    @objc fileprivate func handleResetCompanies() {
        
    }
    
    @objc fileprivate func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true)
    }
    
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: companyCellId)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
    }
    
    // MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightBlue
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile2"))
        imageView.widthContraint(to: 26)
        let label = UILabel()
        label.text = "Names"
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        headerView.addSubview(stackView)
        stackView.spacing = 16
        stackView.fillSuperview(padding: .init(top: 12, left: 16, bottom: 12, right: 16))
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: companyCellId, for: indexPath)
        let company = companies[indexPath.row]
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.textLabel?.text = company.name
        return cell
    }
}

extension HomeTableController: CreateCompanyControllerDelegate {
    func addNewCompany(company: Company) {
        companies.append(company)
        let indexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
