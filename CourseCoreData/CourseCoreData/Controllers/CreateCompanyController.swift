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
            nameTextField.text = company?.name ?? ""
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
        return label
    }()
    
    fileprivate let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Name"
        return tf
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
        backgorundView.addConstraints(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: nil, size: .init(width: 0, height: 50))
        backgorundView.addSubview(nameLabel)
        nameLabel.addConstraints(leading: view.leadingAnchor, trailing: nil, top: view.topAnchor, bottom: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: 100, height: 50))
        backgorundView.addSubview(nameTextField)
        nameTextField.addConstraints(leading: nameLabel.trailingAnchor, trailing: backgorundView.trailingAnchor, top: nameLabel.topAnchor, bottom: nil, size: .init(width: 0, height: 50))
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = company == nil ? "Create Company" : "Edit company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc fileprivate func handleSave() {
        guard let name = nameTextField.text, name != "" else { return }
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if company == nil {
            createNewCompany(name, context: context)
        } else {
            updateCompany(name, context: context)
        }
    }
    
    fileprivate func updateCompany(_ name: String, context: NSManagedObjectContext) {
        company?.name = name
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.updateCompany(company: self.company!)
            }
        } catch let updateError {
            print("Failed to update company:", updateError)
        }
    }
    
    fileprivate func createNewCompany(_ name: String, context: NSManagedObjectContext) {
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(name, forKey: "name")
        
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
