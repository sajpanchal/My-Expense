//
//  ViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let dateFormatter: DateFormatter = DateFormatter() // date formater object
    @IBOutlet weak var selectedDate: UIDatePicker!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Expense]?
    
    @IBAction func dateUpdated(_ sender: Any) {
        fetchData()
        dateFormatter.dateFormat = "MMM d, yyyy" //date formatter string
      //  print("Date is: " + dateFormatter.string(from: selectedDate.date))
        setupViewControllers()
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    
        dateFormatter.dateFormat = "MMM d, yyyy" //date formatter string

        setupViewControllers()
        
        // Do any additional setup after loading the view.
        
    }
    func setupViewControllers() {
        //this tabbarControllers object holds the all view controllers in an array.
        let viewControllers = self.tabBarController?.viewControllers
        //we can access and downcast the specific vc class to a given viewcontroller array element. they are having an index in order of the tab bar button order.
        let addExpenses = viewControllers![1] as! AddExpensesVIewController
        addExpenses.dateString = dateFormatter.string(from: selectedDate.date)
      
        addExpenses.date = selectedDate.date
        
        let history = viewControllers![2] as! HistoryViewController
        history.entries = self.items
        
        let dailyView = viewControllers![3] as! DailyExpensesViewController
        dailyView.item = nil
        dailyView.dateString = dateFormatter.string(from: selectedDate.date)
       // print("dailyview:",dailyView.dateString!)
        for entry in items! {
           // print("item date:", entry.date!)
            let entryDate = dailyView.dateString
            if entryDate == dateFormatter.string(from: entry.date!) {
               //print("item date:", entry.date!)
                    dailyView.item = entry
                break
            }
            else {
                
            }
        }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this will set the segue's destination prop as a AddExpensesVIewController
        let addExpenses = segue.destination as! AddExpensesVIewController
       
        //storing the date string from this viewcontroller to addExpensesVC's string property.
        //it will then be stored in it and on load of the view of this VC, it will transfer it to Date label.
        addExpenses.dateString = dateFormatter.string(from: selectedDate.date)
        addExpenses.date = selectedDate.date
        if segue.identifier == "tabBarAddExpense" {
            print ("tab bar add expense")
        }
    }
   

}

