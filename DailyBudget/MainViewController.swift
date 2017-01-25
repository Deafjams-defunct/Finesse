//
//  MainViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/8/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fundsLabel: UILabel!
    @IBOutlet weak var spendingTextField: UITextField!
    
    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var budget: NSManagedObject!
    var funds: Int!
    
    required init?(coder aDecoder: NSCoder) {
        
        do {
            let fetchedBudget = try self.dataContext.fetch(NSFetchRequest.init(entityName: "Budget")) as [NSManagedObject]
            if fetchedBudget.count > 0 {
                self.budget = fetchedBudget[0]
                
            }
            
        } catch {
            print("Failed catching budget")
            
        }
        
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
        
        // self.budgetLabel.text = "+\(self.budget.value(forKey: "budget")!) per day"
        
//        if let previous_run = UserDefaults.standard.object(forKey: "lastRun") as? Date {
//            
//            let calendar = Calendar.current
//            let current_date = Date()
//            
//            let start_of_current_date = calendar.startOfDay(for: current_date)
//            let start_of_previous_run = calendar.startOfDay(for: previous_run)
//            
//
//            let components = calendar.dateComponents([.day], from: start_of_previous_run, to: start_of_current_date)
//            
//            self.funds = self.funds + components.day! * (self.budget.value(forKey: "budget") as! Int)
//            UserDefaults.standard.set(self.funds, forKey: "funds")
//        }
        
        self.fundsLabel.text = CurrencyNumberFormatter.currencyFormatter.string(for: self.funds)
        
        UserDefaults.standard.set(Date(), forKey: "lastRun")
        
        self.view.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action: #selector(self.dismissKeyboard) )
        )
        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        
    }
    
    @IBAction func spendingTextEditingChanged(_ sender: UITextField) {
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
    
    @IBAction func spendButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}

}
