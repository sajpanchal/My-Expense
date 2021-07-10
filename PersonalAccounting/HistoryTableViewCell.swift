//
//  HistoryTableViewCell.swift
//  PersonalAccountingApp
//
//  Created by saj panchal on 2021-05-26.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
