//
//  OverviewView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftData
import SwiftUI

struct OverviewView: View {
    @Bindable var challenge: Challenge
    @Binding var path: NavigationPath
    
    let totalDots = 80
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    
    // Color for a single day based on its task completion fraction
    private func completionColor(for day: Day?) -> Color {
        guard let day = day else { return Color.gray.opacity(0.3) }
        
        let tasks = [
            day.didDrinkWater,
            day.didWorkout,
            day.didDiet,
            day.didStayUnderDrinkLimit,
            day.didReading,
            day.didColdShower,
            day.didCriticalTasks,
            day.didMeditate,
            day.didSocialMediaLimit
        ]
        
        let fraction = Double(tasks.filter { $0 }.count) / Double(tasks.count)
        
        switch fraction {
        case 0..<0.5: return Color.red
        case 0.5..<0.75: return Color.orange
        case 0.75..<1: return Color.yellow
        default: return Color.green
        }
    }
    
    // Overall progress fraction based on days completed
    private var daysCompletionFraction: Double {
        let completedDays = Double((challenge.days ?? []).count)
        return completedDays / Double(totalDots)
    }
    
    // Color for the overall progress circle
    private var overallProgressColor: Color {
        switch daysCompletionFraction {
        case 0..<1: return .blue
        default: return .green
        }
    }
    
    var body: some View {
        let days = (challenge.days ?? []).sorted { $0.number < $1.number }
        
        ScrollView {
            VStack(spacing: 20) {
                
                // Overall progress circle (days completed)
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: daysCompletionFraction)
                        .stroke(overallProgressColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 80, height: 80)
                        .animation(.easeInOut, value: daysCompletionFraction)
                    
                    Text("\(Int(daysCompletionFraction * 100))%")
                        .font(.headline)
                        .bold()
                        .foregroundColor(overallProgressColor)
                }
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<totalDots, id: \.self) { index in
                        let dayNumber = index + 1
                        let day = days.first(where: { $0.number == dayNumber })
                        
                        Button {
                            path.append(Navigation.tasks(day: day, dayNumber: dayNumber))
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(completionColor(for: day))
                                    .frame(width: 40, height: 40)
                                
                                Text("\(dayNumber)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.top, 40)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}
