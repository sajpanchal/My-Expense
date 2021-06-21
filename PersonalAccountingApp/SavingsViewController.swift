//
//  SavingsViewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-20.
//

import UIKit

class SavingsViewController: UIViewController {

    
    @IBOutlet weak var savingsTableView: UITableView!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var yearLabel: UILabel!
    @IBAction func earningsButton(_ sender: Any) {
    }
    @IBAction func yearStepperChanged(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
