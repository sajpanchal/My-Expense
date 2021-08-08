//
//  ViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITabBarControllerDelegate {
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addExpenseBtn: UIButton!
    
    static var showActivtyIndicator = true
    var items: [Expense] = Expense.fetchRecords()
    var strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 46))
    
    var dateFormatter: DateFormatter {
       let formatter = DateFormatter() // date formater object
        formatter.dateFormat = "MMM d, yyyy" //date formatter string
        return formatter
    }

    var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .systemBlue
        return progressView
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        addExpenseBtn.layer.cornerRadius = 5
        toggleTabBarAvailability(isEnabled: false)
        
        if Self.showActivtyIndicator {
            setViewOpacity(alpha: 0.0)
            activityIndicator("Syncing data with iCloud...")
            
            for x in 0..<20 {
                DispatchQueue.main.asyncAfter(deadline: .now() + (Double(x)), execute: {
                    self.progressView.setProgress(Float(x)/19, animated: true)
                   // print(x)
                })
            }
            
            self.view.isUserInteractionEnabled = false
            
            Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { _ in
                //print("Timer stopped")
                self.progressView.removeFromSuperview()
                self.strLabel.removeFromSuperview()
                self.setViewOpacity(alpha: 1.0)
                self.view.isUserInteractionEnabled = true
                self.toggleTabBarAvailability(isEnabled: true)
            }
        }
        
        tabBarController?.delegate = self
        self.items = Expense.fetchRecords()
    }
    @IBAction func dateUpdated(_ sender: Any) {
        self.items = Expense.fetchRecords()
        dateFormatter.dateFormat = "MMM d, yyyy" //date formatter string
    }
    func activityIndicator(_ title: String) {
        strLabel.removeFromSuperview()
        progressView.removeFromSuperview()
        
        strLabel.alpha = 1.0
        strLabel = UILabel(frame: CGRect(x: view.frame.midX - 125, y: view.frame.midY, width: 250, height: 26))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = .systemBlue
        strLabel.textAlignment = .center
        strLabel.backgroundColor = .systemBackground
        
        progressView.frame = CGRect(x: view.frame.midX - 125, y: strLabel.frame.maxY, width: 250, height: 46)
        progressView.setProgress(0.0, animated: true)
        
        view.addSubview(strLabel)
        view.addSubview(progressView)
    }
    func toggleTabBarAvailability(isEnabled: Bool) {
        if let arrayOfTabBarItems = tabBarController?.tabBar.items {
            for item in arrayOfTabBarItems {
                item.isEnabled = isEnabled
            }
        }
    }
    func setViewOpacity(alpha: CGFloat) {
        self.selectedDate.alpha = alpha
        self.titleLabel.alpha = alpha
        self.addExpenseBtn.alpha = alpha
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.items = Expense.fetchRecords()
        
         if viewController is HistoryNC {
            
            let historyNC = viewController as! HistoryNC
            let history = historyNC.topViewController as! HistoryViewController
            history.expenses = self.items
            history.month = Calendar.current.component(.month, from: Date())
            history.year = Calendar.current.component(.year, from: Date())
        }
      
        else {
            //code
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

//-------------------- Commented Code --------------------/
/*CKContainer.default().fetchUserRecordID(completionHandler: {
 (recordID, error) in
 if let name = recordID?.recordName {
 print("iCloud ID: ", name)
 }
 else if let error = error {
 print(error.localizedDescription)
 }
 })*/
