//
//  TransactionLabelDataSource.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/16/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class TransactionLabelDataSource: NSObject {
    
    static let dataSource = TransactionLabelDataSource()
    
    override private init() {}
    
    enum TransactionLabel {
        case income
        case expenses
    }
    
    var incomeLabels = [
        "Paycheck",
        "Bonus",
        "Interest",
        "Other"
    ]
    
    var expensesLabels = [
        "Rent",
        "Mortgage",
        "Utilities",
        "Car",
        "Loan",
        "Other"
    ]
    
    var incomeIndex = 0
    var expensesIndex = 0
    
    func nextLabel(for transactionLabel: TransactionLabel) -> String {
        if transactionLabel == .income {
            let nextLabel = self.incomeLabels[self.incomeIndex]
            self.incomeIndex = (self.incomeIndex + 1) % self.incomeLabels.count
            
            return nextLabel
            
        } else if transactionLabel == .expenses {
            let nextLabel = self.expensesLabels[self.expensesIndex]
            self.expensesIndex = (self.expensesIndex + 1) % self.expensesLabels.count
            
            return nextLabel
            
        } else {
            return ""
            
        }
        
    }

}
