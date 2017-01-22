//
//  CurrencyTextFieldDelegate.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/16/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class CurrencyTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text as String! {
            let currentTextIsMaxLength: Bool = currentText.characters.count == 10
            let replacementIsDelete: Bool = string == ""
            
            if (currentTextIsMaxLength && !replacementIsDelete) {
                return false
                
            }
            
        }
        
        return true
        
    }

}
