//
//  ProgressWidgetView.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/11/25.
//

import SwiftData
import WidgetKit
import SwiftUI

struct ProgressWidgetView: View {
    @Query private var challenges: [Challenge]
    var entry: ProgressProvider.Entry
    
    @State private var challenge: Challenge? = nil

    var body: some View {
        Group {
            let days = (challenge?.days ?? []).sorted { $0.number < $1.number }
            WidgetOverviewView(days: days)
            if let currentDay = challenge?.currentDay {
                WidgetTaskCompletionView(currentDay: currentDay, circleSize: 8)
            }
        }
        .containerBackground(for: .widget) {
            Color.black
        }
        .onAppear {
            challenge = challenges.filter { $0.status == .inProgress }.sorted { $0.startDate < $1.startDate }.first
            if challenge == nil { challenge = getRandomChallenge() }
        }
    }
    
    func getRandomChallenge() -> Challenge {
        let challenge = Challenge()
        var generatedDays: [Day] = []
        
        for i in 1...75 {
            let day = Day(number: i)
            
            // Randomize task completion
            day.didDrinkWater = Bool.random()
            day.didWorkout = Bool.random()
            day.didDiet = Bool.random()
            day.didStayUnderDrinkLimit = Bool.random()
            day.didReading = Bool.random()
            day.didColdShower = Bool.random()
            let didCriticalTasks = Bool.random()
            if didCriticalTasks {
                day.didCriticalTaskOne = true
                day.didCriticalTaskTwo = true
            }
            day.didMeditate = Bool.random()
            day.didSocialMediaLimit = Bool.random()
            
            generatedDays.append(day)
        }
        
        challenge.days = generatedDays
        challenge.status = .inProgress
        
        return challenge
    }

}
