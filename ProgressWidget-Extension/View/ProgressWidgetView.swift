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
    @Environment(\.widgetFamily) var family
    @Query private var challenges: [Challenge]
    var entry: ProgressProvider.Entry
    
    @State private var challenge: Challenge? = nil

    var body: some View {
        VStack {
            let days = (challenge?.days ?? []).sorted { $0.number < $1.number }
            let currentDay = challenge?.currentDay ?? Day(number: 70, date: Date())
            switch family {
            case .systemSmall:
                WidgetTaskCompletionView(currentDay: currentDay, circleSize: 8, isSmallWidget: true)
            case .systemMedium:
                WidgetOverviewView(days: days)
                WidgetTaskCompletionView(currentDay: currentDay, circleSize: 8, isSmallWidget: false)
            case .systemLarge:
                let daysCompletedFraction = challenge?.daysCompletedFraction ?? 1
                let currentDayNumber: Int = challenge?.currentDay?.number ?? 80
                ChallengeProgressionView(daysCompletedFraction: daysCompletedFraction, currentDayNumber: currentDayNumber)
                WidgetOverviewView(days: days)
                WidgetTaskCompletionView(currentDay: currentDay, circleSize: 8, isSmallWidget: false)
            default:
                ProgressView()
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
        let pastDate = Calendar.current.date(byAdding: .day, value: -70, to: Date())!
        let challenge = Challenge(startDate: pastDate)
        
        for day in challenge.days ?? [] {
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
        }
        
        return challenge
    }

}
