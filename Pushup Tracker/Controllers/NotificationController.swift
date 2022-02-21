//
//  NotificationManager.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 2/3/22.
//

import Foundation
import UserNotifications

class NotificationController{
    
    var hourlyNotification = Notification(id:"NotificationOne", title:"THIS IS A TEST", datetime: DateComponents(calendar: Calendar.current, minute: 00))
    
    let dailyNotification = Notification(id:"DailyNotification", title:"THIS IS A TEST", datetime: DateComponents(calendar: Calendar.current, hour: 20, minute: 05))
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

        for notification in notifications {
            print(notification)
        }
        }
    }
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

        if granted == true && error == nil {
            self.scheduleHourlyNotifications(Minute: 00)
        }
        }
    }
    
    func schedule(Minute: Int) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
                case .notDetermined:
                self.requestAuthorization()
                case .authorized, .provisional:
                self.scheduleHourlyNotifications(Minute: Minute)
                default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleHourlyNotifications(Minute: Int) {
        
        self.hourlyNotification = Notification(id:"NotificationOne", title:"DO YOUR PUSHUPS", datetime: DateComponents(calendar: Calendar.current, minute: Minute))
        
        let content = UNMutableNotificationContent()
            content.title = hourlyNotification.title
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: hourlyNotification.datetime, repeats: true)

            let request = UNNotificationRequest(identifier: hourlyNotification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

            guard error == nil else { return }

                print("Notification scheduled! — ID = \(self.hourlyNotification.id)")
                
            }
    }
    
    func scheduleDailyNotifications() {
        self.requestAuthorization()
        
        let content = UNMutableNotificationContent()
            content.title = dailyNotification.title
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dailyNotification.datetime, repeats: true)

            let request = UNNotificationRequest(identifier: dailyNotification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

            guard error == nil else { return }

                print("Notification scheduled! — ID = \(self.dailyNotification.id)")
                
            }
    }
}
