//
//  YearlySavings+CoreDataProperties.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-27.
//
//

import Foundation
import CoreData


extension YearlySavings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YearlySavings> {
        return NSFetchRequest<YearlySavings>(entityName: "YearlySavings")
    }

    @NSManaged public var expenditure: Double
   
    @NSManaged public var earnings: Double
    public var saving: Double {
        earnings - expenditure
    }
    @NSManaged public var year: Int64
    @NSManaged public var monthlySavings: NSSet?

}

// MARK: Generated accessors for monthlySavings
extension YearlySavings {

    @objc(addMonthlySavingsObject:)
    @NSManaged public func addToMonthlySavings(_ value: Savings)

    @objc(removeMonthlySavingsObject:)
    @NSManaged public func removeFromMonthlySavings(_ value: Savings)

    @objc(addMonthlySavings:)
    @NSManaged public func addToMonthlySavings(_ values: NSSet)

    @objc(removeMonthlySavings:)
    @NSManaged public func removeFromMonthlySavings(_ values: NSSet)

}

extension YearlySavings : Identifiable {

}
