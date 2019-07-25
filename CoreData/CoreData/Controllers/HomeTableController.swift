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
        imageView.widthContraint(to: 50)
        let label = UILabel()
        label.text = "Name"
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        headerView.addSubview(stackView)
        stackView.fillSuperview()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: companyCellId, for: indexPath)
        cell.backgroundColor = .tealColor
        return cell
    }
}
