//
//  FundsTableViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/12/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class FundsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBAction func unwindToFunds(segue: UIStoryboardSegue) {}
    
    var rowBeingEdited: IndexPath?

    var income: Array<[String: String]?>
    var expenses: Array<[String: String]?>
    let dataSource = TransactionLabelDataSource.dataSource
    
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
                self.income.insert(
                    [
                        "text": "$0",
                        "label": self.dataSource.label(for: indexPath)!
                    ],
                    at: indexPath.item
                )
                
            }
            
            let transactionCell = cell as! TransactionTableViewCell
            transactionCell.currencyTextField.text = self.income[indexPath.item]!["text"]
            transactionCell.transactionLabelButton.setTitle(self.income[indexPath.item]!["label"], for: .normal)
            
            return transactionCell
            
        }
        else if indexPath.section == 1 {
            if self.expenses[indexPath.item] == nil {
                self.expenses.insert(
                    [
                        "text": "$0",
                        "label": self.dataSource.label(for: indexPath)!
                    ],
                    at: indexPath.item
                )
                
            }
            
            let transactionCell = cell as! TransactionTableViewCell
            transactionCell.currencyTextField.text = self.expenses[indexPath.item]!["text"]
            transactionCell.transactionLabelButton.setTitle(self.expenses[indexPath.item]!["label"], for: .normal)
            
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
                self.income.remove(at: indexPath.item)
                
            } else if indexPath.section == 1 {
                self.expenses.remove(at: indexPath.item)
                
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } else if editingStyle == .insert {
            if indexPath.section == 0 {
                if self.income[indexPath.item] == nil {
                    self.income.insert(
                        [
                            "text": "$0",
                            "label": self.dataSource.label(for: indexPath)!
                        ],
                        at: indexPath.item
                    )
                    
                }
                
            } else if indexPath.section == 1 {
                if self.expenses[indexPath.item] == nil {
                    self.expenses.insert(
                        [
                            "text": "$0",
                            "label": self.dataSource.label(for: indexPath)!
                        ],
                        at: indexPath.item
                    )
                    
                }
                
            }
            
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
        }
        
    }
    
    @IBAction func incomeTextFieldEditingDidEnd(_ sender: UITextField) {
        let indexPath: IndexPath? = self.tableView.indexPathForRow(
            at: sender.superview!.convert(sender.frame.origin, to: self.tableView)
        )
        
        if indexPath != nil && self.income[indexPath!.item] != nil {
            self.income[indexPath!.item]!["text"] = sender.text!
            
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
                self.income[editedRow.item]!["label"] = label
                
            } else if editedRow.section == 1 {
                self.expenses[editedRow.item]!["label"] = label
                
            } else {
                return
                
            }
            
            self.tableView.reloadRows(at: [editedRow], with: .automatic)
            
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

}
