//
//  TimeController.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 2/1/22.
//

import Foundation

struct TimeController {
    
    var hourTimer: Timer?
    var calendar = Calendar.current
    
    func isNewDay(date: Date) -> Bool {
        let second = calendar.component(.second, from: date)
        print(second)
        return true
    }
    
    
    mutating func stopTimer() {
        hourTimer?.invalidate()
        hourTimer = nil
    }
}
