//
//  FinesseNotifications.swift
//  Finesse
//
//  Created by Emma Foster on 2/6/17.
//  Copyright © 2017 Emma Foster. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import UserNotifications

class FinesseNotifications: NSObject {
    
    static let shared = FinesseNotifications()
    
    let center = UNUserNotificationCenter.current()
    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var eveningSpendingNotification: FINNotification!
    
    override init() {
        do {
            let notifications = try self.dataContext.fetch(NSFetchRequest.init(entityName: "FINNotification")) as [FINNotification]
            
            if notifications.count == 0 {
                self.eveningSpendingNotification = NSEntityDescription.insertNewObject(forEntityName: "FINNotification", into: self.dataContext) as! FINNotification
                
                self.eveningSpendingNotification.enabled = false
                self.eveningSpendingNotification.name = "eveningSpending"
                
                var notificationTime = DateComponents()
                notificationTime.hour = 20
                notificationTime.minute = 0
                self.eveningSpendingNotification!.time = Calendar.current.date(from: notificationTime)
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            } else {
                for notification in notifications {
                    if notification.name == "eveningSpending" {
                        self.eveningSpendingNotification = notification
                        
                    }
                    
                }
                
            }
            
        } catch {
            print("Failed fetching notification objects")
            
        }
        
        super.init()
        
    }
    
    func sendNotification(with title:String, body:String, identifier:String) {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.body = body
        notification.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
        
        self.center.add(request) { (error) in
            if let error = error {
                print(error)
                
            }
            
        }
        
    }
    
    func authorizeNotifications() {
        self.center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                self.setupNotifications()
                return
                
            }
            
            if let anError = error {
                print(anError)
                
            }
            
        }
        
    }
    
//    func toggleMorningBudgetNotification(_ enabled:Bool) {
//        if enabled {
//            var user: User!
//            
//            do {
//                let fetchedUsers = try self.dataContext.fetch(NSFetchRequest.init(entityName: "User")) as [User]
//                if fetchedUsers.count == 1 {
//                    user = fetchedUsers.first!
//                    
//                }
//                
//            } catch {
//                print("Failed fetching user")
//                
//            }
//            
//            let notification = UNMutableNotificationContent()
//            notification.title = "Budget for Today"
//            notification.body = "You have \(CurrencyNumberFormatter.currencyFormatter.format(with: Int(user.funds))) available today"
//            notification.sound = UNNotificationSound.default()
//            
//            var date = DateComponents()
//            date.hour = 8
//            
//            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//            let request = UNNotificationRequest(identifier: "morningBudget", content: notification, trigger: trigger)
//            
//            self.center.add(request, withCompletionHandler: nil)
//            
//        } else {
//            self.center.removePendingNotificationRequests(withIdentifiers: ["morningBudget"])
//            
//        }
//        
//    }
    
    func toggleEveningSpendingNotification(_ enabled:Bool) {
        self.eveningSpendingNotification.enabled = enabled
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        if enabled {
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.eveningSpendingNotification.time! as Date)
            
            let notification = UNMutableNotificationContent()
            notification.title = "What did you spend today?"
            notification.body = "Record today's spending before the day is over!"
            notification.sound = UNNotificationSound.default()
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "eveningSpending", content: notification, trigger: trigger)
            
            self.center.add(request, withCompletionHandler: nil)
            
        } else {
            self.center.removePendingNotificationRequests(withIdentifiers: ["eveningSpending"])
            
        }
        
    }
    
    func setupNotifications() {
        // self.toggleMorningBudgetNotification(true)
        self.toggleEveningSpendingNotification(true)
        
    }
    
    func authorized(completionHandler: @escaping (UNNotificationSettings) -> Void) {
        self.center.getNotificationSettings(completionHandler: completionHandler)
        
    }
    
}
