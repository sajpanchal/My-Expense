//
//  SavingsViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-20.
//

import UIKit
import CoreData
class SavingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses: [Expense] = Expense.fetchRecords()
    var savings: [Savings] = Savings.fetchRecords()
    var yearlySavings: [YearlySavings] = YearlySavings.fetchRecords()
    var editMode: Bool = false
    var monthsTotal: [Double]?
    var yearSavings: Double?
    var yearEarnings: Double?
    var yearExpense: Double?
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter
    }
    
    @IBOutlet weak var yearSummaryView: UIView!
    @IBOutlet weak var summaryYearLabel: UILabel!
    @IBOutlet weak var savingsTableView: UITableView!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearlySavingsLbl: UILabel!
    @IBOutlet weak var yearlyExpenseLbl: UILabel!
    @IBOutlet weak var yearlyEarningsLbl: UILabel!
    @IBOutlet weak var updateEarningsBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    var isBtnUpdating = false
    @IBAction func earningsButton(_ sender: Any) {
        isBtnUpdating.toggle()
        DispatchQueue.main.async {
            if self.isBtnUpdating {
                self.editUpdateEarningBtn(image: "xmark.rectangle.fill", backgroundColor: .red, title: "Cancel")
               
            }
            else {
                self.editUpdateEarningBtn(image: "square.and.pencil", backgroundColor: self.yearLabel.textColor, title: "Update Earnings")
                
            }
            
        }
        
        editMode.toggle()
        savingsTableView.setEditing(editMode, animated: true)
    }
    func editUpdateEarningBtn(image: String, backgroundColor: UIColor, title: String) {
        self.updateEarningsBtn.setImage(UIImage(systemName: image), for: .normal)
        self.updateEarningsBtn.backgroundColor = backgroundColor
        self.updateEarningsBtn.setTitle(title, for: .normal)
    }
    @IBAction func yearStepperChanged(_ sender: Any) {
        yearSavings = 0.0
        monthsTotal = []
        yearLabel.text = String(Int(yearStepper.value))
        summaryYearLabel.text = "Year " + String(Int(yearStepper.value)) + " " + "Summary"
        
        createSavings(year: Int(yearStepper.value))
        self.expenses = Expense.fetchRecords()
        self.savings = Savings.fetchRecords()
        self.yearlySavings = YearlySavings.fetchRecords()
        DispatchQueue.main.async {
            self.savingsTableView.reloadData()
            print("table reloaded from year stepper.")
        }
        
        print(savings)
        
        print(yearlySavings)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        //   monthsTotal = []
        yearStepper.value = Double(Calendar.current.component(.year, from: Date()))
       // print(savings)
        print("Before: ")
        print(savings)
        print(yearlySavings)

        createSavings(year: Int(yearStepper.value))
        self.expenses = Expense.fetchRecords()
        self.savings = Savings.fetchRecords()
        self.yearlySavings = YearlySavings.fetchRecords()

        DispatchQueue.main.async {
            
            self.updateEarningsBtn.setTitle("Update Earnings", for: .normal)
            self.savingsTableView.reloadData()
            self.yearStepper.value = Double(Calendar.current.component(.year, from: Date()))
            self.summaryYearLabel.text = "Year " + String(Int(self.yearStepper.value)) + " " + "Summary"
            self.savingsTableView.delegate = self
            self.savingsTableView.dataSource = self
            self.yearLabel.text = String(Calendar.current.component(.year, from: Date()))
        }
        
        print("View will appear")
       // deleteSavingAll()
       // deleteYearlySavingAll()
        print("After: ")
        print(savings)
        print(yearlySavings)
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEarningsBtn.layer.cornerRadius = 5
        yearSummaryView.layer.cornerRadius = 5
        headerView.layer.cornerRadius = 5
        // deleteAll()
       // context.automaticallyMergesChangesFromParent = true
        DispatchQueue.main.async {
            self.savingsTableView.reloadData()
            self.yearStepper.value = Double(Calendar.current.component(.year, from: Date()))
            self.summaryYearLabel.text = "Year " + String(Int(self.yearStepper.value)) + " " + "Summary"
            self.savingsTableView.delegate = self
            self.savingsTableView.dataSource = self
            self.yearLabel.text = String(Calendar.current.component(.year, from: Date()))
        }
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 12
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = savingsTableView.dequeueReusableCell(withIdentifier: "savings", for: indexPath) as! SavingsTableViewCell
        cell.monthLabel.text = getMonth(number: indexPath.row + 1) + " " + yearLabel.text!
        
        let saving = filterSavings(date: cell.monthLabel.text!)
     //   cell.expenditureLabel.text = "$" + String(format: "%.2f",  saving?.expenditure ?? "--")
   
        //cell.earningsLabel.text = "$" + String(format: "%.2f",  saving?.earning ?? "--")
        //cell.savingsLabel.text = "$" + String(format: "%.2f",  saving?.saving ?? "--")
        cell.expenditureLabel.text = numberFormatter.string(from: NSNumber(value: saving?.expenditure ?? 0.0))
        cell.earningsLabel.text = numberFormatter.string(from: NSNumber(value: saving?.earning ?? 0.0))
        cell.savingsLabel.text = numberFormatter.string(from: NSNumber(value: saving?.saving ?? 0.0))
        cell.savingsLabel.textColor = (saving?.saving ?? 0.0) > 0.0 ? .green : .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .insert
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        createAlert(title: "Add Earnings", message: "Add This month's Earnings", textField: true , row:indexPath.row)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        createAlert(title: "Add Earnings", message: "Add This month's Earnings", textField: true , row:indexPath.row)

    }
    
    func removeDuplicationsFromYearlySavings(yearlySavings:[YearlySavings]?) -> [YearlySavings]? {
        
        return yearlySavings
    }
    
    func createSavings(year: Int) {
        self.expenses = Expense.fetchRecords()
        self.savings = Savings.fetchRecords()
        self.yearlySavings = YearlySavings.fetchRecords()
       //scan from jan to dec
        for month in 1...12 {
            // create expenses array of a given month from expenses array as whole.
            let monthExpenses = self.expenses.filter { expense in
                let mm = Calendar.current.component(.month, from: expense.date!)
                let yy = Calendar.current.component(.year, from: expense.date!)
                if mm == month && yy == year {
                //    print("Expense list of month \(month), \(yy): ", expense)
                    return true
                }
                else {
                    return false
                }
            }
                // if we have that month's expense records
                if !monthExpenses.isEmpty {
                    let date = getMonth(number: month) + " " + String(year)
                    // if the entiry has a given month's data
                    if (savings.contains { saving in
                       // (saving.date?.hasSuffix(yearLabel.text!) ?? false)
                        saving.date == getMonth(number: month) + " " + String(year)
                    }){
                        Savings.editRecord(date: date, earning: 0.0, expenses: monthExpenses)
                    }
                    else {
                        // create a saving context.
                        Savings.createRecord(date: date, earning: 0.0, expenses: monthExpenses)
                    }
                }
        }
        print("after creating savings: ",self.savings)
        savings = Savings.removeDuplicationsFromSavings(savings: savings)
        savings = Savings.fetchRecords()
        createYearlySavings(year: year)
    }
    
    func filterSavings(date: String) -> Savings? {
        let saving = self.savings.first { saving in
            saving.date == date
        }
        return saving
    }
    
    func createYearlySavings (year: Int) {
        self.expenses = Expense.fetchRecords()
        self.savings = Savings.fetchRecords()
        self.yearlySavings = YearlySavings.fetchRecords()
        
        print("create yearly savings method called.")
        //make sure we have that year's data or exit the function.
        let filteredSavings = (self.savings.filter { saving in
            return ((saving.date?.hasSuffix(String(year)) ?? false))
            })
        
        if filteredSavings.isEmpty {
            print("monthy savings not found for year \(year)")
            yearlySavingsLbl.text = "$--"
            yearlyExpenseLbl.text = "$--"
            yearlyEarningsLbl.text = "$--"
            yearlySavingsLbl.textColor = .red
            return
        }
        
        //if our yearlySavings entity contatins a given year's data
        if (self.yearlySavings.contains {
            return  $0.year == year && $0.monthlySavings != nil
        }) {

            let currentYearSavings = YearlySavings.editRecord(year: year, savings: filteredSavings)
            
            DispatchQueue.main.async {
               // self.yearlySavingsLbl.text = "$" + String(format: "%.2f",currentYearSavings?.saving ?? "--")
               // self.yearlyExpenseLbl.text = "$" + String(format: "%.2f",currentYearSavings?.expenditure ?? "--")
              //  self.yearlyEarningsLbl.text = "$" + String(format: "%.2f",currentYearSavings?.earnings ?? "--")
                self.yearlySavingsLbl.text = self.numberFormatter.string(from: NSNumber(value: currentYearSavings?.saving ?? 0.0))
                self.yearlyExpenseLbl.text = self.numberFormatter.string(from: NSNumber(value: currentYearSavings?.expenditure ?? 0.0))
                self.yearlyEarningsLbl.text = self.numberFormatter.string(from: NSNumber(value: currentYearSavings?.earnings ?? 0.0))
                self.yearlySavingsLbl.textColor = (currentYearSavings?.saving ?? 0.0) > 0.0 ? .green : .red
            }
        }
        // create a new yearlySaving entry.
        else {
            let currentYearSavings = YearlySavings.createRecord(year: year, savings: filteredSavings)
            
            DispatchQueue.main.async {
              /*  self.yearlySavingsLbl.text = "$" + String(format: "%.2f",currentYearSavings.saving)
                self.yearlyExpenseLbl.text = "$" + String(format: "%.2f",currentYearSavings.expenditure)
                self.yearlyEarningsLbl.text = "$" + String(format: "%.2f",currentYearSavings.earnings)*/
                self.yearlySavingsLbl.text = self.numberFormatter.string(from: NSNumber(value: currentYearSavings.saving))
                self.yearlyExpenseLbl.text = self.numberFormatter.string(from: NSNumber(value: currentYearSavings.expenditure))
                self.yearlyEarningsLbl.text = self.numberFormatter.string(from: NSNumber(value: currentYearSavings.earnings))
                self.yearlySavingsLbl.textColor = (currentYearSavings.saving) > 0.0 ? .green : .red
            }
        }
    }
    
    func createAlert(title:String, message:String, textField: Bool, row: Int) {
        self.expenses = Expense.fetchRecords()
        self.savings = Savings.fetchRecords()
        self.yearlySavings = YearlySavings.fetchRecords()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if textField {
        alert.addTextField()
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            self.editUpdateEarningBtn(image: "square.and.pencil", backgroundColor: self.yearLabel.textColor, title: "Update Earnings")
            let amount = alert.textFields![0]
            if let earning = Double(amount.text!) {
                let date = self.getMonth(number: row+1) + " " + self.yearLabel.text!
                let result = self.savings.contains {
                    if ($0.date == date) {
                        $0.earning = earning
                        print("earning updated for a month \(date) by ",$0.earning)
                        //$0.saving = $0.earning - $0.expenditure
                        
                        do {
                            try AppDelegate.viewContext.save()
                            print("saved changes.")
                        }
                        catch {
                            print("save changes failed.")
                        }
                        return true
                    }
                    else {
                        return false
                    }
                    
                }
                // if we have the savings record having a given month and year and changes were made too.
                if result {
                    self.expenses = Expense.fetchRecords()
                    self.savings = Savings.fetchRecords()
                    self.yearlySavings = YearlySavings.fetchRecords()
                    self.createYearlySavings(year: Int(self.yearLabel.text!)!)
                }
                else {
                   let date = self.getMonth(number: row+1) + " " + self.yearLabel.text!
                   let earning = Double(amount.text!)
                    Savings.createRecord(date: date, earning: earning!, expenses: [])
                    self.createYearlySavings(year: Int(self.yearLabel.text!)!)
                }
                
                self.savings = Savings.fetchRecords()
                self.yearlySavings = YearlySavings.fetchRecords()
                DispatchQueue.main.async {
                    self.savingsTableView.reloadData()
                }
            }
            self.editMode = false
            self.isBtnUpdating = false
            self.savingsTableView.setEditing(self.editMode, animated: true)
            })
       
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel) {_ in
            self.editUpdateEarningBtn(image: "square.and.pencil", backgroundColor: self.yearLabel.textColor, title: "Update Earnings")
            self.editMode = false
            self.isBtnUpdating = false
            self.savingsTableView.setEditing(self.editMode, animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteSavingAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Savings")
       
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
          //  try context.execute(batchDeleteRequest)
           // try self.context.save()
            try AppDelegate.viewContext.execute(batchDeleteRequest)
            try AppDelegate.viewContext.save()
            print("success")
        }
        catch {
            print("NO LUCK")
        }
        
    }
    func deleteYearlySavingAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "YearlySavings")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try AppDelegate.viewContext.execute(batchDeleteRequest)
            try AppDelegate.viewContext.save()
            print("success")
        }
        catch {
            print("NO LUCK")
        }
        
    }
    func getMonth(number: Int) -> String {
        switch number {
            case 1:
                return "Jan"
            case 2:
                return "Feb"
            case 3:
                return "Mar"
            case 4:
                return "Apr"
            case 5:
                return "May"
            case 6:
                return "Jun"
            case 7:
                return "Jul"
            case 8:
                return "Aug"
            case 9:
                return "Sep"
            case 10:
                return "Oct"
            case 11:
                return "Nov"
            case 12:
                return "Dec"
            default:
                return ""
        }
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
/*func CalculateMonthTotal(month: Int, date: String) -> Double {
 var monthTotal = 0.0
 if let items = expenses {
 monthTotal = 0.0
 for item in items {
 //if a given month and year is found in expensess
 if (Calendar.current.component(.month, from: item.date!) == month) && (Calendar.current.component(.year, from: item.date!) == Int(yearStepper.value)){
 monthTotal += item.totalAmount
 //print("Calcuate method:",monthTotal)
 
 }
 
 }
 if monthTotal >= 0.0 {
 createNewSavings(monthTotal: monthTotal, date: date)
 }
 }
 return monthTotal
 
 }*/
/* add savings data.*/
/*
 func createNewSavings(monthTotal: Double, date: String) {
 let existingSavings = (self.savings?.contains{
 if ($0.date == date) {
 $0.expenditure = monthTotal
 // $0.saving = $0.earning - monthTotal
 return true
 }
 else {
 
 return false
 }
 })
 if !existingSavings! {
 let newSaving = Savings(context: self.context)
 newSaving.date = date
 newSaving.expenditure = monthTotal
 //newSaving.saving = newSaving.earning - monthTotal
 print(newSaving)
 do {
 try self.context.save()
 }
 catch {
 
 }
 self.fetchData()
 }
 
 // print(savings)
 }*/
