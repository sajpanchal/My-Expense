//
//  Expense+CoreDataProperties.swift
//  PersonalAccountingAppApp
//
//  Created by saj panchal on 2021-07-07.
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
    
    static func fetchRecords(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Expense] {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard var expenses = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        expenses = Self.removeDuplicity(items: expenses)
        return expenses
    }
    static func deleteRecords(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        Expense.fetchRecords(viewContext: viewContext).forEach {
            viewContext.delete($0)
        }
        try? viewContext.save()
    }
    static func removeDuplicity(items: [Expense]) -> [Expense] {
        return items.sorted(by: {
            let dateformatter = DateFormatter()
            var str1 = ""
            var str2 = ""
            dateformatter.dateFormat = "YYYY/MM/dd"
            if $0.date != nil && $1.date != nil {
                str1 = dateformatter.string(from: $0.date!)
                str2 = dateformatter.string(from: $1.date!)
            }
            
            print(str1, str2)
            if (str1 == str2) {
                print("Match Found: \(str1) and \(str2)")
                if ($0.date! > $1.date!) {
                    AppDelegate.viewContext.delete($1)
                }
                else {
                    AppDelegate.viewContext.delete($0)
                }
                try? AppDelegate.viewContext.save()
            }
            return str1 > str2
        })
    }

}

extension Expense : Identifiable {

}
