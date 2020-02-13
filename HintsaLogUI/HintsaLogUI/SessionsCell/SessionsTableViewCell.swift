//
//  SessionsTableViewCell.swift
//  HintsaLogUI
//
//  Created by Tewodros Mengesha on 13.2.2020.
//  Copyright © 2020 Tewodros Mengesha. All rights reserved.
//

import UIKit

class SessionsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblWeekDay: UILabel!
    @IBOutlet weak var lblWeekDate: UILabel!
    @IBOutlet weak var lblFullDate: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCatagory: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
