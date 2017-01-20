//
//  IncomeTableViewCell.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/15/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class IncomeTableViewCell: TransactionTableViewCell {
    
    let dataSource: TransactionLabelDataSource
    
    let label: String
    
    required init?(coder aDecoder: NSCoder) {
        self.dataSource = TransactionLabelDataSource.dataSource
        self.label = self.dataSource.nextLabel(for: .income)
        
        super.init(coder: aDecoder)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.transactionLabelButton.setTitle(self.label, for: .normal)
        
    }

}
