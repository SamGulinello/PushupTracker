//
//  Progress.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 1/27/22.
//

import Foundation

class ProgressController: ObservableObject {
    @Published var dayList: [Day] = []
    @Published var progress = 0.0
    @Published var currentStreak = 0
    @Published var BestStreak = 0
    var dayNum = 1
    
    func increasePercent() {
        self.progress += 0.1
    }
    
    func populateMissed() {
        if let last = self.dayList.last {
            let difference = Date().days(from: last.date)
            if difference >= 1 {
                for _ in 0...difference {
                    self.dayList.append(Day(complete: false, number: self.dayNum, date: Date()))
                    self.dayNum += 1
                }
            }
        }
    }
    
    func getLast() -> Day? {
        if let last = self.dayList.last {
            return last
        } else {
            return nil
        }
    }
}

extension Date {
    func days(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    func adding(weeks: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }
}
