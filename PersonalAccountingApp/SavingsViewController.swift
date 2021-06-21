//
//  SavingsViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-20.
//

import UIKit

class SavingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var savingsTableView: UITableView!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var yearLabel: UILabel!
    @IBAction func earningsButton(_ sender: Any) {
    }
    @IBAction func yearStepperChanged(_ sender: Any) {
        yearLabel.text = String(Int(yearStepper.value))
        self.savingsTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        yearStepper.value = Double(Calendar.current.component(.year, from: Date()))
        savingsTableView.delegate = self
        savingsTableView.dataSource = self
        yearLabel.text = String(Calendar.current.component(.year, from: Date()))
        // Do any additional setup after loading the view.
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
        return cell
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
