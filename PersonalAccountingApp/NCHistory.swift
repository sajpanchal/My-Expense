//
//  NCHistory.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-06-05.
//

import UIKit

class NCHistory: UINavigationController {
    var entries: [Expense]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        if let history = self.topViewController as? HistoryViewController {
            history.entries = self.entries
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
