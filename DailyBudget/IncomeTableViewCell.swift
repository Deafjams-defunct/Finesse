//
//  IncomeTableViewCell.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/15/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class IncomeTableViewCell: TransactionTableViewCell {
    
    var dataSource: TransactionLabelDataSource
    
    required init?(coder aDecoder: NSCoder) {
        self.dataSource = TransactionLabelDataSource.dataSource
        
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.transactionLabelButton.setTitle(
            self.dataSource.nextLabel(for: .income),
            for: .normal
        )
        
    }

}
