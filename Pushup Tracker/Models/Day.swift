//
//  Day.swift
//  Pushup Tracker
//
//  Created by Sam Gulinello on 1/27/22.
//

import Foundation

struct Day: Hashable, Codable{
    var complete: Bool
    var number: Int
    var date: Date
}
