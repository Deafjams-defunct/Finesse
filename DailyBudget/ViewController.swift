//
//  ViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/8/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if UserDefaults.standard.object(forKey: "budget") == nil {
            UserDefaults.standard.set(30, forKey: "budget")
            
        }
        
        stepper.value = UserDefaults.standard.double(forKey: "budget")
        stepperValueChanged(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stepperValueChanged(_ sender: Any) {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.maximumFractionDigits = 0
        
        moneyLabel.text = formatter.string(for: stepper.value)
    }

    @IBAction func budgetComplete() {
        UserDefaults.standard.set(stepper.value, forKey: "budget")
        
    }
}

