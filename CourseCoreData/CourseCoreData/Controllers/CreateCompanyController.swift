//
//  CreateCompanyController.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 25/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func addNewCompany(company: Company)
    func updateCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    public var delegate: CreateCompanyControllerDelegate?
    public var company: Company? {
        didSet {
            nameTextField.text = company?.name
            guard let founded = company?.founded else { return }
            datePicker.date = founded
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            foundedTextField.text = dateFormatter.string(from: founded)
        }
    }
    
    fileprivate let companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Select Photo", for: .normal)
        return button
    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.widthContraint(to: 100)
        return label
    }()
    
    fileprivate let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Name"
        return tf
    }()
    
    fileprivate lazy var nameStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        return sv
    }()
    
    fileprivate let foundedLabel: UILabel = {
        let label = UILabel()
        label.text = "Founded"
        label.widthContraint(to: 100)
        return label
    }()
    
    fileprivate let foundedTextField: UITextField = {
        let tf = UITextField()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        tf.text = dateFormatter.string(from: Date())
        return tf
    }()
    
    fileprivate lazy var foundedStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [foundedLabel, foundedTextField])
        return sv
    }()
    
    fileprivate let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.addTarget(self, action: #selector(handleUpdateSelectedDate), for: .valueChanged)
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        setupNavigationItems()
        setupViews()
    }
    
    fileprivate func setupViews() {
        let backgorundView = UIView()
        backgorundView.backgroundColor = .lightBlue
        view.addSubview(backgorundView)
        backgorundView.addConstraints(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: nil, size: .init(width: 0, height: 250))
        backgorundView.addSubview(nameStackView)
        nameStackView.addConstraints(leading: backgorundView.leadingAnchor, trailing: backgorundView.trailingAnchor, top: backgorundView.topAnchor, bottom: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        backgorundView.addSubview(foundedStackView)
        foundedStackView.addConstraints(leading: backgorundView.leadingAnchor, trailing: backgorundView.trailingAnchor, top: nameStackView.bottomAnchor, bottom: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        backgorundView.addSubview(datePicker)
        datePicker.addConstraints(leading: backgorundView.leadingAnchor, trailing: backgorundView.trailingAnchor, top: foundedStackView.bottomAnchor, bottom: backgorundView.bottomAnchor)
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = company == nil ? "Create Company" : "Edit company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc fileprivate func handleUpdateSelectedDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        foundedTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc fileprivate func handleSave() {
        guard let name = nameTextField.text, name != "" else { return }
        let date = datePicker.date
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if company == nil {
            createNewCompany(name, date: date, context: context)
        } else {
            updateCompany(name, date: date, context: context)
        }
    }
    
    fileprivate func updateCompany(_ name: String, date: Date, context: NSManagedObjectContext) {
        company?.name = name
        company?.founded = date
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.updateCompany(company: self.company!)
            }
        } catch let updateError {
            print("Failed to update company:", updateError)
        }
    }
    
    fileprivate func createNewCompany(_ name: String, date: Date, context: NSManagedObjectContext) {
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(name, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        // perform save
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.addNewCompany(company: company as! Company)
            }
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
}
