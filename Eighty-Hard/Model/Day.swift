//
//  Day.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import Foundation
import SwiftData

@Model
class Day: Identifiable {
    var id: String = UUID().uuidString
    var number: Int
    var date: Date = Date()
    var note: String = ""
    var didDrinkWater: Bool = false
    var didWorkout: Bool = false
    var didDiet: Bool = false
    var didStayUnderDrinkLimit: Bool = false
    var didReading: Bool = false
    var didColdShower: Bool = false
    var didCriticalTasks: Bool = false
    var didMeditate: Bool = false
    var didSocialMediaLimit: Bool = false
    
    var critcalTaskOne: String = ""
    var critcalTaskTwo: String = ""
    
    init(number: Int) {
        self.number = number
    }
    
    @Relationship(inverse: \Challenge.days)
    var challenge: Challenge?
    
    var completedTasks: Int {
        var count: Int = 0
        if didDrinkWater { count += 1 }
        if didWorkout { count += 1 }
        if didDiet { count += 1 }
        if didStayUnderDrinkLimit { count += 1 }
        if didReading { count += 1 }
        if didColdShower { count += 1 }
        if didCriticalTasks { count += 1 }
        if didMeditate { count += 1 }
        if didSocialMediaLimit { count += 1 }
        return count
    }
    
    static var waterTaskText: String = "Drink a gallon of water daily."
    static var workoutTaskText: String = "1 hour workout or 45 minutes of cardio (minimum)"
    static var dietTaskText: String = "Stick to a diet."
    static var alcoholTaskText: String = "Alcoholic drink limit."
    static var readingTaskText: String = "Read 10 pages."
    static var coldShowerTaskText: String = "Take 5 minute cold shower."
    static var criticalTaskText: String = "2 critical tasks."
    static var meditateTaskText: String = "Meditate 10 minutes."
    static var socialMediaTaskText: String = "Less than 20 minutes of social media."
}
