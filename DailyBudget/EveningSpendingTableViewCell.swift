//
//  EveningSpendingTableViewCell.swift
//  Finesse
//
//  Created by Emma Foster on 1/31/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class EveningSpendingTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
