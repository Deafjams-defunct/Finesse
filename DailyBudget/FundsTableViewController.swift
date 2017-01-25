//
//  FundsTableViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/12/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit
import CoreData

class FundsTableViewController: UITableViewController, UITextFieldDelegate {
    
    var rowBeingEdited: IndexPath?

    var income: [NSManagedObject?]
    var expenses: [NSManagedObject?]
    let dataSource = TransactionLabelDataSource.dataSource
    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    required init?(coder aDecoder: NSCoder) {
        self.income = [nil]
        self.expenses = [nil]
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        self.setEditing(true, animated: true)
        
        do {
            let savedTransactions = try self.dataContext.fetch(NSFetchRequest.init(entityName: "Transaction")) as [NSManagedObject]
            self.income = savedTransactions.filter({$0.value(forKey: "type") as! String == "income"})
            self.expenses = savedTransactions.filter({$0.value(forKey: "type") as! String == "expense"})
            
            
        } catch {
            self.income = [nil]
            self.expenses = [nil]
            
        }
        
        self.income.append(nil)
        self.expenses.append(nil)
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.income.count
            
        } else if section == 1 {
            return self.expenses.count
            
        } else {
            return 0
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Income"
            
        } else if section == 1 {
            return "Expenses"
            
        } else {
            return nil
            
        }
    }
    
    func firstCellForIndex(_ indexPath:IndexPath) -> Bool {
        let firstIncomeCell = indexPath.section == 0 && self.income.count == indexPath.item
        let firstExpenseCell = indexPath.section == 1 && self.expenses.count == indexPath.item
        
        return firstIncomeCell || firstExpenseCell
        
    }
    
    func reuseIdentifier(for indexPath:IndexPath) -> String? {
        if indexPath.section == 0 {
            if self.income[indexPath.item] == nil {
                return "addIncomeCell"
                
            } else {
                return "transactionCell"
                
            }
            
        } else if indexPath.section == 1 {
            if self.expenses[indexPath.item] == nil {
                return "addExpenseCell"
                
            } else {
                return "transactionCell"
                
            }
            
        } else {
            return nil
            
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastIncomeRow = indexPath.section == 0 && self.income[indexPath.item] == nil
        let lastExpensesRow = indexPath.section == 1 && self.expenses[indexPath.item] == nil
        
        if lastIncomeRow || lastExpensesRow {
            self.tableView(self.tableView, commit: .insert, forRowAt: indexPath)
            self.tableView.deselectRow(
                at: IndexPath.init(item: indexPath.item + 1, section: indexPath.section),
                animated: true
            )
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier(for: indexPath)!, for: indexPath)
        
        if ["addIncomeCell", "addExpenseCell"].contains(cell.reuseIdentifier!) {
            return cell
            
        }
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            if self.income[indexPath.item] == nil {
                let incomeTransaction = NSManagedObject.init(
                    entity: NSEntityDescription.entity(forEntityName: "Transaction", in: self.dataContext)!,
                    insertInto: self.dataContext
                )
                
                incomeTransaction.setValuesForKeys(
                    [
                        "amount": "$0",
                        "type": "income",
                        "label": self.dataSource.label(for: indexPath)!
                    ]
                )
                self.dataContext.insert(incomeTransaction)
                self.income.insert(incomeTransaction, at: indexPath.item)
                
            }
            
            let transactionCell = cell as! TransactionTableViewCell
            transactionCell.currencyTextField.text = self.income[indexPath.item]!.value(forKey: "amount") as? String
            transactionCell.transactionLabelButton.setTitle(self.income[indexPath.item]!.value(forKey: "label") as? String, for: .normal)
            
            do {
                try self.dataContext.save()
                
            } catch let error as NSError {
                print("Could not save with error \(error)")
                
            }
            
            return transactionCell
            
        }
        else if indexPath.section == 1 {
            if self.expenses[indexPath.item] == nil {
                let expenseTransaction = NSManagedObject.init(
                    entity: NSEntityDescription.entity(forEntityName: "Transaction", in: self.dataContext)!,
                    insertInto: self.dataContext
                )
                
                expenseTransaction.setValuesForKeys(
                    [
                        "amount": "$0",
                        "type": "expense",
                        "label": self.dataSource.label(for: indexPath)!
                    ]
                )
                self.dataContext.insert(expenseTransaction)
                self.expenses.insert(expenseTransaction, at: indexPath.item)
                
            }
            
            let transactionCell = cell as! TransactionTableViewCell
            transactionCell.currencyTextField.text = self.expenses[indexPath.item]!.value(forKey: "amount") as? String
            transactionCell.transactionLabelButton.setTitle(self.expenses[indexPath.item]!.value(forKey: "label") as? String, for: .normal)
            
            do {
                try self.dataContext.save()
                
            } catch let error as NSError {
                print("Could not save with error \(error)")
                
            }
            
            return transactionCell
            
        }

        return cell

    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            if self.income[indexPath.item] == nil {
                return .insert
                
            } else {
                return .delete
                
            }
            
        } else if indexPath.section == 1 {
            if self.expenses[indexPath.item] == nil {
                return .insert
                
            } else {
                return .delete
                
            }
        } else {
            return .none
            
        }

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                self.dataContext.delete(self.income[indexPath.item]!)
                
                self.income.remove(at: indexPath.item)
                
            } else if indexPath.section == 1 {
                self.dataContext.delete(self.expenses[indexPath.item]!)
                
                self.expenses.remove(at: indexPath.item)
                
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        } else if editingStyle == .insert {
            if indexPath.section == 0 {
                if self.income[indexPath.item] == nil {
                    let incomeTransaction = NSManagedObject.init(
                        entity: NSEntityDescription.entity(forEntityName: "Transaction", in: self.dataContext)!,
                        insertInto: self.dataContext
                    )
                    
                    incomeTransaction.setValuesForKeys(
                        [
                            "amount": "$0",
                            "type": "income",
                            "label": self.dataSource.label(for: indexPath)!
                        ]
                    )
                    self.dataContext.insert(incomeTransaction)
                    self.income.insert(incomeTransaction, at: indexPath.item)
                    
                }
                
            } else if indexPath.section == 1 {
                if self.expenses[indexPath.item] == nil {
                    let expenseTransaction = NSManagedObject.init(
                        entity: NSEntityDescription.entity(forEntityName: "Transaction", in: self.dataContext)!,
                        insertInto: self.dataContext
                    )
                    
                    expenseTransaction.setValuesForKeys(
                        [
                            "amount": "$0",
                            "type": "expense",
                            "label": self.dataSource.label(for: indexPath)!
                        ]
                    )
                    self.dataContext.insert(expenseTransaction)
                    self.expenses.insert(expenseTransaction, at: indexPath.item)
                    
                }
                
            }
            
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
        }
        
        do {
            try self.dataContext.save()
            
        } catch let error as NSError {
            print("Could not save with error \(error)")
            
        }
        
    }
    
    @IBAction func labelButtonTapped(_ sender: UIButton) {
        let indexPath: IndexPath? = self.tableView.indexPathForRow(
            at: sender.superview!.convert(sender.frame.origin, to: self.tableView)
        )
        
        if indexPath != nil {
            self.rowBeingEdited = indexPath
            
        }
        
    }
    
    func setLabelForRowBeingEdited(_ label: String) {
        if let editedRow = self.rowBeingEdited as IndexPath! {
            if editedRow.section == 0 {
                self.income[editedRow.item]!.setValue(label, forKey: "label")
                
            } else if editedRow.section == 1 {
                self.expenses[editedRow.item]!.setValue(label, forKey: "label")
                
            } else {
                return
                
            }
            
            self.tableView.reloadRows(at: [editedRow], with: .automatic)
            
            do {
                try self.dataContext.save()
                
            } catch let error as NSError {
                print("Could not save with error \(error)")
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "labelSegue" {
            let labelsTableViewController = (segue.destination as! UINavigationController).visibleViewController as! LabelsTableViewController
            labelsTableViewController.selectedLabel = (sender as! UIButton).titleLabel?.text!
            
            let senderButton = sender as! UIButton
            let indexPath: IndexPath? = self.tableView.indexPathForRow(
                at: senderButton.superview!.convert(senderButton.frame.origin, to: self.tableView)
            )
            
            labelsTableViewController.selectedSection = indexPath?.section
            
        }
        
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        
        let budgetAmount = (self.sum(self.income) - self.sum(self.expenses)) / 30
        
        var budget: NSManagedObject? = nil
        
        do {
            let fetchedBudget = try self.dataContext.fetch(NSFetchRequest.init(entityName: "Budget")) as [NSManagedObject]
            if fetchedBudget.count > 0 {
                budget = fetchedBudget[0]
                
            }
            
        } catch {
            print("Failed catching budget")
            
        }
        
        if budget == nil {
            budget = NSManagedObject.init(
                entity: NSEntityDescription.entity(forEntityName: "Budget", in: self.dataContext)!,
                insertInto: self.dataContext
            )
            
            budget!.setValue(budgetAmount, forKey: "budget")
            self.dataContext.insert(budget!)
            
        } else {
            budget!.setValue(budgetAmount, forKey: "budget")
            
        }

        do {
            try self.dataContext.save()
            
        } catch let error as NSError {
            print("Could not save with error \(error)")
            
        }
        
        self.performSegue(withIdentifier: "unwindToMain", sender: self)

    }
    
    func sum(_ transactions:[NSManagedObject?]) -> Int {
        return transactions.map { (transaction) -> Int in
            if transaction != nil {
                return self.unformatCurrencyString(transaction!.value(forKey: "amount") as! String)
                
            }
            
            return 0
        }.reduce(0, +)
        
    }
    
    func unformatCurrencyString(_ formattedString: String) -> Int {
        return Int(formattedString.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: ""))!
        
    }

    @IBAction func amountTextFieldEditingChanged(_ sender: UITextField) {
        let indexPath: IndexPath? = self.tableView.indexPathForRow(
            at: sender.superview!.convert(sender.frame.origin, to: self.tableView)
        )
        
        if indexPath != nil && indexPath!.section == 0 && self.income[indexPath!.item] != nil {
            self.income[indexPath!.item]!.setValue(sender.text!, forKey: "amount")
            
        } else if indexPath != nil && indexPath!.section == 1 && self.expenses[indexPath!.item] != nil {
            self.expenses[indexPath!.item]!.setValue(sender.text!, forKey: "amount")
            
        }
        
        do {
            try self.dataContext.save()
            
        } catch let error as NSError {
            print("Could not save with error \(error)")
            
        }
        
    }
    
    @IBAction func unwindToFunds(segue: UIStoryboardSegue) {}
    
}
