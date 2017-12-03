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
    @IBOutlet weak var budgetText: UITextField!
    
    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: User!
    
    var previousBudget:Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let fetchedUsers = try self.dataContext.fetch(NSFetchRequest.init(entityName: "User")) as [User]
            if fetchedUsers.count == 1 {
                self.user = fetchedUsers.first
                
            }
            
        } catch {
            print("Failed fetching user")
            
        }
        
        if self.user == nil {
            self.user = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.dataContext) as! User
            
        }
        
        let previousRun = self.user.last_used as Date?
        
        if previousRun != nil {
            let calendar = Calendar.current
            let currentDate = Date()
            
            let startOfCurrentDate = calendar.startOfDay(for: currentDate)
            let startOfPreviousRunDate = calendar.startOfDay(for: previousRun!)
            
            
            let components = calendar.dateComponents([.day], from: startOfPreviousRunDate, to: startOfCurrentDate)
            
            self.user.funds += Int32(components.day!) * Int32(self.user.budget)
            
        }

        self.updateDataLabels()
        
        self.user.last_used = Date()
        
        
        self.view.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action: #selector(self.dismissKeyboard))
        )
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    func updateDataLabels() {
        self.budgetText.text = CurrencyNumberFormatter.currencyFormatter.string(for: self.user.budget)
        self.fundsLabel.text = CurrencyNumberFormatter.currencyFormatter.string(for: self.user.funds)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateDataLabels()
        
    }
    
    @objc func dismissKeyboard() {
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
    
    func unsetBudgetAlert() {
        let alert = UIAlertController(
            title: "Set your budget",
            message: "I can also build your budget for you below.",
            preferredStyle: .alert
        )
        
        alert.addAction(
            .init(
                title: "Set Budget",
                style: .default,
                handler: { (_) in self.budgetText.becomeFirstResponder() }
            )
        )
        
        self.present(alert, animated: true, completion: nil)
        
        self.budgetText.text = CurrencyNumberFormatter.currencyFormatter.format(with: self.previousBudget)
        
    }
    
    @IBAction func budgetTextEditingDidEnd(_ sender: UITextField) {
        if sender.text != nil && ["$0", ""].contains(sender.text!) {
            self.unsetBudgetAlert()
            
            
        } else {
            self.user.funds -= self.user.budget
            self.user.budget = Int32(CurrencyNumberFormatter.currencyFormatter.unformat(sender.text!)!)
            self.user.funds += self.user.budget
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.updateDataLabels()
            
        }

        
    }
    @IBAction func budgetTextEditingDidBegin(_ sender: UITextField) {
        self.previousBudget = CurrencyNumberFormatter.currencyFormatter.unformat(sender.text!)
        
    }
    
    @IBAction func spendButtonTapped(_ sender: Any) {
        if let spendingText = self.spendingTextField.text as String! {
            if !["$0", ""].contains(spendingText) {
                let amount = CurrencyNumberFormatter.currencyFormatter.unformat(spendingText)!
                
                let transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: self.dataContext) as! Transaction
                transaction.type = "Spending"
                transaction.label = "Transaction"
                transaction.amount = Int32(amount)
                transaction.time = Date()
                
                self.user.funds -= Int32(amount)
                
                self.updateDataLabels()
                
            }
            
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.spendingTextField.text = ""
        
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}

}
