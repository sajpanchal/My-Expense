//
//  ViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-23.
//

import UIKit


class ViewController: UIViewController {
    let dateFormatter: DateFormatter = DateFormatter() // date formater object
    @IBOutlet weak var selectedDate: UIDatePicker!
    
 
    @IBAction func dateUpdated(_ sender: Any) {
       
        dateFormatter.dateFormat = "MMM d, yyyy" //date formatter string
        print("Date is: " + dateFormatter.string(from: selectedDate.date))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MMM d, yyyy" //date formatter string
        print("Date is: " + dateFormatter.string(from: selectedDate.date))
       
        // Do any additional setup after loading the view.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this will set the segue's destination prop as a AddExpensesVIewController
        let addExpenses = segue.destination as! AddExpensesVIewController
       
        //storing the date string from this viewcontroller to addExpensesVC's string property.
        //it will then be stored in it and on load of the view of this VC, it will transfer it to Date label.
        addExpenses.dateString = dateFormatter.string(from: selectedDate.date)
        addExpenses.date = selectedDate.date
    }


}

