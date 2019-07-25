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
    fileprivate let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    fileprivate let size = CGSize(width: 0, height: 50)
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
    
    fileprivate lazy var companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 60
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return iv
    }()
    
    fileprivate let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Select Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
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
    
    fileprivate let foundedLabel: UILabel = {
        let label = UILabel()
        label.text = "Founded"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.widthContraint(to: 100)
        return label
    }()
    
    fileprivate let foundedTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        tf.text = dateFormatter.string(from: Date())
        tf.isEnabled = false
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
        backgorundView.addConstraints(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: nil, size: .init(width: 0, height: 450))
        
        backgorundView.addSubview(companyImageView)
        companyImageView.addConstraints(leading: nil, trailing: nil, top: backgorundView.topAnchor, bottom: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 120, height: 120))
        companyImageView.centerXAnchor.constraint(equalTo: backgorundView.centerXAnchor).isActive = true
        
        backgorundView.addSubview(selectPhotoButton)
        selectPhotoButton.addConstraints(leading: backgorundView.leadingAnchor, trailing: backgorundView.trailingAnchor, top: companyImageView.bottomAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 40))
        
        backgorundView.addSubview(nameStackView)
        nameStackView.addConstraints(leading: backgorundView.leadingAnchor, trailing: backgorundView.trailingAnchor, top: selectPhotoButton.bottomAnchor, bottom: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 16), size: size)
        
        backgorundView.addSubview(foundedStackView)
        foundedStackView.addConstraints(leading: backgorundView.leadingAnchor, trailing: backgorundView.trailingAnchor, top: nameStackView.bottomAnchor, bottom: nil, padding: padding, size: size)
        
        backgorundView.addSubview(datePicker)
        datePicker.addConstraints(leading: backgorundView.leadingAnchor, trailing: backgorundView.trailingAnchor, top: foundedStackView.bottomAnchor, bottom: backgorundView.bottomAnchor)
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = company == nil ? "Create Company" : "Edit company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
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

extension CreateCompanyController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        dismiss(animated: true)
    }
}
