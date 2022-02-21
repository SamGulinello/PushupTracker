//
//  Pushup_TrackerApp.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 1/22/22.
//

import SwiftUI
import CoreData

@main
struct Pushup_TrackerApp: App {
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyApplication")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

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
