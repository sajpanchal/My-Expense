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
    var entries: [Expense]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthStepper: UIStepper!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var monthTotalLabel: UILabel!
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
       
    }
    override func viewWillAppear(_ animated: Bool) {
       
        fetchData()
        DispatchQueue.main.async {
            print(self.entries!)
            self.historyTableView.delegate = self
            self.historyTableView.dataSource = self
            self.historyTableView.rowHeight = 90
            self.monthStepper.value = Double(Calendar.current.component(.month, from: Date()))// Do any additional setup after loading the view.
            self.yearStepper.value = Double(self.year)
            self.setMonthLabel()
            self.CalculateMonthTotal()
            self.historyTableView.reloadData()
            self.monthTotalLabel.text = "Month Total: $" + String(format: "%.2f", self.monthTotal)
        }
    }
    
    func fetchData() {
        //this method will call fetchRequest() of our Person Entity and will return all Person objects back.
        do {
           
            var request = NSFetchRequest<NSFetchRequestResult>()
            request = Expense.fetchRequest()
            request.returnsObjectsAsFaults = false
            self.entries = try context.fetch(request) as! [Expense]
            
        }
        catch {
            print("error")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dailyExpenses = segue.destination as! DailyExpensesViewController
        
        let dd = String(format:"%02d",historyTableView.indexPathForSelectedRow!.row+1)
        let mm = String(format:"%02d", Int(monthStepper.value))
        let dateStr = "\(dd)/\(mm)/\(Int(yearStepper.value))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM d, yyyy"
        let date = dateFormatter.date(from: dateStr)
        dailyExpenses.dateString = dateFormatter2.string(from: date!)
        print(dailyExpenses.dateString!)
        for entry in entries! {
            let entryDate = dateFormatter2.string(from: entry.date!)
            if entryDate == dailyExpenses.dateString {
            
                dailyExpenses.item = entry
                print(dailyExpenses.item!, date!)
                break
            }
        }
        
    }
    /* method to update month on stepper value change */
    @IBAction func monthStepperChanged(_ sender: Any) {
        setMonthLabel()
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
            self.CalculateMonthTotal()
            self.monthTotalLabel.text = "Month Total: $" + String(format: "%.2f", self.monthTotal)
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
            self.monthTotalLabel.text = "Month Total: $" + String(format: "%.2f", self.monthTotal)
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
        if let items = entries {
            monthTotal = 0.0
            for item in items {
                if (Calendar.current.component(.month, from: item.date!) == Int(monthStepper.value)) && (Calendar.current.component(.year, from: item.date!) == Int(yearStepper.value)){
                    monthTotal += item.totalAmount
                    print(monthTotal)
                }
            }
        }
       
    }
    /* using tableview delegate method to create a cell object and returning it.*/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // this will link the custom cell (HistoryTableViewCell) on each indexPath of our tableview and creates a cell object.
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! HistoryTableViewCell
        cell.dayLabel.text = String(format: "%02d",(indexPath.row + 1))
        cell.amountLabel.text = ""
        if let items = entries {
         
            for item in items {
                if Calendar.current.component(.day, from: item.date!) == (indexPath.row + 1) && Calendar.current.component(.month, from: item.date!) == Int(monthStepper.value) && Calendar.current.component(.year, from: item.date!) == Int(yearStepper.value){
                    cell.dayLabel.text = String(format: "%02d",(indexPath.row + 1))
                    cell.amountLabel.text = "$"+String(format:"%.2f",(item.totalAmount))
                  
                 
                    
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
