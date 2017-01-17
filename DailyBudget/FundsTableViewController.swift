//
//  FundsTableViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/12/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class FundsTableViewController: UITableViewController {

    var income: Array<UITableViewCell>
    var expenses: Array<UITableViewCell>
    
    
    required init?(coder aDecoder: NSCoder) {
        self.income = Array<UITableViewCell>()
        self.expenses = Array<UITableViewCell>()
        
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        // #warning Incomplete implementation, return the number of rows
        var rowCount = 1
        
        if section == 0 {
            rowCount += self.income.count
            
        } else if section == 1 {
            rowCount += self.expenses.count
            
        }
        
        return rowCount
        
    }
    
    func firstCellForIndex(_ indexPath:IndexPath) -> Bool {
        let firstIncomeCell = (indexPath.section == 0) && (self.income.count == indexPath.item)
        let firstExpenseCell = (indexPath.section == 1) && (self.expenses.count == indexPath.item)
        
        return firstIncomeCell || firstExpenseCell
        
    }
    
    func identifierForIndex(_ indexPath:IndexPath) -> String {
        if (self.firstCellForIndex(indexPath)) {
            if (indexPath.section == 0) {
                return "addIncomeCell"
                
            } else {
                return "addExpenseCell"
                
            }
            
        } else {
            if (indexPath.section == 0) {
                return "incomeCell"
                
            } else {
                return "expenseCell"
                
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: self.identifierForIndex(indexPath))!
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (self.firstCellForIndex(indexPath)) {
            return .insert
            
        } else {
            return .delete
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if (indexPath.section == 0) {
                self.income.remove(at: indexPath.item)
                
            } else if (indexPath.section == 1) {
                self.expenses.remove(at: indexPath.item)
                
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            let cell = self.tableView(tableView, cellForRowAt: indexPath)
            // let cell = self.tableView.cellForRow(at: indexPath)!
            
            if indexPath.section == 0 {
                self.income.append(cell)
                
            } else if indexPath.section == 1 {
                self.expenses.append(cell)
                
            }
            
            self.tableView.insertRows(at: [indexPath], with: .bottom)
            // self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            // self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }
        
    }

}
