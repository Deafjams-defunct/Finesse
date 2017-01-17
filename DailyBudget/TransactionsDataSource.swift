//
//  TransactionsDataSource.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/17/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class TransactionsDataSource: NSObject {
    
    var transactions: [Dictionary<String, Any?>]
    
    override init() {
        transactions = []
        
    }

}
