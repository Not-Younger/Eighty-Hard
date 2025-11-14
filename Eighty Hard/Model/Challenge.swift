//
//  Challenge.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftUI
import SwiftData

@Model
class Challenge: Identifiable {
    var id: String = UUID().uuidString
    var startDate: Date = Date()
    var endDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 80)
    var statusRaw: String = ChallengeStatus.inProgress.rawValue

    @Relationship(deleteRule: .cascade)
    var days: [Day]?
    
    // Start today
    init() {
        var days: [Day] = []
        for i in 1...80 {
            let date = Date().addingTimeInterval(60 * 60 * 24 * Double(i - 1))
            print("Adding day \(i) on \(date)")
            days.append(Day(number: i, date: date))
        }
        self.days = days
    }
    
    // Start in past
    init(startDate: Date) {
        self.startDate = startDate
        self.endDate = startDate.addingTimeInterval(60 * 60 * 24 * 80)
        var days: [Day] = []
        for i in 1...80 {
            let date = startDate.addingTimeInterval(60 * 60 * 24 * Double(i - 1))
            print("Adding day \(i) on \(date)")
            days.append(Day(number: i, date: date))
        }
        self.days = days
    }
}

extension Challenge {
    public static var daysBeforeGrade: Int = 3
    
    var currentDay: Day? {
        for day in days ?? [] {
            if Calendar.current.isDateInToday(day.date) {
                return day
            }
        }
        print("Current day not found")
        return nil
    }
    
    func quitChallenge() -> Bool {
        if Calendar.current.startOfDay(for: Date()) < Calendar.current.startOfDay(for: endDate) {
            endDate = Date()
            status = .quit
            print("Challenge quit...")
            return true
        }
        return false
    }
    
    func finishChallenge() -> Bool {
        // If date is in the past
        if Calendar.current.startOfDay(for: endDate) < Calendar.current.startOfDay(for: Date()) {
            status = .completed
            print("Challenge finished!")
            return true
        }
        return false
    }
    
    var daysCompleted: Int {
        // Challenge in progress
        if let currentDay = currentDay {
            return currentDay.number
        }
        // Challenge quit early
        if status == .quit {
            let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
            if let daysBetween = components.day {
                return daysBetween
            }
        }
        // Challenge completed and in the past
        return 80
    }
    
    var daysRemaining: Int {
        // Challenge in progress
        if let currentDay = currentDay {
            return 80 - currentDay.number
        }
        // Challenge completed or quit and in the past
        return 0
    }
    
    var completedTasks: Int {
        var totalCompletedTasks: Int = 0
        for day in days ?? [] {
            totalCompletedTasks += day.tasksCompleted
        }
        print("\(totalCompletedTasks) completed tasks")
        return totalCompletedTasks
    }
    
    var totalTasks: Int {
        return daysCompleted * 9
    }
    
    var daysCompletedFraction: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(daysCompleted) / Double(80)
    }
    
    var completionPercentage: Double {
        guard totalTasks > 0 else { return 0 }
        return (Double(completedTasks) / Double(totalTasks)) * 100
    }
    
    var completionFraction: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
    
    var completionFractionAllTasks: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(9 * 80)
    }
    
    var status: ChallengeStatus {
        get { ChallengeStatus(rawValue: statusRaw) ?? .inProgress }
        set { statusRaw = newValue.rawValue }
    }
    
    var grade: String? {
        guard daysCompleted >= Challenge.daysBeforeGrade else { return nil }
        
        switch completionFraction {
        case 1.0: return "S"
        case 0.9..<1.0: return "A"
        case 0.8..<0.9: return "B"
        case 0.7..<0.8: return "C"
        case 0.6..<0.7: return "D"
        case 0: return "😢"
        default: return "F"
        }
    }
    
    var gradeColor: Color {
        guard let grade = grade else { return .red }
        switch grade {
        case "S": return .purple
        case "A": return .green.opacity(0.7)
        case "B": return .yellow.opacity(0.9)
        case "C": return .orange.opacity(0.9)
        case "D": return .red.opacity(0.7)
        case "F": return .red
        default: return .red.opacity(0.5)
        }
    }
    
    var performanceText: String {
        let percentage = String(format: "%.2f", completionPercentage)
        
        // Encouragement before grading
        if daysCompleted < Challenge.daysBeforeGrade {
            return "Keep going! Complete a few more days to see your performance grade."
        }
        
        // Adaptive grading text
        switch grade {
        case "S": return "You're on fire! You've completed 100% of your tasks. Keep up the incredible work!"
        case "A": return "Amazing! You’ve completed \(percentage)% of your tasks. Keep up the great work!"
        case "B": return "Great job! You’re at \(percentage)% of your tasks. Stay consistent and push a little further!"
        case "C": return "Not bad! \(percentage)% of your tasks completed. You can reach the next level with some extra effort."
        case "D": return "Getting there. \(percentage)% of your tasks done. Focus on building momentum!"
        case "F": return "Time to get going! Only \(percentage)% of your tasks completed. You’ve got this—take it one task at a time."
        default: return "Time to get started! None of your tasks are completed. You’ve got this—take it one task at a time."
        }
    }
}

enum ChallengeStatus: String {
    case inProgress = "In Progress"
    case completed = "Completed"
    case quit = "Quit"
}
