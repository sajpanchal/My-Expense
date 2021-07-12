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
    

    //persistant container have a property called managedObjectContext.
  //  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Expense] = Expense.fetchRecords()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    //this method will be called before viewDidload. it is called right before the view is about to be loaded.
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.dateLabel.text = self.dateString
        }
        
        self.items = Expense.fetchRecords()
    }
   /* func fetchData() {
        //this method will call fetchRequest() of our Person Entity and will return all Person objects back.
        do {
          
            var request = NSFetchRequest<NSFetchRequestResult>()
            request = Expense.fetchRequest()
            request.returnsObjectsAsFaults = false
            self.items = try AppDelegate.viewContext.fetch(request) as! [Expense]
           
        }
        catch {
            print("error")
        }
        
    }*/
    @IBAction func addAnotherButton(_ sender: Any) {
        addData()
        let alert = UIAlertController(title: "Success!", message: "Data has been added successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: {
            self.desc.text = ""
            self.amount.text = ""
        })
    }
    @IBAction func doneButton(_ sender: Any) {
        addData()
        desc.text = ""
        amount.text = ""
    }
        
    @IBAction func discardChanges(_ sender: Any) {
        desc.text = ""
        amount.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this will set the segue's destination prop as a AddExpensesVIewController
        
            let dailyView = segue.destination as! DailyExpensesViewController
            //copy the updated expense history to historyVC's array.
            dailyView.dateString = self.dateString
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
        for item in self.items {
                if self.dateString == dateFormatter.string(from: item.date!) {
                    dailyView.item = item
                }
            }        
    }
    func addData()
    {
        let result = self.validateForm(desc: desc.text, amount: amount.text)
        switch result {
            case "Empty Description" :
                createAlert(title: "Error: Enter Description field is empty!", message: "Please fill out the description field to add a new entry.")
                break
            case "Empty Amount" :
                createAlert(title: "Error: Enter Amount field is empty!", message: "Please fill out the amount field to add a new entry.")
                break
            case "Short Description" :
                createAlert(title: "Error: Description is too short!", message: "Please give a valid description with 2 or more characters.")
                break
            case "Invalid amount format" :
                createAlert(title: "Error: Invalid Amount field entry!", message: "Please give a valid amount with numeric currency format.")
                break
            case "Valid Form" :
                addNewEntry()
                break
            default :
                createAlert(title: "Unkwown Error Occured!", message: "Sorry! Something went wrong.")
            
        }
    
        func createAlert(title:String, message:String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    func validateForm(desc: String?, amount: String?) -> String {
        guard let newDesc = desc else {
            return "Empty Description"
        }
        guard let newAmount = amount else {
            return "Empty Amount"
        }
        if newDesc.count < 2 {
            return "Short Description"
        }
        if Double(newAmount) == nil {
            return "Invalid amount format"
        }
        return "Valid Form"
    }
    
    
    func addNewEntry() {
       
        let dateFormatter: DateFormatter = DateFormatter() //set formatter
        dateFormatter.dateFormat = "MMM d, yyyy"
        // if item is found in a core data
        if let item = (items.first {
                            dateFormatter.string(from:$0.date!) == dateString }) {
            item.amounts?.append(Double(amount.text!)!) // append data in it.
            item.descriptions?.append(desc.text!)
            item.totalAmount = 0.0 // reset total of a given day
                item.amounts?.forEach { // recalcute the total
                    item.totalAmount += $0
                }
       }
       // if item is not found
       else {
        let newEntry = Expense(context: AppDelegate.viewContext)
            newEntry.date = date!
            let validation = self.validateForm(desc: desc.text, amount: amount.text)
        switch validation {
            case "Empty Description" :
                break
            case "Empty Amount" :
                break
            case "Short Description" :
                break
            case "Invalid amount format" :
                break
            case "Valid Form" :
                if newEntry.descriptions != nil {
                    newEntry.descriptions?.append(desc.text!)
                }
                else
                {
                    newEntry.descriptions = [desc.text!]
                }
                if newEntry.amounts != nil {
                    newEntry.amounts?.append(Double(amount.text!)!)
                }
                else {
                    newEntry.amounts = [Double(amount.text!)!]
                }
                newEntry.totalAmount = 0.0 // reset total of a given day
                newEntry.amounts?.forEach { // recalcute the total
                    newEntry.totalAmount += $0
                }
                break
            default :
                print("Error")
                
        }
       }
        
        /* ADD COMMENTED CODE IF ANY PROBLEM OCCURS */
        
        do {
            try AppDelegate.viewContext.save()
        }
        catch {
            
        }
        self.items = Expense.fetchRecords()
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

/*
 //var flag = false
 // scan each items from entity
 for item in items! {
 let dateFormatter: DateFormatter = DateFormatter() //set formatter
 dateFormatter.dateFormat = "MMM d, yyyy" //assign it a date format
 if dateFormatter.string(from: item.date!) == dateString { //if the dateString date is matching with a given item's date
 item.amounts?.append(Double(amount.text!)!)
 item.descriptions?.append(desc.text!)
 flag = true
 }
 if(flag) {
 item.totalAmount = 0.0
 if item.amounts != nil {
 for amount in item.amounts! {
 item.totalAmount += amount
 }
 }
 
 }
 }
 // if entry with given date is not found
 if (flag == false) {
 let newEntry = Expense(context: self.context)
 newEntry.date = date!
 // if amount is valid
 if let amount = Double(amount.text!) {
 //if amounts array is nil
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
 */
