//
//  HomeTableController+Delegate.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 26/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CreateCompanyControllerDelegate {
    func addNewCompany(company: Company)
    func updateCompany(company: Company)
}

extension HomeTableController: CreateCompanyControllerDelegate {
    func addNewCompany(company: Company) {
        companies.append(company)
        let indexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func updateCompany(company: Company) {
        guard let index = companies.firstIndex(of: company) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
}
