//
//  CurrencyNumberFormatter.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/25/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class CurrencyNumberFormatter: NumberFormatter {
    
    static let currencyFormatter = CurrencyNumberFormatter.init()
    
    override init() {
        super.init()
        self.numberStyle = .currency
        self.maximumFractionDigits = 0
        self.maximumIntegerDigits = 7
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.numberStyle = .currency
        self.maximumFractionDigits = 0
        self.maximumIntegerDigits = 7
        
    }
    
    func format(_ text:String) -> String? {
        let normalizedText = text.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
        
        if let textAsInt = Int(normalizedText) as Int! {
            return self.string(for: textAsInt)
            
        }
        
        return nil
        
    }
    
    func format(with text:Int) -> String? {
        return self.string(for: text)
        
    }
    
    func unformat(_ text: String) -> Int? {
        let normalizedText = text.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")
        
        if let number = Int(normalizedText) as Int! {
            return number
            
        }
        
        return nil
        
    }

}
