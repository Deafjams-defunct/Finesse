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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        currencyTextField.becomeFirstResponder()
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        transactionLabelButton.isEnabled = editing
        currencyTextField.isEnabled = editing
        
    }
    
    @IBAction func incomeTextFieldEditingChanged(_ sender: UITextField) {
        if let originalText = sender.text as String! {
            if let formattedText = CurrencyNumberFormatter.currencyFormatter.format(originalText) as String! {
                sender.text = formattedText
                
            } else {
                sender.text = "$0"
                
            }
            
        } else {
            sender.text = "$0"
            
        }
        
    }

}
