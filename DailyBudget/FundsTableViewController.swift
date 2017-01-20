//
//  FundsTableViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/12/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class FundsTableViewController: UITableViewController, UITextFieldDelegate{

    var income = Array<[String: String]?>()
    var expenses = Array<[String: String]?>()
    
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
        var rowCount = 1
        
        if section == 0 {
            rowCount += self.income.count
            
        } else if section == 1 {
            rowCount += self.expenses.count
            
        }
        
        return rowCount
        
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
    
    func identifierForIndex(_ indexPath:IndexPath) -> String {
        if indexPath.section == 0 {
            if indexPath.item == self.income.count {
                return "addIncomeCell"
                
            } else {
                return "incomeCell"
                
            }
            
        } else {
            if  indexPath.item == self.expenses.count {
                return "addExpenseCell"
                
            } else {
                return "expenseCell"
                
            }
            
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.identifierForIndex(indexPath))!
        
        if indexPath.section == 0 {
            if indexPath.item < self.income.count {
                let transactionCell = cell as! IncomeTableViewCell
                transactionCell.currencyTextField.text = self.income[indexPath.item]!["text"]
                transactionCell.transactionLabelButton.titleLabel?.text = self.income[indexPath.item]!["label"]
                
            } else {
                cell.selectionStyle = .none
                
            }
            
        } else if indexPath.section == 1 {
            if indexPath.item < self.expenses.count {
                let transactionCell = cell as! ExpenseTableViewCell
                transactionCell.currencyTextField.text = self.expenses[indexPath.item]!["text"]
                transactionCell.transactionLabelButton.titleLabel?.text = self.expenses[indexPath.item]!["label"]
                
            } else {
                cell.selectionStyle = .none
                
            }
            
        }

        return cell

    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0 {
            if indexPath.item == self.income.count {
                return .insert
                
            } else {
                return .delete
                
            }
            
        } else if indexPath.section == 1 {
            if  indexPath.item == self.expenses.count {
                return .insert
                
            } else {
                return .delete
                
            }
            
        }
        
        return .none

    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if indexPath.section == 0 {
                self.income.remove(at: indexPath.item)
                
            } else if indexPath.section == 1 {
                self.expenses.remove(at: indexPath.item)
                
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            if indexPath.section == 0 {
                self.income.append(
                    [
                        "text": "$0",
                        "label": "Hello World"
                    ]
                )
                
            } else {
                self.expenses.append(
                    [
                        "text": "$0",
                        "label": "Hello World"
                    ]
                )
                
            }
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .bottom)
            self.tableView.endUpdates()
            
        }
        
    }
    
    @IBAction func incomeTextFieldEditingDidEnd(_ sender: UITextField) {
        let indexPath = self.tableView.indexPathForRow(
            at: sender.superview!.convert(sender.frame.origin, to: self.tableView)
            )!
    
        self.income[indexPath.item] = [
            "text": sender.text!,
            "label": "hello world"
        ]
        print(self.income)
        
    }

}
