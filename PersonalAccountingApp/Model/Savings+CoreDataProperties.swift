//
//  Savings+CoreDataProperties.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-26.
//
//

import Foundation
import CoreData


extension Savings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Savings> {
        return NSFetchRequest<Savings>(entityName: "Savings")
    }

    @NSManaged public var date: String?
    @NSManaged public var earning: Double
    @NSManaged public var expenditure: Double
    public var saving: Double {
        earning - expenditure
    }
    @NSManaged public var dailyExpenses: NSSet?

}

// MARK: Generated accessors for dailyExpenses
extension Savings {

    @objc(addDailyExpensesObject:)
    @NSManaged public func addToDailyExpenses(_ value: Expense)

    @objc(removeDailyExpensesObject:)
    @NSManaged public func removeFromDailyExpenses(_ value: Expense)

    @objc(addDailyExpenses:)
    @NSManaged public func addToDailyExpenses(_ values: NSSet)

    @objc(removeDailyExpenses:)
    @NSManaged public func removeFromDailyExpenses(_ values: NSSet)

}

extension Savings : Identifiable {

}
