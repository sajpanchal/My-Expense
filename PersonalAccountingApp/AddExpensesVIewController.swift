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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Expense]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       //   deleteAll()
        // Do any additional setup after loading the view.
    }
    //this method will be called before viewDidload. it is called right before the view is about to be loaded.
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.dateLabel.text = self.dateString
        }
        
        fetchData()
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
            for item in self.items! {
                if self.dateString == dateFormatter.string(from: item.date!) {
                    dailyView.item = item
                    print(dailyView.item?.descriptions! ?? "")
                }
            }        
    }
    func addData()
    {
        if let descString = desc.text {
            if descString.count < 2 {
                let descAlert = UIAlertController(title: "Invalid entry(s)", message: "Description field entry must have at least 2 or more characters long.", preferredStyle: .alert)
                descAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(descAlert, animated: true, completion: nil)
            }
            else{
                if Double(amount.text!) != nil {
                    addNewEntry()
                }
                else{
                    let amountAlert = UIAlertController(title: "Invalid entry(s)",
                                                        message: "amount field entry must be filled with numeric currency amount.", preferredStyle: .alert)
                    amountAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(amountAlert, animated: true, completion: nil)
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Invalid entry(s)", message: "All fields must have to be filled to add the entry.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                if item.amounts != nil {
                    for amount in item.amounts! {
                        item.totalAmount += amount
                    }
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
