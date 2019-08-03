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
    
    fileprivate let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.widthContraint(to: 100)
        return label
    }()
    
    fileprivate let birthdayTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "MM/DD/YYYY"
        tf.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return tf
    }()
    
    fileprivate lazy var birthdayStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [birthdayLabel, birthdayTextField])
        return sv
    }()
    
    fileprivate let employeeTypeSegmentedControl: UISegmentedControl = {
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManagement.rawValue,
            EmployeeType.Staff.rawValue
        ]
        
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.darkBlue
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Create Employee"
        setupCreatControllersButtons(cancel: #selector(handleCancel), save: #selector(handleSave))
        setupViews()
    }
    
    fileprivate func setupViews() {
        _ = setupLightBlueBackground(height: 150)
        view.addSubview(nameStackView)
        nameStackView.addConstraints(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        view.addSubview(birthdayStack)
        birthdayStack.addConstraints(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: nameStackView.bottomAnchor, bottom: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        view.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.addConstraints(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: birthdayStack.bottomAnchor, bottom: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 34))
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    fileprivate func showError(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc fileprivate func handleSave() {
        view.endEditing(true)
        guard let name = nameTextField.text else { return }
        guard let birthday = birthdayTextField.text, birthday != "" else {
            showError(title: "Blank Birthday", message: "You have not entered a birthday.")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthday) else {
            showError(title: "Bad Date", message: "Birthday date entered not valid.")
            return
        }
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        CoreDataManager.shared.saveEmployee(name, birthday: birthdayDate, employeeType: employeeType, company: company) { [weak self] (error, employee) in
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
