//
//  DailyExpensesViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-29.
//

import UIKit

class DailyExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        item?.descriptions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyExpense", for: indexPath) as! DailyExpenseTableViewCell
        cell.descriptionLabel.text = item!.descriptions![indexPath.row]
        cell.amountLabel.text = "$"+String(item!.amounts![indexPath.row])
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    var dateString: String?
    var item: Expense?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyExpenseTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = dateString ?? ""
        dailyExpenseTableView.delegate = self
        dailyExpenseTableView.dataSource = self
        dailyExpenseTableView.rowHeight = 70
        // Do any additional setup after loading the view.
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
