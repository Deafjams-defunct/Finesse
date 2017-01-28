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

    var income: [Transaction?]
    var expenses: [Transaction?]
    let dataSource = TransactionLabelDataSource.dataSource
    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: User!
    
    required init?(coder aDecoder: NSCoder) {
        self.income = [nil]
        self.expenses = [nil]
        
        super.init(coder: aDecoder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(startEditing))
        
        do {
            let savedTransactions = try self.dataContext.fetch(NSFetchRequest.init(entityName: "Transaction")) as! [Transaction?]
            self.income = savedTransactions.filter({$0?.type as String! == "income"})
            self.expenses = savedTransactions.filter({$0?.type as String! == "expense"})
            
            
        } catch {
            self.income = [nil]
            self.expenses = [nil]
            
        }
        
        do {
            let fetchedUsers = try self.dataContext.fetch(NSFetchRequest.init(entityName: "User")) as [User]
            if fetchedUsers.count == 1 {
                self.user = fetchedUsers.first
                
            }
            
        } catch {
            print("Failed fetching user object")
            
        }
        
        self.income.append(nil)
        self.expenses.append(nil)
        
        self.tableView.reloadData()
        
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
        if !self.isEditing {
            self.startEditing()
            self.tableView.deselectRow(
                at: IndexPath.init(item: indexPath.item, section: indexPath.section),
                animated: true
            )

            return
            
        }
        
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
                let incomeTransaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: self.dataContext) as! Transaction
                incomeTransaction.amount = 0
                incomeTransaction.type = "income"
                incomeTransaction.label = self.dataSource.label(for: indexPath)!
                
                self.income.insert(incomeTransaction, at: indexPath.item)
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            }
            
            let transactionCell = cell as! TransactionTableViewCell
            transactionCell.currencyTextField.text = CurrencyNumberFormatter.currencyFormatter.format(with: Int(self.income[indexPath.item]!.amount))
            transactionCell.transactionLabelButton.setTitle(self.income[indexPath.item]!.label, for: .normal)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            transactionCell.transactionLabelButton.setTitleColor(UIColor.black, for: .disabled)
            transactionCell.transactionLabelButton.setTitleColor(UIColor.blue, for: .normal)
            
            return transactionCell
            
        }
        else if indexPath.section == 1 {
            if self.expenses[indexPath.item] == nil {
                let expenseTransaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: self.dataContext) as! Transaction
                expenseTransaction.amount = 0
                expenseTransaction.type = "expense"
                expenseTransaction.label = self.dataSource.label(for: indexPath)!
                
                self.expenses.insert(expenseTransaction, at: indexPath.item)
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            }
            
            let transactionCell = cell as! TransactionTableViewCell
            transactionCell.currencyTextField.text = CurrencyNumberFormatter.currencyFormatter.format(with: Int(self.expenses[indexPath.item]!.amount))
            transactionCell.transactionLabelButton.setTitle(self.expenses[indexPath.item]!.label, for: .normal)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            transactionCell.transactionLabelButton.setTitleColor(UIColor.black, for: .disabled)
            transactionCell.transactionLabelButton.setTitleColor(UIColor.blue, for: .normal)
            
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
                    let incomeTransaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: self.dataContext) as! Transaction
                    incomeTransaction.amount = 0
                    incomeTransaction.type = "income"
                    incomeTransaction.label = self.dataSource.label(for: indexPath)!
                    
                    self.income.insert(incomeTransaction, at: indexPath.item)
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                }
                
            } else if indexPath.section == 1 {
                if self.expenses[indexPath.item] == nil {
                    let expenseTransaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: self.dataContext) as! Transaction
                    expenseTransaction.amount = 0
                    expenseTransaction.type = "expense"
                    expenseTransaction.label = self.dataSource.label(for: indexPath)!
                    
                    self.expenses.insert(expenseTransaction, at: indexPath.item)
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                }
                
            }
            
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
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
                self.income[editedRow.item]!.label = label
                
            } else if editedRow.section == 1 {
                self.expenses[editedRow.item]!.label = label
                
            } else {
                return
                
            }
            
            self.tableView.reloadRows(at: [editedRow], with: .automatic)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
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
    
    func startEditing() {
        self.setEditing(true, animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneEditing))
        
    }
    
    func doneEditing() {
        let budgetAmount = (self.sum(self.income) - self.sum(self.expenses)) / 30
        
        self.user.funds -= self.user.budget
        self.user.budget = Int32(budgetAmount)
        self.user.funds += self.user.budget
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.setEditing(false, animated: true)
        self.view.endEditing(true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(startEditing))
        
    }
    
    func sum(_ transactions:[Transaction?]) -> Int {
        return transactions.map { (transaction) -> Int in
            if let transaction = transaction as Transaction! {
                return Int(transaction.amount)
                
            }
            
            return 0
        }.reduce(0, +)
        
    }

    @IBAction func amountTextFieldEditingChanged(_ sender: UITextField) {
        let indexPathForRow: IndexPath? = self.tableView.indexPathForRow(
            at: sender.superview!.convert(sender.frame.origin, to: self.tableView)
        )
        
        if let number = CurrencyNumberFormatter.currencyFormatter.unformat(sender.text!) as Int! {
            if let indexPath = indexPathForRow as IndexPath! {
                if indexPath.section == 0 && self.income[indexPath.item] != nil {
                    self.income[indexPath.item]!.amount = Int32(number)
                    
                } else if indexPath.section == 1 && self.expenses[indexPath.item] != nil {
                    self.expenses[indexPath.item]!.amount = Int32(number)
                    
                }
                
            }
            
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    @IBAction func unwindToFunds(segue: UIStoryboardSegue) {}
    
}
