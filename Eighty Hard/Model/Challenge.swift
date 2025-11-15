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
    var quitDate: Date? = nil
    var endDate: Date = Date()
    var statusRaw: String = ChallengeStatus.inProgress.rawValue

    @Relationship(deleteRule: .cascade)
    var days: [Day]?

    init(startDate: Date = Date()) {
        self.startDate = Calendar.current.startOfDay(for: startDate)
        endDate = Calendar.current.date(byAdding: .day, value: 79, to: self.startDate)!
        days = (0..<80).compactMap { offset in
            guard let dayDate = Calendar.current.date(byAdding: .day, value: offset, to: self.startDate) else {
                return nil
            }
            return Day(number: offset + 1, date: dayDate)
        }
    }
}


extension Challenge {
    public static var daysBeforeGrade: Int = 3
    
    var currentDay: Day? {
        days?.first { Calendar.current.isDateInToday($0.date) }
    }
    
    func quitChallenge() -> Bool {
        let proposedQuitDate = Calendar.current.startOfDay(for: Date())
        if proposedQuitDate < Calendar.current.startOfDay(for: endDate) {
            quitDate = proposedQuitDate
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
        switch status {
        case .inProgress:
            if let currentDay = currentDay {
                print("Status in progress: \(currentDay.number) days")
                return currentDay.number
            }
        case .quit:
            if let quitDate {
                let components = Calendar.current.dateComponents([.day], from: startDate, to: quitDate)
                if let daysBetween = components.day {
                    print("Status quit: \(daysBetween + 1) days")
                    return daysBetween + 1
                }
            }
        case .completed:
            print("Status completed: 80 days")
            return 80
        }
        
        return 0
    }
    
    var daysRemaining: Int {
        max(0, 80 - daysCompleted)
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
        guard daysCompleted > 0 else { return 0 }
        return Double(daysCompleted) / 80.0
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
