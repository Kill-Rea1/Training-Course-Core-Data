//
//  Service.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 03/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    let url = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func fetchAPI() {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            if let error = error {
                print("Failed to fetch:", error)
            }
            
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let companies = try jsonDecoder.decode([JSONCompany].self, from: data)
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                companies.forEach({ (jsonCompany) in
                    let company = Company(context: privateContext)
                    
                    company.name = jsonCompany.name
                    company.photoUrl = jsonCompany.photoUrl
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    company.founded = dateFormatter.date(from: jsonCompany.founded ?? "")
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        
                        let employee = Employee(context: privateContext)
                        employee.company = company
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        employeeInformation.birthday = dateFormatter.date(from: jsonEmployee.birthday)
                        employee.employeeInformation = employeeInformation
                        
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let saveErr {
                        print("Failed to save API Companies:", saveErr)
                    }
                })
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
        }.resume()
    }
    
    
    func fetchImageData(urlString: String, completion: @escaping (Error?, Data?)->()) {
        let guardError = NSError(domain: "Error", code: 0, userInfo: nil)
        guard let url = URL(string: urlString) else {
            completion(guardError ,nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            if let error = error {
                print("Failed to download image:", error)
                completion(error, nil)
                return
            }
            
            guard let data = data else {
                completion(guardError, nil)
                return
            }
            
            completion(nil, data)
        }.resume()
    }
}
