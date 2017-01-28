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
    @IBOutlet weak var budgetButton: UIButton!
    
    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let fetchedUsers = try self.dataContext.fetch(NSFetchRequest.init(entityName: "User")) as [User]
            if fetchedUsers.count == 1 {
                self.user = fetchedUsers.first
                
            }
            
        } catch {
            print("Failed catching budget")
            
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
            
            self.user.funds = self.user.funds + components.day! * Int(self.user.budget)
            
        }

        self.updateDataLabels()
        
        self.user.last_used = NSDate()
        
        self.view.addGestureRecognizer(
            UITapGestureRecognizer.init(target: self, action: #selector(self.dismissKeyboard) )
        )
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    func updateDataLabels() {
        self.budgetButton.setTitle(CurrencyNumberFormatter.currencyFormatter.format(with: Int(self.user.budget)), for: .normal)
        self.fundsLabel.text = CurrencyNumberFormatter.currencyFormatter.string(for: self.user.funds)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateDataLabels()
        
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
        if let spendingText = self.spendingTextField.text as String! {
            if !["$0", ""].contains(spendingText) {
                self.user.funds -= CurrencyNumberFormatter.currencyFormatter.unformat(spendingText)!
                
                self.updateDataLabels()
            }
            
        }
        
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}

}
