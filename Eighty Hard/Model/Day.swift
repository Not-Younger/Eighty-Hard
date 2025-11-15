//
//  Day.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftUI
import SwiftData

@Model
class Day: Identifiable {
    var id: String = UUID().uuidString
    var number: Int = -1
    var date: Date = Date()
    var note: String = ""
    var didDrinkWater: Bool = false
    var didWorkout: Bool = false
    var didDiet: Bool = false
    var didStayUnderDrinkLimit: Bool = false
    var didReading: Bool = false
    var didColdShower: Bool = false
    var didCriticalTaskOne: Bool = false
    var didCriticalTaskTwo: Bool = false
    var didMeditate: Bool = false
    var didSocialMediaLimit: Bool = false
    
    var criticalTaskOne: String = ""
    var criticalTaskTwo: String = ""
    
    init(number: Int, date: Date) {
        self.number = number
        self.date = date
    }
    
    @Relationship(inverse: \Challenge.days)
    var challenge: Challenge?
}

extension Day {
    static var waterTaskTitle: String = "Drink a gallon of water daily."
    static var workoutTaskTitle: String = "One hour workout or 45 minutes of cardio (minimum)"
    static var dietTaskTitle: String = "Stick to a diet."
    static var alcoholTaskTitle: String = "Alcoholic drink limit."
    static var readingTaskTitle: String = "Read 10 pages."
    static var coldShowerTaskTitle: String = "Take 5 minute cold shower."
    static var criticalTaskTitle: String = "Two critical tasks."
    static var meditateTaskTitle: String = "Meditate 10 minutes."
    static var socialMediaTaskTitle: String = "Less than 20 minutes of social media."
    
    static var waterTaskDescription: String = "Stay hydrated to improve focus, recovery, and energy."
    static var workoutTaskDescription: String = "Push your limits every day — no excuses."
    static var dietTaskDescription: String = "Choose a nutrition plan and follow it strictly — no cheat meals."
    static var alcoholTaskDescription: String = "Limit alcohol to a maximum of 2 days per week — up to 6 drinks per day, and no more than 11 total for the week."
    static var readingTaskDescription: String = "Feed your mind with something positive or educational daily."
    static var coldShowerTaskDescription: String = "Build mental toughness and increase alertness."
    static var criticalTaskDescription: String = " Focus on two meaningful goals that move you forward."
    static var meditateTaskDescription: String = "Quiet your mind and stay grounded in the process."
    static var socialMediaTaskDescription: String = "Reclaim your attention and focus on what matters."
    
    static var waterTaskIcon: String = "drop.fill"
    static var workoutTaskIcon: String = "figure.walk"
    static var dietTaskIcon: String = "leaf.fill"
    static var alcoholTaskIcon: String = "wineglass"
    static var readingTaskIcon: String = "book.fill"
    static var coldShowerTaskIcon: String = "snowflake"
    static var criticalTaskIcon: String = "checkmark.seal.fill"
    static var meditateTaskIcon: String = "brain.head.profile"
    static var socialMediaTaskIcon: String = "person.crop.circle.badge.clock"
    
    var didCriticalTasks: Bool {
        didCriticalTaskOne && didCriticalTaskTwo
    }
    
    var tasksCompleted: Int {
        var count: Int = 0
        if didDrinkWater { count += 1 }
        if didWorkout { count += 1 }
        if didDiet { count += 1 }
        if didStayUnderDrinkLimit { count += 1 }
        if didReading { count += 1 }
        if didColdShower { count += 1 }
        if didCriticalTaskOne && didCriticalTaskTwo { count += 1 }
        if didMeditate { count += 1 }
        if didSocialMediaLimit { count += 1 }
        return count
    }
    
    var completionColor: Color {

        let dayStart = Calendar.current.startOfDay(for: date)
        let todayStart = Calendar.current.startOfDay(for: Date())

        // Future days
        if dayStart > todayStart {
            return Color.gray.opacity(0.3)
        }

        // Quit date check
        if let quitDate = challenge?.quitDate {
            if dayStart > Calendar.current.startOfDay(for: quitDate) {
                return Color.gray.opacity(0.3)
            }
        }

        // End date check
        if let endDate = challenge?.endDate {
            if dayStart > Calendar.current.startOfDay(for: endDate) {
                return Color.gray.opacity(0.3)
            }
        }

        let tasks = [
            didDrinkWater,
            didWorkout,
            didDiet,
            didStayUnderDrinkLimit,
            didReading,
            didColdShower,
            didCriticalTasks,
            didMeditate,
            didSocialMediaLimit
        ]

        let fraction = Double(tasks.filter { $0 }.count) / Double(tasks.count)

        switch fraction {
            case 0.0..<0.2: return Color.red.opacity(0.3)
            case 0.2..<0.4: return Color.red.opacity(0.4)
            case 0.4..<0.6: return Color.red.opacity(0.5)
            case 0.6..<0.8: return Color.red.opacity(0.6)
            case 0.8..<0.99: return Color.red.opacity(0.7)
            default:        return Color.red.opacity(0.8)
        }
    }

    
    var isAccessible: Bool {
        let dayStart = Calendar.current.startOfDay(for: date)
        let todayStart = Calendar.current.startOfDay(for: Date())

        // Future days
        if dayStart > todayStart {
            return false
        }

        // Quit date check
        if let quitDate = challenge?.quitDate {
            if dayStart > Calendar.current.startOfDay(for: quitDate) {
                return false
            }
        }

        // End date check
        if let endDate = challenge?.endDate {
            if dayStart > Calendar.current.startOfDay(for: endDate) {
                return false
            }
        }
        
        return true
    }
}

