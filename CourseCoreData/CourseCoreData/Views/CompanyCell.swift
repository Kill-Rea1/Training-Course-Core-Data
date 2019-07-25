//
//  CompanyCell.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 26/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    public var company: Company? {
        didSet {
            guard let founded = company?.founded else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            companyLabel.text = "\(company?.name ?? "") - Founded: \(dateFormatter.string(from: founded))"
            guard let imageData = company?.imageData else { return }
            companyImageView.image = UIImage(data: imageData)
        }
    }
    fileprivate let imageSize: CGFloat = 50
    fileprivate let companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let companyLabel: UILabel = {
        let label = UILabel()
        label.text = "Company name"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tealColor
        setupCircularImageStyle()
        
        let overralStackView = UIStackView(arrangedSubviews: [companyImageView, companyLabel])
        overralStackView.spacing = 8
        overralStackView.alignment = .center
        addSubview(overralStackView)
        overralStackView.fillSuperview(padding: .init(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    fileprivate func setupCircularImageStyle() {
        companyImageView.widthContraint(to: imageSize)
        companyImageView.heightConstraint(to: imageSize)
        companyImageView.layer.cornerRadius = imageSize / 2
        companyImageView.layer.borderWidth = 2
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
