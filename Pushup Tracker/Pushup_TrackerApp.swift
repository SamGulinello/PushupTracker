//
//  Pushup_TrackerApp.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 1/22/22.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct Pushup_TrackerApp: App {
    
    @StateObject private var dataController = DataController()
    
    init() {
        print("LOADING SCREEN")
        
        let notificationManager = NotificationController()
        notificationManager.scheduleDailyNotifications()
        GADMobileAds.sharedInstance().start(completionHandler: nil)

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
