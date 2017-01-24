//
//  LabelsTableViewController.swift
//  DailyBudget
//
//  Created by Emma Foster on 1/21/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit

class LabelsTableViewController: UITableViewController {
    
    let dataSource = TransactionLabelDataSource.dataSource
    var selectedSection: Int?
    var selectedLabel: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count(forSection: self.selectedSection!)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)

        // Configure the cell...
        let label = self.dataSource.labelFromSource(for: IndexPath.init(item: indexPath.item, section: self.selectedSection!))
        cell.textLabel?.text = label
        
        if label == self.selectedLabel {
            cell.accessoryType = .checkmark
            
        } else {
            cell.accessoryType = .none
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousSelection = self.selectedLabel
        self.selectedLabel = self.dataSource.labelFromSource(for: IndexPath.init(item: indexPath.item, section: self.selectedSection!))
        
        var reloadRows = [indexPath]
        if previousSelection != nil {
            let previousIndex = self.dataSource.indexPathForLabel(previousSelection!)!
            reloadRows.append(IndexPath.init(item: previousIndex.item, section: 0))
            
        }
        self.tableView.reloadRows(at: reloadRows, with: .automatic)
        
        self.performSegue(withIdentifier: "unwindToFunds", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToFunds" {
            let fundsTableViewController = segue.destination as! FundsTableViewController
            fundsTableViewController.setLabelForRowBeingEdited(self.selectedLabel!)
            
        }

    }
    
    
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToFundsCancel", sender: self)
        
    }

}
