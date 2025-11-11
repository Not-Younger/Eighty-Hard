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
    let columns = 7
    
    // Progress based on completed days
    private var daysCompletionFraction: Double {
        let completedDays = Double((challenge.days ?? []).count)
        return completedDays / Double(totalDots)
    }
    
    var body: some View {
        let days = (challenge.days ?? []).sorted { $0.number < $1.number }
        
        GeometryReader { geometry in
            let totalSpacing: CGFloat = CGFloat(columns - 1) * 8 // 8pt spacing between items
            let availableWidth = geometry.size.width - totalSpacing - 32 // minus horizontal padding
            let itemSize = availableWidth / CGFloat(columns)
            
            ScrollView {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                            .frame(width: 180, height: 180)
                        
                        Circle()
                            .trim(from: 0, to: daysCompletionFraction)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: daysCompletionFraction >= 1.0
                                        ? [.green]
                                        : [.red, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 180, height: 180)
                        
                        VStack(alignment: .center) {
                            Text("Day")
                                .font(.system(size: 18, weight: .medium))
                            Text("\(challenge.currentDay?.number ?? 0) / 80")
                                .font(.system(size: 32, weight: .bold))
                        }
                    }
                    .padding(.vertical, 40)
                    
                    ChallengeGradeView(challenge: challenge)
                        .padding(.horizontal)
                    
                    // Grid of days
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns), spacing: 8) {
                        ForEach(0..<totalDots, id: \.self) { index in
                            let dayNumber = index + 1
                            let day = days.first(where: { $0.number == dayNumber })
                            
                            Button {
                                path.append(Navigation.tasks(day: day, dayNumber: dayNumber))
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(day?.completionColor ?? Color.gray.opacity(0.3))
                                        .frame(width: abs(itemSize), height: abs(itemSize))
                                    
                                    Text("\(dayNumber)")
                                        .font(.system(size: itemSize * 0.3, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Overview")
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
    let challenge = Challenge()
    challenge.status = .completed
    
    for i in 0...80 {
        let newDay = Day(number: i)
        newDay.didDrinkWater = true
        newDay.didWorkout = true
        newDay.didReading = true
        newDay.didColdShower = true
        newDay.didDiet = true
        newDay.didCriticalTaskOne = true
        newDay.didCriticalTaskTwo = true
        newDay.didSocialMediaLimit = true
        newDay.didStayUnderDrinkLimit = true
        newDay.didMeditate = true
        challenge.days?.append(newDay)
    }
    
    container.mainContext.insert(challenge)
    
    return NavigationStack {
        OverviewView(challenge: challenge, path: $path)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
