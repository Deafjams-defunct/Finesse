//
//  MainViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/8/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var fundsLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var spendingLabel: UILabel!
    
    @IBOutlet weak var spendingStepper: UIStepper!
    
    let formatter: NumberFormatter!
    var budget: Int!
    var funds: Int!
    
    required init?(coder aDecoder: NSCoder) {
        self.formatter = NumberFormatter()
        self.formatter.numberStyle = NumberFormatter.Style.currency
        self.formatter.maximumFractionDigits = 0
        
        self.budget = UserDefaults.standard.integer(forKey: "budget")
        
        let funds = UserDefaults.standard.object(forKey: "funds")
        
        if funds == nil {
            self.funds = 0
            UserDefaults.standard.set(self.funds, forKey: "funds")
            
        } else {
            self.funds = UserDefaults.standard.integer(forKey: "funds")
            
        }
        
        
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.spendingLabel.text = self.formatter.string(for: self.budget)
        self.budgetLabel.text = "+\(self.formatter.string(for: self.budget)!) per day"
        
        self.spendingStepper.value = Double(self.budget)
        
        if let previous_run = UserDefaults.standard.object(forKey: "lastRun") as? Date {
            
            let calendar = Calendar.current
            let current_date = Date()
            
            let start_of_current_date = calendar.startOfDay(for: current_date)
            let start_of_previous_run = calendar.startOfDay(for: previous_run)
            

            let components = calendar.dateComponents([.day], from: start_of_previous_run, to: start_of_current_date)
            
            self.funds = self.funds + components.day! * self.budget
            UserDefaults.standard.set(self.funds, forKey: "funds")
        }
        
        self.fundsLabel.text = self.formatter.string(for: self.funds)
        
        UserDefaults.standard.set(Date(), forKey: "lastRun")
        
    }

    @IBAction func spendingStepperValueChanged(_ sender: Any) {
        spendingLabel.text = formatter.string(for: spendingStepper.value)
    }
    
    @IBAction func spendButtonTapped(_ sender: Any) {
        self.funds = self.funds - Int(spendingStepper.value)
        
        self.fundsLabel.text = self.formatter.string(for: self.funds)
        
        UserDefaults.standard.set(self.funds, forKey: "funds")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //self.budget = UserDefaults.standard.integer(forKey: "budget")

    }
    
    
    

}
