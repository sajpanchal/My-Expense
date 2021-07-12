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
    var savings: [Savings]?
    var yearlySavings: [YearlySavings]?
    var editMode: Bool = false
    var monthsTotal: [Double]?
    var yearSavings: Double?
    var yearEarnings: Double?
    var yearExpense: Double?
    @IBOutlet weak var summaryYearLabel: UILabel!
    @IBOutlet weak var savingsTableView: UITableView!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearlySavingsLbl: UILabel!
    @IBOutlet weak var yearlyExpenseLbl: UILabel!
    @IBOutlet weak var yearlyEarningsLbl: UILabel!
    
    @IBAction func earningsButton(_ sender: Any) {
        editMode.toggle()
        savingsTableView.setEditing(editMode, animated: true)
    }
    @IBAction func yearStepperChanged(_ sender: Any) {
        yearSavings = 0.0
        monthsTotal = []
        yearLabel.text = String(Int(yearStepper.value))
        summaryYearLabel.text = "Year " + String(Int(yearStepper.value)) + " " + "Summary"
        self.expenses = Expense.fetchRecords()
        fetchData()
        createSavings(year: Int(yearStepper.value))
        //self.savings = removeDuplicationsFromSavings(savings: self.savings)
        //createSavings(year: Int(yearStepper.value))
        DispatchQueue.main.async {
            self.savingsTableView.reloadData()
            print("table reloaded from year stepper.")
        }
        fetchData()
        print(savings ?? "Savings is empty")
        
        print(yearlySavings ?? "Yearly Savings is empty")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        //   monthsTotal = []
        yearStepper.value = Double(Calendar.current.component(.year, from: Date()))
       // print(savings)
        print("Before: ")
        print(savings ?? "Savings is empty")
        
        print(yearlySavings ?? "Yearly Savings is empty")
        createSavings(year: Int(yearStepper.value))
       
      //  createSavings(year: Int(yearStepper.value))
        self.expenses = Expense.fetchRecords()
        fetchData()
        DispatchQueue.main.async {
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
        print(savings ?? "Savings is empty")
        
        print(yearlySavings ?? "Yearly Savings is empty")
       /* for ys in yearlySavings! {
            print("\(ys.saving)  of year   \(ys.year) ")
            print(ys)
        }*/
       //
       
        //fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.expenditureLabel.text = "$" + String(format: "%.2f",  saving?.expenditure ?? "--")
        cell.earningsLabel.text = "$" + String(format: "%.2f",  saving?.earning ?? "--")
        cell.savingsLabel.text = "$" + String(format: "%.2f",  saving?.saving ?? "--")
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
    func fetchData() {
        print("fetch data")
        do {
                       
            let savingsRequest: NSFetchRequest<Savings> = Savings.fetchRequest()
            savingsRequest.returnsObjectsAsFaults = false
           // self.savings = try context.fetch(request) as? [Savings]
            self.savings = try AppDelegate.viewContext.fetch(savingsRequest)
            
            let yearlySavingsRequest: NSFetchRequest<YearlySavings> = YearlySavings.fetchRequest()
            yearlySavingsRequest.returnsObjectsAsFaults = false
            //self.yearlySavings = try context.fetch(request) as? [YearlySavings]
            self.yearlySavings = try AppDelegate.viewContext.fetch(yearlySavingsRequest)
        }
        catch {
            print("error")
        }
    }
    func removeDuplicationsFromSavings(savings: [Savings]?) -> [Savings]? {
       print("remove duplication method exectuted.")
        for saving in self.savings! {
            if (saving.expenditure == 0.0 && saving.earning == 0.0) {
                //self.context.delete(saving)
                AppDelegate.viewContext.delete(saving)
                print("Deleted:\(saving)")
            }
           
            do {
              //  try self.context.save()
                try AppDelegate.viewContext.save()
                print("success")
            }
            catch {
                print("NO LUCK")
            }
        }
       // print("updated savings:",self.savings)
        return savings
    }
    func removeDuplicationsFromYearlySavings(yearlySavings:[YearlySavings]?) -> [YearlySavings]? {
        
        return yearlySavings
    }
    func createSavings(year: Int) {
        fetchData()
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
            //if savings entity is not nil
            if let savings = self.savings {
                // if we have that month's data
                if !monthExpenses.isEmpty {
                    // if the entiry has a given month's data
                    if (savings.contains { saving in
                       // (saving.date?.hasSuffix(yearLabel.text!) ?? false)
                        saving.date == getMonth(number: month) + " " + yearLabel.text!
                    }){
                        let saving = self.savings?.first {
                            $0.date == getMonth(number: month) + " " + yearLabel.text!
                        }
                        saving?.expenditure = 0.0
                        for expense in monthExpenses {
                            saving?.addToDailyExpenses(expense)
                            saving?.expenditure += Double(expense.totalAmount)
                        }
                        
                        do {
                            //try self.context.save()
                            try AppDelegate.viewContext.save()
                        }
                        catch {
                            
                        }
                    }
                    else {
                        //create a saving context.
                       // let saving = Savings(context: context)
                        let saving = Savings(context: AppDelegate.viewContext)
                        if month == 10 {
                            print("expenses of sept 2021: ", self.expenses )
                        }
                        saving.date = getMonth(number: month) + " " + yearLabel.text! // set date property as a string of month and year.
                        // for each month's entry, add its copy to a given saving object.
                        for expense in monthExpenses {
                            saving.addToDailyExpenses(expense) // create a Set with a given expenses entries.
                            saving.expenditure += Double(expense.totalAmount) // set the expenditure.
                        }
                   
                        
                    }
                }
            }
            
        }
        print("after creating savings: ",self.savings ?? "savings empty")
        self.savings = removeDuplicationsFromSavings(savings: self.savings)
        createYearlySavings(year: year)
    }
    
    func filterSavings(date: String) -> Savings? {
        let saving = self.savings?.first { saving in
            saving.date == date
        }
        return saving
    }
    
    func createYearlySavings (year: Int) {
        fetchData()
        
        print("create yearly savings method called.")
        //make sure we have that year's data or exit the function.
        let filteredSavings = (self.savings?.filter { saving in
           // print("monthy savings found for year \(year). it is \(String(year)) for \(saving.date), \(saving.earning), \(saving.expenditure)")
            return ((saving.date?.hasSuffix(String(year)) ?? false))
        
            })
        if filteredSavings?.isEmpty ?? false {
            print("monthy savings not found for year \(year)")
            yearlySavingsLbl.text = "$--"
            yearlyExpenseLbl.text = "$--"
            yearlyEarningsLbl.text = "$--"
            yearlySavingsLbl.textColor = .red
            return
        }
       // print("filtered Data", filteredSavings)
        //if our yearlySavings entity contatins a given year's data
    
        if (self.yearlySavings?.contains {
            return  $0.year == year && $0.monthlySavings != nil
        }) ?? false  {
            // get that array item.
            let storedYearlySavings = self.yearlySavings?.first {
                $0.year == year
            }
            // empty out the expenditure and earnings.
            storedYearlySavings?.expenditure = 0.0
            storedYearlySavings?.earnings = 0.0
            
            // now get the monthlySavings array from that yearSavings element
          
                // accumulate the total expenditure and earnings
               for saving in filteredSavings! {
                    storedYearlySavings?.expenditure += Double(saving.expenditure)
                print("YEARLY EXPENSE: \(String(describing: storedYearlySavings?.expenditure)) FOR YEAR \(String(describing: storedYearlySavings?.year)). Saving data: \(String(describing: saving.date)), Expense: \(saving.expenditure)")
                    
                    storedYearlySavings?.earnings += Double(saving.earning)
                  //  print(storedYearlySavings?.saving ?? 0.0)
                  //  print("earnings updated to", storedYearlySavings?.earnings ?? 0.0)
                    storedYearlySavings?.year = Int64(year)
                }
           /* if let monthlySavings = storedYearlySavings?.monthlySavings {
                let array = monthlySavings.allObjects as! [Savings]
                for item in array {
                        storedYearlySavings?.expenditure += item.expenditure
                    storedYearlySavings?.earnings += item.earning
                }
            }*/
            
            DispatchQueue.main.async {
                self.yearlySavingsLbl.text = "$" + String(format: "%.2f",storedYearlySavings?.saving ?? "--")
                self.yearlyExpenseLbl.text = "$" + String(format: "%.2f",storedYearlySavings?.expenditure ?? "--")
                self.yearlyEarningsLbl.text = "$" + String(format: "%.2f",storedYearlySavings?.earnings ?? "--")
                self.yearlySavingsLbl.textColor = (storedYearlySavings?.saving ?? 0.0) > 0.0 ? .green : .red
            }
        }
        // create a new yearlySaving entry.
        else {
            //let yearlySaving = YearlySavings(context: context)
            let yearlySaving = YearlySavings(context: AppDelegate.viewContext)
            for saving in filteredSavings! {
                yearlySaving.addToMonthlySavings(saving)
                yearlySaving.expenditure += saving.expenditure
                yearlySaving.earnings += saving.earning
                print(yearlySaving.saving)
                yearlySaving.year = Int64(year)
            }
            do {
                //try self.context.save()
                try AppDelegate.viewContext.save()
            }
            catch {
                
            }
            DispatchQueue.main.async {
                self.yearlySavingsLbl.text = "$" + String(format: "%.2f",yearlySaving.saving)
                self.yearlyExpenseLbl.text = "$" + String(format: "%.2f",yearlySaving.expenditure)
                self.yearlyEarningsLbl.text = "$" + String(format: "%.2f",yearlySaving.earnings)
                self.yearlySavingsLbl.textColor = (yearlySaving.saving) > 0.0 ? .green : .red
            }
            
        }
        fetchData()
        //print("updated yearly savings: ", self.yearlySavings)
       
        
    }
    
    func createAlert(title:String, message:String, textField: Bool, row: Int) {
       fetchData()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if textField {
        alert.addTextField()
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            let amount = alert.textFields![0]
            if let earning = Double(amount.text!) {
                let date = self.getMonth(number: row+1) + " " + self.yearLabel.text!
                let result = self.savings?.contains {
                    if ($0.date == date) {
                        $0.earning = earning
                        print("earning updated for a month \(date) by ",$0.earning)
                        //$0.saving = $0.earning - $0.expenditure
                        
                        do {
//                            try self.context.save()
                            try AppDelegate.viewContext.save()
                            print("saved changes.")
                        }
                        catch {
                            print("save changes failed.")
                        }
                        //print($0)
                        return true
                    }
                    else {
                        return false
                    }
                    
                }
                // if we have the savings record having a given month and year and changes were made too.
                if result! {
                    self.fetchData()
                   // print("fetch data:",self.savings)
                    self.createYearlySavings(year: Int(self.yearLabel.text!)!)
                    DispatchQueue.main.async {
                        self.savingsTableView.reloadData()
                       
                        
                    }
                    
                }
                else {
                    
                }
            }
            self.editMode = false
            self.savingsTableView.setEditing(self.editMode, animated: true)
            })
       
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
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
            //try context.execute(batchDeleteRequest)
            //try self.context.save()
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
