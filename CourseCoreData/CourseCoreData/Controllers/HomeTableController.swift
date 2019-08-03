//
//  ViewController.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 25/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

class HomeTableController: UITableViewController {

    public let companyCellId = "companyCell"
    public var companies = [Company]()
    public let headerView: UIView = {
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
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationItem()
        fetchCompanies()
    }
    
    fileprivate func fetchCompanies() {
        companies = CoreDataManager.shared.fetchCompanies()
        tableView.reloadData()
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Companies"
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleResetCompanies)),
            UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(handleDoWork))
        ]
    }
    
    @objc fileprivate func handleDoWork() {
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            (0...20000).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            do {
                try backgroundContext.save()
            } catch let error {
                print("Failed to save:", error)
            }
        }
        
        // GCD
        DispatchQueue.global(qos: .background).async {
            // creating some Company
//            let context = CoreDataManager.shared.persistentContainer.viewContext
            
        }
    }
    
    @objc fileprivate func handleResetCompanies() {
        let indexPaths = CoreDataManager.shared.deleteCompanies(companies)
        companies.removeAll()
        tableView.deleteRows(at: indexPaths, with: .left)
    }
    
    @objc fileprivate func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        present(navController, animated: true)
    }
    
    fileprivate func setupTableView() {
        tableView.register(CompanyCell.self, forCellReuseIdentifier: companyCellId)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
    }
}
