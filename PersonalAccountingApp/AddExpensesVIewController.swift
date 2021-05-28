//
//  AddExpensesVIewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-23.
//

import UIKit
import CoreData
class AddExpensesVIewController: UIViewController {
    var dateString: String? = ""
    var date: Date?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var location: UITextField!

    //persistant container have a property called managedObjectContext.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Expense]?

    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = dateString
       fetchData()
       //   deleteAll()
        // Do any additional setup after loading the view.
    }
    func fetchData() {
        //this method will call fetchRequest() of our Person Entity and will return all Person objects back.
        do {
            print("hello")
            var request = NSFetchRequest<NSFetchRequestResult>()
            request = Expense.fetchRequest()
            request.returnsObjectsAsFaults = false
            self.items = try context.fetch(request) as! [Expense]
           
        }
        catch {
            print("error")
        }
        
    }
    @IBAction func addAnotherButton(_ sender: Any) {
    }
    @IBAction func doneButton(_ sender: Any) {
       
        addNewEntry()
        for item in self.items! {
            print(item)
        }
        
    }
        
    @IBAction func discardChanges(_ sender: Any) {
        desc.text = ""
        amount.text = ""
        location.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this will set the segue's destination prop as a AddExpensesVIewController
        DispatchQueue.main.async {
            let history = segue.destination as! HistoryViewController
            //copy the updated expense history to historyVC's array.
            history.entries = self.items
        }
    
        
    }
    func deleteAll() {
        for item in items!
        {
            
            self.context.delete(item)
        }
        do{
        try self.context.save()
        }
        catch {
            
        }
    }
    func addNewEntry() {
        var flag = false
        for item in items! {
            let dateFormatter: DateFormatter = DateFormatter() 
            dateFormatter.dateFormat = "MMM d, yyyy"
            if dateFormatter.string(from: item.date!) == dateString {
                item.amounts?.append(Double(amount.text!)!)
                
                item.descriptions?.append(desc.text!)
                
                flag = true
            }
            if(flag) {
                item.totalAmount = 0.0
            for amount in item.amounts! {
                item.totalAmount += amount
            }
            }
        }
        if (flag == false) {
            let newEntry = Expense(context: self.context)
            newEntry.date = date!
            
            if let amount = Double(amount.text!) {
                
                if newEntry.amounts == nil {
                    newEntry.amounts = [amount]
                }
                else {
                    newEntry.amounts?.append(amount)
                }
                if let amounts = newEntry.amounts {
                    newEntry.totalAmount = 0.0
                    for amount in amounts {
                        newEntry.totalAmount += amount
                    }
                }
            }
            if let descrip = desc.text {
                if newEntry.descriptions == nil {
                    newEntry.descriptions = [descrip]
                }
                else{
                    newEntry.descriptions?.append(descrip)
                }
                
            }
        }
        
        do {
           try self.context.save()
        }
        catch {
            
        }
        self.fetchData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
