//
//  HistoryViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-26.
//

import UIKit
import CoreData
class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let year = Calendar.current.component(.year, from: Date())
    var expenses: [Expense] = Expense.fetchRecords()
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter
    }
 //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthStepper: UIStepper!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var monthTotalLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    var monthTotal: Double = 0.0
    var leapYear: Bool {
        let year = Int(yearStepper.value)
        if (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) {
            return true
        }
        else {
            return false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.layer.cornerRadius = 5
        monthTotalLabel.layer.cornerRadius = 5
        monthTotalLabel.layer.masksToBounds = true
     //   context.automaticallyMergesChangesFromParent = true
    }
    override func viewWillAppear(_ animated: Bool) {
       
        self.expenses = Expense.fetchRecords()
        DispatchQueue.main.async {
          
            self.historyTableView.delegate = self
            self.historyTableView.dataSource = self
            self.historyTableView.rowHeight = 70
            self.monthStepper.value = Double(Calendar.current.component(.month, from: Date()))// Do any additional setup after loading the view.
            self.yearStepper.value = Double(self.year)
            self.setMonthLabel()
            self.CalculateMonthTotal()
            self.historyTableView.reloadData()
            self.monthTotalLabel.text = "Month Total: " + self.numberFormatter.string(from: NSNumber(value:self.monthTotal))! /*String(format: "%.2f", self.monthTotal)*/
        }
    }
    
  /*  func fetchData() {
        //this method will call fetchRequest() of our Person Entity and will return all Person objects back.
        do {
           
            var request = NSFetchRequest<NSFetchRequestResult>()
            request = Expense.fetchRequest()
            request.returnsObjectsAsFaults = false
            self.entries = try AppDelegate.viewContext.fetch(request) as? [Expense]
            
        }
        catch {
            print("error")
        }
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dailyExpenses = segue.destination as! DailyExpensesViewController
        
        let dd = String(format:"%02d",historyTableView.indexPathForSelectedRow!.row+1)
        let mm = String(format:"%02d", Int(monthStepper.value))
        let dateStr = "\(dd)/\(mm)/\(Int(yearStepper.value))"

        let dateFormatter = createDateFormatter(format: "dd/MM/yy")
        let dateFormatter2 = createDateFormatter(format: "MMM d, yyyy")
        // get raw date.
        let date = dateFormatter.date(from: dateStr)
        dailyExpenses.dateString = dateFormatter2.string(from: date!) //pass the date string to daily expenses VC.
        // loop the core data entries
        for entry in expenses {
            let entryDate = dateFormatter2.string(from: entry.date!) // convert a core data entity date to string.
            // if the given date is matching with a current date
            if entryDate == dailyExpenses.dateString {
            
                dailyExpenses.item = entry // move that entry to daily expenses
               
                break
            }
        }
        
        
    }
    func createDateFormatter(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    /* method to update month on stepper value change */
    @IBAction func monthStepperChanged(_ sender: Any) {
        setMonthLabel()
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
            self.CalculateMonthTotal()
            self.monthTotalLabel.text = "Month Total: " + self.numberFormatter.string(from: NSNumber(value:self.monthTotal))! /*String(format: "%.2f", self.monthTotal)*/
        }
        
    }
    func setMonthLabel() {
        switch monthStepper.value {
            case 1:
                monthLabel.text = "Jan"
            case 2:
                monthLabel.text = "Feb"
            case 3:
                monthLabel.text = "Mar"
            case 4:
                monthLabel.text = "Apr"
            case 5:
                monthLabel.text = "May"
            case 6:
                monthLabel.text = "Jun"
            case 7:
                monthLabel.text = "Jul"
            case 8:
                monthLabel.text = "Aug"
            case 9:
                monthLabel.text = "Sep"
            case 10:
                monthLabel.text = "Oct"
            case 11:
                monthLabel.text = "Nov"
            case 12:
                monthLabel.text = "Dec"
            default:
                monthLabel.text = "not found"
        }
    }
    /* method to update the year on stepper value change.*/
    @IBAction func yearStepperChanged(_ sender: Any) {
        yearLabel.text = String(Int(yearStepper.value))
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
            self.CalculateMonthTotal()
            self.monthTotalLabel.text = "Month Total: " + self.numberFormatter.string(from: NSNumber(value:self.monthTotal))! /*String(format: "%.2f", self.monthTotal)*/
        }
    }
    /* using tableview delegate method to return the number of rows of table based on the month selected.*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch monthStepper.value {
            case 1.0,3.0,5.0,7.0,8.0,10.0,12.0:
                return 31
            case 4.0,6.0,9.0,11.0:
                return 30
            case 2.0:
                if leapYear {
                    return 29
                }
                else {
                    return 28
                }
                
            default:
                return 31
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func CalculateMonthTotal() {
        if !expenses.isEmpty {
            monthTotal = 0.0
            for item in expenses {
                if (Calendar.current.component(.month, from: item.date!) == Int(monthStepper.value)) && (Calendar.current.component(.year, from: item.date!) == Int(yearStepper.value)){
                    monthTotal += item.totalAmount
                }
            }
        }
       
    }
    /* using tableview delegate method to create a cell object and returning it.*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // this will link the custom cell (HistoryTableViewCell) on each indexPath of our tableview and creates a cell object.
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! HistoryTableViewCell
        cell.dayLabel.text = String(format: "%02d",(indexPath.row + 1))
        cell.dayLabel.layer.cornerRadius = 3
        cell.amountLabel.text = ""
        if !expenses.isEmpty {
         
            for item in expenses {
                if Calendar.current.component(.day, from: item.date!) == (indexPath.row + 1) && Calendar.current.component(.month, from: item.date!) == Int(monthStepper.value) && Calendar.current.component(.year, from: item.date!) == Int(yearStepper.value){
                    cell.dayLabel.text = String(format: "%02d",(indexPath.row + 1))
                    cell.amountLabel.text = numberFormatter.string(from: NSNumber(value:item.totalAmount)) /*String(format:"%.2f",(item.totalAmount))*/
                }
            }
        }
       // monthTotal = 0.0
        return cell
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
