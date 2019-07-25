//
//  CreateCompanyController.swift
//  CoreData
//
//  Created by Кирилл Иванов on 25/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

protocol CreateCompanyControllerDelegate {
    func addNewCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    public var delegate: CreateCompanyControllerDelegate?
    
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
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc fileprivate func handleSave() {
        guard let name = nameTextField.text, name != "" else { return }
        let company = Company(name: name, founded: Date())
        dismiss(animated: true) {
            self.delegate?.addNewCompany(company: company)
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
}
