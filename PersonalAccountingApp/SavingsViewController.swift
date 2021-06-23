//
//  SavingsViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-20.
//

import UIKit
import CoreData
class SavingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses: [Expense]?
    var savings: [Savings]?
    var editMode: Bool = false
    var monthsTotal: [Double]?
    @IBOutlet weak var savingsTableView: UITableView!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var yearLabel: UILabel!
    @IBAction func earningsButton(_ sender: Any) {
        editMode.toggle()
        savingsTableView.setEditing(editMode, animated: true)
    }
    @IBAction func yearStepperChanged(_ sender: Any) {
        monthsTotal = []
        yearLabel.text = String(Int(yearStepper.value))
        fetchData()
        DispatchQueue.main.async {
            self.savingsTableView.reloadData()
        }
        
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAll()
        yearStepper.value = Double(Calendar.current.component(.year, from: Date()))
        savingsTableView.delegate = self
        savingsTableView.dataSource = self
        yearLabel.text = String(Calendar.current.component(.year, from: Date()))
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        monthsTotal = []
        fetchData()
        DispatchQueue.main.async {
            self.savingsTableView.reloadData()
        }
        print("View will appear")
      // deleteAll()
        print(savings)
    }
    func fetchData() {
        do {
            
            var request = NSFetchRequest<NSFetchRequestResult>()
            request = Expense.fetchRequest()
            request.returnsObjectsAsFaults = false
            self.expenses = try context.fetch(request) as! [Expense]
            request = Savings.fetchRequest()
            
            request.returnsObjectsAsFaults = false
            self.savings = try context.fetch(request) as! [Savings]
            //print(self.savings)
        }
        catch {
            print("error")
        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = savingsTableView.dequeueReusableCell(withIdentifier: "savings", for: indexPath) as! SavingsTableViewCell
        cell.monthLabel.text = getMonth(number: indexPath.row) + " " + yearLabel.text!
        if monthsTotal == nil {
            monthsTotal = [CalculateMonthTotal(month: (indexPath.row + 1),date: cell.monthLabel.text!)]
        }
        else {
            monthsTotal?.append(CalculateMonthTotal(month: (indexPath.row + 1), date: cell.monthLabel.text!))
           cell.expenditureLabel.text = "$" + String(format: "%.2f",CalculateMonthTotal(month: (indexPath.row + 1), date: cell.monthLabel.text!))
        }
       let item = getSavingsItem(date: cell.monthLabel.text!)
        cell.savingsLabel.text =  item != nil ? "$" + String(format: "%.2f",item!.saving) : "--"
        cell.earningsLabel.text = item != nil ? "$" + String(format: "%.2f",item!.earning) : "--"
        cell.savingsLabel.textColor = item?.saving ?? 0.0 >= 0.0 ? .green : .red
       
      //print(monthsTotal!)
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
    func createAlert(title:String, message:String, textField: Bool, row: Int) {
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if textField {
        alert.addTextField()
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            let amount = alert.textFields![0]
            if let earning = Double(amount.text!) {
                let date = self.getMonth(number: row) + " " + self.yearLabel.text!
                let result = self.savings?.contains {
                    if ($0.date == date) {
                        $0.earning = earning
                        $0.saving = $0.earning - $0.expenditure
                        do {
                            try self.context.save()
                        }
                        catch {
                            
                        }
                        //print($0)
                        return true
                    }
                    else {
                        return false
                    }
                    
                }
                if result! {
                    self.fetchData()
                    DispatchQueue.main.async {
                        self.savingsTableView.reloadData()
                    }
                    
                }
            }
            self.editMode = false
            self.savingsTableView.setEditing(self.editMode, animated: true)
            })
       
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func CalculateMonthTotal(month: Int, date: String) -> Double {
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
        
    }
    func deleteAll() {
        for saving in savings!
        {
            
            self.context.delete(saving)
        }
        do{
            try self.context.save()
        }
        catch {
            
        }
    }
    /* add savings data.*/
    func createNewSavings(monthTotal: Double, date: String) {
        let existingSavings = (self.savings?.contains{
            if ($0.date == date) {
                $0.expenditure = monthTotal
                $0.saving = $0.earning - monthTotal
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
            newSaving.saving = newSaving.earning - monthTotal
            print(newSaving)
            do {
                try self.context.save()
            }
            catch {
                
            }
            self.fetchData()
        }
        
       // print(savings)
    }
    func getSavingsItem(date: String) -> Savings? {
        
       let saving = (self.savings?.first(where: {
            $0.date == date
       }))
        return saving
    }
    func getMonth(number: Int) -> String {
        switch number {
            case 0:
                return "Jan"
            case 1:
                return "Feb"
            case 2:
                return "Mar"
            case 3:
                return "Apr"
            case 4:
                return "May"
            case 5:
                return "Jun"
            case 6:
                return "Jul"
            case 7:
                return "Aug"
            case 8:
                return "Sep"
            case 9:
                return "Oct"
            case 10:
                return "Nov"
            case 11:
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
