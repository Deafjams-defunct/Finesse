//
//  TransactionTableViewCell.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/16/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionLabelButton: UIButton!
    @IBOutlet weak var currencyTextField: UITextField!
    
    let formatter: NumberFormatter
    
    required init?(coder aDecoder: NSCoder) {
        self.formatter = NumberFormatter()
        self.formatter.numberStyle = .currency
        self.formatter.maximumFractionDigits = 0
        self.formatter.maximumIntegerDigits = 7
        
        super.init(coder: aDecoder)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        currencyTextField.becomeFirstResponder()
        
    }
    
    @IBAction func incomeTextFieldEditingChanged(_ sender: UITextField) {
        if var originalText = sender.text as String! {
            originalText = originalText.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
            
            if let originalAsInt = Int(originalText) as Int! {
                let formattedText: String? = self.formatter.string(from: NSNumber(value: originalAsInt))
                sender.text = formattedText
                
            } else {
                sender.text = "$0"
                
            }
            
        }
        
    }

}
