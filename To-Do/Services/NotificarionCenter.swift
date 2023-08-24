//
//  NotificarionCenter.swift
//  To-Do
//
//  Created by MAG on 22/08/2023.
//

import Foundation

import UserNotifications

class LocalNotificationCenter {
    func scheduleLocalNotification(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var calendar = Calendar.current

        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "uniqueIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }else {
                print("itWork")
            }
        }
    }
}

