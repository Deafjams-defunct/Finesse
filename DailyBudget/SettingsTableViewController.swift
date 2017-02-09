//
//  SettingsTableViewController.swift
//  Finesse
//
//  Created by Emma Foster on 1/30/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsTableViewController: UITableViewController {
    
    let notifications = FinesseNotifications.shared
    
    var showEveningDatePicker: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notifications.authorized(completionHandler: parseNotificationSettings)
        
    }
    
    func parseNotificationSettings(settings: UNNotificationSettings) {
        self.notifications.toggleEveningSpendingNotification(settings.authorizationStatus == .authorized)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            var numberOfRows = 1
            if self.showEveningDatePicker {
                numberOfRows += 1
                
            }
            
            return numberOfRows
            
        } else if section == 1 {
            return 2
            
        } else {
            return 0
            
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseIdentifier: String!
        
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                reuseIdentifier = "eveningSpendingCell"
                
            } else if indexPath.item == 1 && self.showEveningDatePicker {
                reuseIdentifier = "eveningSpendingDatePickerCell"
                
            }
            
        } else if indexPath.section == 1 {
            if indexPath.item == 0 {
                reuseIdentifier = "aboutAuthor"
                
            } else if indexPath.item == 1 {
                reuseIdentifier = "aboutVersion"
                
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        if cell.reuseIdentifier == "aboutVersion" {
            cell.detailTextLabel?.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String?
            
        } else if cell.reuseIdentifier == "eveningSpendingDatePickerCell" {
            let datePickerCell = cell as! DatePickerTableViewCell
            
            datePickerCell.datePicker.setDate(self.notifications.eveningSpendingNotification.time! as Date, animated: true)
            
        } else if cell.reuseIdentifier == "eveningSpendingCell" {
            let eveningSpendingCell = cell as! EveningSpendingTableViewCell
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mma"
            
            eveningSpendingCell.timeLabel.text = formatter.string(from: self.notifications.eveningSpendingNotification.time! as Date)
            eveningSpendingCell.toggle.setOn(self.notifications.eveningSpendingNotification.enabled, animated: true)
            
        }

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.item == 0 {
            return CGFloat(integerLiteral: 66)
            
        } else if indexPath.section == 0 && indexPath.item == 1 && self.showEveningDatePicker {
            return CGFloat(integerLiteral: 159)
            
        } else if indexPath.section == 1 {
            return CGFloat(integerLiteral: 46)
            
        } else {
            return CGFloat()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Reminders"
            
        } else if section == 1 {
            return "About"
            
        } else {
            return nil
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.item == 0 {
            self.showEveningDatePicker = !self.showEveningDatePicker
            
            self.tableView.reloadSections(IndexSet.init(integer: .init(0)), with: .automatic)
            
        }
        
        self.tableView.deselectRow(
            at: IndexPath.init(item: indexPath.item, section: indexPath.section),
            animated: true
        )
    }
    
    @IBAction func morningBudgetSwitchToggled(_ sender: UISwitch) {
        // self.notifications.toggleMorningBudgetNotification(sender.isOn)
        
    }
    
    @IBAction func eveningSpendingSwitchToggled(_ sender: UISwitch) {
        self.notifications.toggleEveningSpendingNotification(sender.isOn)
        
    }

    @IBAction func eveningSpendingDatePickerValueChanged(_ sender: UIDatePicker) {
        self.notifications.eveningSpendingNotification.time = sender.date as NSDate
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.tableView.reloadRows(at: [.init(item: 0, section: 0)], with: .automatic)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
