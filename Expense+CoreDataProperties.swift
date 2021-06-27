//
//  Expense+CoreDataProperties.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-27.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amounts: [Double]?
    @NSManaged public var date: Date?
    @NSManaged public var descriptions: [String]?
    @NSManaged public var totalAmount: Double
    @NSManaged public var savings: Savings?

}

extension Expense : Identifiable {

}
