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
    
    func label(for indexPath:IndexPath) -> String? {
        if indexPath.section == 0 {
            return self.incomeLabels[indexPath.item % self.incomeLabels.count]
            
        } else if indexPath.section == 1 {
            return self.expensesLabels[indexPath.item % self.expensesLabels.count]
            
        } else {
            return nil
            
        }
        
    }
    
    func labelFromSource(for indexPath: IndexPath) -> String? {
        if indexPath.section == 0 {
            return self.incomeLabels[indexPath.item]
            
        } else if indexPath.section == 1 {
            return self.expensesLabels[indexPath.item]
            
        } else {
            return nil
            
        }
        
    }
    
    func indexPathForLabel(_ label:String) -> IndexPath? {
        if incomeLabels.contains(label) {
            return IndexPath.init(item: incomeLabels.index(of: label)!, section: 0)
            
        } else {
            return IndexPath.init(item: expensesLabels.index(of: label)!, section: 1)
            
        }
        
    }
    
    func count(forSection section: Int) -> Int {
        if section == 0 {
            return self.incomeLabels.count
            
        } else if section == 1 {
            return self.expensesLabels.count
            
        } else {
            return 0
            
        }
    
    }

}
