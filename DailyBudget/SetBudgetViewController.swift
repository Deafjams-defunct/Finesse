//
//  SetBudgetViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/25/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit
import CoreData

class SetBudgetViewController: UIViewController {

    @IBOutlet weak var budgetTextField: UITextField!
    
    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: User!
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let fetchedUsers = try self.dataContext.fetch(NSFetchRequest.init(entityName: "User")) as [User]
            if fetchedUsers.count == 1 {
                self.user = fetchedUsers.first
                
            }
            
        } catch {
            print("Failed fetching user object")
            
        }
        
        if self.user == nil {
            self.user = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.dataContext) as! User
            
        }
        
        super.init(coder: aDecoder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.user.budget > 0 {
            self.budgetTextField.text = CurrencyNumberFormatter.currencyFormatter.format(with: Int(self.user.budget))
            
        }
        
        self.view.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action: #selector(self.dismissKeyboard) )
        )
        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        
    }
    
    @IBAction func setBudgetPressed(_ sender: UIButton) {
        if self.budgetTextField.text != nil && ["$0", ""].contains(self.budgetTextField.text!) {
            let alert = UIAlertController(
                title: "Set your budget",
                message: "I can also build your budget for you below.",
                preferredStyle: .alert
            )
            
            alert.addAction(
                .init(
                    title: "Set Budget",
                    style: .default,
                    handler: { (_) in
                        self.budgetTextField.becomeFirstResponder()
                    }
                )
            )
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.user.funds -= self.user.budget
            self.user.budget = Int32(CurrencyNumberFormatter.currencyFormatter.unformat(self.budgetTextField.text!)!)
            self.user.funds += self.user.budget
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.performSegue(withIdentifier: "setBudget", sender: self)

        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "buildBudget" {
            let tabBarController = segue.destination as! UITabBarController
            tabBarController.selectedIndex = 1
            
            let navController = tabBarController.selectedViewController as! UINavigationController
            (navController.visibleViewController as! FundsTableViewController).startEditing()
            
        }
    }
    
    @IBAction func unwindToSetBudget(segue: UIStoryboardSegue) {}
    
}
