//
//  CreateEmployeeController.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 30/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

protocol CreateEmployeeControllerDelegate {
    func saveEmployee(employee: Employee)
    
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    var company: Company!
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.widthContraint(to: 100)
        return label
    }()
    
    fileprivate let nameTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        tf.placeholder = "Enter Name"
        return tf
    }()
    
    fileprivate lazy var nameStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Create Employee"
        setupCreatControllersButtons(cancel: #selector(handleCancel), save: #selector(handleSave))
        _ = setupLightBlueBackground(height: 100)
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(nameStackView)
        nameStackView.addConstraints(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {
        guard let name = nameTextField.text else { return }
        CoreDataManager.shared.saveEmployee(name, company: company) { [weak self] (error, employee) in
            if error != nil {
                return
            }
            guard let employee = employee else { return }
            self?.dismiss(animated: true, completion: {
                self?.delegate?.saveEmployee(employee: employee)
            })
        }
    }
}
