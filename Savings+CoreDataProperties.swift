//
//  Savings+CoreDataProperties.swift
//  PersonalAccountingAppApp
//
//  Created by saj panchal on 2021-07-07.
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
    @NSManaged public var yearlySavings: YearlySavings?
    
    static func fetchRecords(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Savings] {
        let request: NSFetchRequest<Savings> = Savings.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard let savings = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        
        return savings
    }
    static func createRecord(viewContext: NSManagedObjectContext = AppDelegate.viewContext,date: String, earning: Double, expenses: [Expense]) {
        let saving = Savings(context: viewContext)
        saving.date = date
        saving.earning = earning
       
            saving.expenditure = 0.0
            for expense in expenses {
                saving.addToDailyExpenses(expense)
                saving.expenditure += Double(expense.totalAmount)
            }
        
        do {
            //try self.context.save()
            try AppDelegate.viewContext.save()
        }
        catch {
            
        }
    }
    static func editRecord(viewContext: NSManagedObjectContext = AppDelegate.viewContext,date: String, earning: Double, expenses: [Expense]) {
        let savings = Self.fetchRecords()
        let saving = savings.first {
            $0.date == date
        }
        saving?.expenditure = 0.0
        for expense in expenses {
            saving?.addToDailyExpenses(expense)
            saving?.expenditure += Double(expense.totalAmount)
        }
        
        do {
            try AppDelegate.viewContext.save()
        }
        catch {
            
        }
    }
    static func removeDuplicationsFromSavings(savings: [Savings]) -> [Savings] {
        print("remove duplication method exectuted.")
        for saving in savings {
            if (saving.expenditure == 0.0 && saving.earning == 0.0) {
                //self.context.delete(saving)
                AppDelegate.viewContext.delete(saving)
                print("Deleted:\(saving)")
            }
            
            do {
                //  try self.context.save()
                try AppDelegate.viewContext.save()
                print("success")
            }
            catch {
                print("NO LUCK")
            }
        }
        // print("updated savings:",self.savings)
        return savings
    }

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
