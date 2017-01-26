//
//  SetBudgetViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/25/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class SetBudgetViewController: UIViewController {

    @IBOutlet weak var budgetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action: #selector(self.dismissKeyboard) )
        )
        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        
    }
    
    @IBAction func setBudgetPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "setBudget", sender: self)
        
    }
    
    @IBAction func buildBudgetPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "buildBudget", sender: self)
        
    }
    
    @IBAction func budgetTextEditingChanged(_ sender: UITextField) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "setBudget" {
            print("set budget")
            
        } else if segue.identifier == "buildBudget" {
            print ("build budget")
            
        }
        
    }
    
    @IBAction func unwindToSetBudget(segue: UIStoryboardSegue) {}
    
}
