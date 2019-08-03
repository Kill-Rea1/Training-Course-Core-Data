//
//  CustomMigrationPolicy.swift
//  CourseCoreData
//
//  Created by Кирилл Иванов on 03/08/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    @objc func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "Small"
        } else {
            return "Large"
        }
    }
}
