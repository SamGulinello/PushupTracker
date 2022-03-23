//
//  Pushup_TrackerApp.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 1/22/22.
//

import SwiftUI

@main
struct Pushup_TrackerApp: App {
    
    init() {
        print("LOADING SCREEN")
        
        let notificationManager = NotificationController()
        notificationManager.scheduleDailyNotifications()

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
