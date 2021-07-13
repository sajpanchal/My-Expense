//
//  YearlySavings+CoreDataProperties.swift
//  PersonalAccountingAppApp
//
//  Created by saj panchal on 2021-07-07.
//
//

import Foundation
import CoreData


extension YearlySavings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<YearlySavings> {
        return NSFetchRequest<YearlySavings>(entityName: "YearlySavings")
    }

    @NSManaged public var earnings: Double
    @NSManaged public var expenditure: Double
    public var saving: Double {
        earnings - expenditure
    }
    @NSManaged public var year: Int64
    @NSManaged public var monthlySavings: NSSet?
    
    static func fetchRecords(context: NSManagedObjectContext = AppDelegate.viewContext) -> [YearlySavings] {
        let request: NSFetchRequest<YearlySavings> = YearlySavings.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard let yearlySavings = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return yearlySavings
    }
    static func createRecord(year: Int, savings: [Savings]) -> YearlySavings {
        let currentYearSaving = YearlySavings(context: AppDelegate.viewContext)
        for saving in savings {
            currentYearSaving.addToMonthlySavings(saving)
            currentYearSaving.expenditure += saving.expenditure
            currentYearSaving.earnings += saving.earning
            currentYearSaving.year = Int64(year)
        }
        do {
            //try self.context.save()
            try AppDelegate.viewContext.save()
        }
        catch {
            
        }
        return currentYearSaving
    }
    static func editRecord(year: Int, savings: [Savings]) -> YearlySavings? {
        let yearlySavings = YearlySavings.fetchRecords()
        let currentYearSavings = yearlySavings.first {
            $0.year == year
        }
        currentYearSavings?.expenditure = 0.0
        currentYearSavings?.earnings = 0.0
        for saving in savings {
            currentYearSavings?.expenditure += Double(saving.expenditure)
            currentYearSavings?.earnings += Double(saving.earning)
        }
        return currentYearSavings
    }
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
