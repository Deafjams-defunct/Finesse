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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
