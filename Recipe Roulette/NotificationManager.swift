//
//  NotificationManager.swift
//  Recipe Roulette
//
//  Created by Mimi Henry on 12/3/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
            // handle if needed
        }
    }
    
    func scheduleDailyRecipeNotification(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_recipe"])
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Recipe of the Day"
        content.body = "Tap to spin Recipe Roulette and see what's for dinner!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "daily_recipe", content: content, trigger: trigger)
        center.add(request)
    }
}
