//
//  HistoryViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-26.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let year = Calendar.current.component(.year, from: Date())
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthStepper: UIStepper!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var historyTableView: UITableView!
    var leapYear: Bool {
        let year = Int(yearStepper.value)
        if (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) {
            return true
        }
        else {
            return false
        }
    }
    /* method to update month on stepper value change */
    @IBAction func monthStepperChanged(_ sender: Any) {
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
        historyTableView.reloadData()
    }
    /* method to update the year on stepper value change.*/
    @IBAction func yearStepperChanged(_ sender: Any) {
        yearLabel.text = String(Int(yearStepper.value))
        historyTableView.reloadData()
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath) as! HistoryTableViewCell
        cell.dayLabel.text = String(indexPath.row+1)
        cell.amountLabel.text = "$100.0"
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.rowHeight = 90        // Do any additional setup after loading the view.
        yearStepper.value = Double(year)
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
