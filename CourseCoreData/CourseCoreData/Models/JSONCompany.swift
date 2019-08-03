//
//  JSONCompany.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 03/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import Foundation

struct JSONCompany: Decodable {
    let name: String
    let photoUrl: String
    var founded: String?
    var employees: [JSONEmployees]?
}

struct JSONEmployees: Decodable {
    let name: String
    let birthday: String
    let type: String
}
