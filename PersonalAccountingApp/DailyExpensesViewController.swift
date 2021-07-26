//
//  DailyExpensesViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-29.
//

import UIKit
import CoreData
class DailyExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter
    }
    var dateString: String?
    var item: Expense?
 //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Expense] = Expense.fetchRecords()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyExpenseTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        totalAmountLabel.layer.cornerRadius = 5
        totalAmountLabel.layer.masksToBounds = true
       // context.automaticallyMergesChangesFromParent = true
        DispatchQueue.main.async {
           
        }
        // Do any additional setup after loading the view.
    }
    //this method loads whenever our view is about to be appear.

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [self] in
            self.items = Expense.fetchRecords()
            self.dateLabel.text = self.dateString ?? ""
           
            self.totalAmountLabel.text = "Day's Total: " + numberFormatter.string(from: NSNumber(value: self.item?.totalAmount ?? 0.0))!
          
            self.dailyExpenseTableView.delegate = self
            self.dailyExpenseTableView.dataSource = self
            self.dailyExpenseTableView.rowHeight = 70
            self.dailyExpenseTableView.reloadData()
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addExpenses = segue.destination as! AddExpensesVIewController
        addExpenses.dateString = dateString
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        item?.descriptions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyExpense", for: indexPath) as! DailyExpenseTableViewCell
        cell.descriptionLabel.text = item!.descriptions![indexPath.row]
      //  cell.amountLabel.text = "$"+ String(item!.amounts![indexPath.row])
        cell.amountLabel.text = self.numberFormatter.string(from: NSNumber(value: item!.amounts![indexPath.row]))!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* create an alert with 2 text fields on select of a cell.*/
        let alert = UIAlertController(title: "Edit Entry", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        let desc = alert.textFields![0]
        let amount = alert.textFields![1]
        desc.text = self.item!.descriptions![indexPath.row]
        amount.text = String(self.item!.amounts![indexPath.row])
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [self]_ in
            let result = items.contains {  exp in
                                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy"
                let correctDate = formatter.string(from: exp.date!)  == self.dateString
                var correctEntry = false
                if correctDate {
                    correctEntry = (exp.descriptions![indexPath.row] == item?.descriptions![indexPath.row]) && (exp.amounts![indexPath.row] == item?.amounts![indexPath.row])
                    
                }

                if correctDate && correctEntry {
                    let formValidation = validateForm(desc: desc.text, amount: amount.text)
                    switch formValidation {
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
                            editData(item: exp, index: indexPath.row, desc: desc.text!, amount: Double(amount.text!)!)
                            
                            // save changes.
                            do {
                                try AppDelegate.viewContext.save()
                            }
                            catch{
                            }
                            
                            self.items = Expense.fetchRecords()
                            
                            self.dailyExpenseTableView.reloadData()
                            break
                        default :
                            createAlert(title: "Unkwown Error Occured!", message: "Sorry! Something went wrong.")
                    }
                }
                
                return correctDate && correctEntry
            }
            if !(result) {
                print("error")
            }
           
    }
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
        
        
       
    }
    func editData(item: Expense, index: Int, desc: String, amount: Double) {
        item.descriptions![index] = desc
        item.amounts?[index] = amount
        
        item.totalAmount = {
            var total = 0.0
            for j in 0..<(item.amounts!.count) {
                total += item.amounts![j]
            }
            return total
        }()
        // display the total.
        self.totalAmountLabel.text = "Day's Total: " + self.numberFormatter.string(from: NSNumber(value: item.totalAmount))!
    }
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    //delete a given row from table view.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self]_,_,_ in
        
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            for i in 0..<(self.items.count) {
                if formatter.string(from: (self.items[i].date)!) == dateString {
                    if self.items[i].descriptions != nil {
                        if self.items[i].descriptions![indexPath.row] == self.item?.descriptions![indexPath.row] && self.items[i].amounts![indexPath.row] == self.item?.amounts![indexPath.row] {
                            self.items[i].totalAmount -= (self.items[i].amounts![indexPath.row])
                            self.items[i].descriptions?.remove(at: indexPath.row)
                            self.items[i].amounts?.remove(at: indexPath.row)
                            DispatchQueue.main.async {
                                self.totalAmountLabel.text = "Day's Total: " + numberFormatter.string(from: NSNumber(value: self.items[i].totalAmount))! /*String(format: "%.2f",(self.items[i].totalAmount ))*/
                            }
                       
                        }
                    }
                }
                else {
                    continue
                }
            }
            do {
                try AppDelegate.viewContext.save()
            }
            catch{
                
            }
            self.items = Expense.fetchRecords()
          
            self.dailyExpenseTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
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
 //if text is not empty
 if let desc = desc.text {
 // if desc is long enough.
 if desc.count > 2 {
 let formatter = DateFormatter()
 formatter.dateFormat = "MMM d, yyyy"
 // loop through the core data items
 for i in 0..<(self.items?.count)! {
 // if date in the core data is matching with the date string
 if formatter.string(from: (self.items?[i].date)!) == self.dateString {
 // if item description is not nil
 if self.items?[i].descriptions != nil {
 //if description and amount is matching
 if self.items?[i].descriptions![indexPath.row] == self.item?.descriptions![indexPath.row] && self.items?[i].amounts![indexPath.row] == self.item?.amounts![indexPath.row] {
 //edit the description.
 self.items![i].descriptions![indexPath.row] = desc
 // if amount is valid
 if let amount = Double(amount.text!) {
 // transfer the amount
 self.items![i].amounts![indexPath.row] = amount
 // re-calculate the total.
 self.items![i].totalAmount = {
 var total = 0.0
 for j in 0..<self.items![i].amounts!.count {
 total += self.items![i].amounts![j]
 }
 return total
 }()
 // display the total.
 self.totalAmountLabel.text = "Day's Total: $" + String(format: "%.2f",(self.item?.totalAmount ?? 0.0))
 // save changes.
 do {
 try self.context.save()
 }
 catch{
 
 }
 self.fetchData()
 
 self.dailyExpenseTableView.reloadData()
 }
 // if amount is invalid show alert
 else{
 let amountAlert = UIAlertController(title: "Invalid amount Entry", message: "Must be in a numeric currency format", preferredStyle: .alert)
 amountAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
 self.present(amountAlert, animated: true, completion: nil)
 
 }
 }
 }
 }
 }
 }
 //if description is short
 else {
 let descAlert = UIAlertController(title: "Invalid descirption Entry", message: "Must be at least 2 characters long.", preferredStyle: .alert)
 descAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
 self.present(descAlert, animated: true, completion: nil)
 }
 } //if any of the fields are empty.
 else {
 let emptyAlert = UIAlertController(title: "Empty fields not accepted", message: "Please fill out all required fields to proceed.", preferredStyle: .alert)
 emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
 self.present(emptyAlert, animated: true, completion: nil)
 }
 */
