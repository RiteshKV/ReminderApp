//
//  ReminderTableViewCell.swift
//  ReminderApp
//
//  Created by Ritesh Vishwakarma on 11/01/23.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTtile : UILabel!
    @IBOutlet weak var lblBody : UILabel!
    @IBOutlet weak var lblTime : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
