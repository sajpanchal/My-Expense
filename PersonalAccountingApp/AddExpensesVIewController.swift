//
//  AddExpensesVIewController.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-23.
//

import UIKit

class AddExpensesVIewController: UIViewController {
    var dateString: String? = ""
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var location: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = dateString
        // Do any additional setup after loading the view.
    }
    @IBAction func addAnotherButton(_ sender: Any) {
    }
    @IBAction func doneButton(_ sender: Any) {
        print("""
            \(desc.text!)
            \(amount.text!)
            \(location.text!)
            """)
    }
    
    @IBAction func discardChanges(_ sender: Any) {
        desc.text = ""
        amount.text = ""
        location.text = ""
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
