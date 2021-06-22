//
//  Savings+CoreDataProperties.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-20.
//
//

import Foundation
import CoreData


extension Savings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Savings> {
        return NSFetchRequest<Savings>(entityName: "Savings")
    }

    @NSManaged public var earning: Double
    @NSManaged public var expenditure: Double
    @NSManaged public var saving: Double
    @NSManaged public var date: String?

}
