//
//  Challenge.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import Foundation
import SwiftData

@Model
class Challenge: Identifiable {
    var id: String = UUID().uuidString
    var startDate: Date = Date()
    var endDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 80)
    var isCompleted: Bool = false
    var isEnded: Bool = false
    
    @Relationship(deleteRule: .cascade)
    var days: [Day]?
    
    init() { }
    
    var currentDay: Day? {
        let days = self.days ?? []
        let sortedDays = days.sorted { $0.date < $1.date }
        let currentDay = sortedDays.last
        return currentDay
    }
    
    var completedTasks: Int {
        var totalCompletedTasks: Int = 0
        for day in (days ?? []) {
            totalCompletedTasks += day.completedTasks
        }
        return totalCompletedTasks
    }
    
    var totalTasks: Int {
        return (days ?? []).count * 9
    }
    
    var completionPercentage: Double {
        guard totalTasks > 0 else { return 0 }
        return (Double(completedTasks) / Double(totalTasks)) * 100
    }
}
