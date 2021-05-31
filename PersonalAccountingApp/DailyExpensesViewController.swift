//
//  DailyExpensesViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-29.
//

import UIKit

class DailyExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dateString: String?
    var item: Expense?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyExpenseTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //this method loads whenever our view is about to be appear.
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.dateLabel.text = self.dateString ?? ""
            self.dailyExpenseTableView.delegate = self
            self.dailyExpenseTableView.dataSource = self
            self.dailyExpenseTableView.rowHeight = 70
            self.dailyExpenseTableView.reloadData()
        }
        
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
