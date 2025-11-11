//
//  StartScreen.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftData
import SwiftUI

struct StartScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var challenges: [Challenge]
    
    @Binding var activeChallenge: Challenge?
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .foregroundStyle(
                            LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 180, height: 180)
                    
                    Text("80 Hard")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top, 50)
                
                Text("Complete these 9 tasks daily for 80 days in a row.")
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    StartScreenTaskRow(
                        number: 1,
                        title: Day.waterTaskTitle,
                        description: Day.waterTaskDescription,
                        systemImage: Day.waterTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 2,
                        title: Day.workoutTaskTitle,
                        description: Day.workoutTaskDescription,
                        systemImage: Day.workoutTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 3,
                        title: Day.dietTaskTitle,
                        description: Day.dietTaskDescription,
                        systemImage: Day.dietTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 4,
                        title: Day.alcoholTaskTitle,
                        description: Day.alcoholTaskDescription,
                        systemImage: Day.alcoholTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 5,
                        title: Day.readingTaskTitle,
                        description: Day.readingTaskDescription,
                        systemImage: Day.readingTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 6,
                        title: Day.coldShowerTaskTitle,
                        description: Day.coldShowerTaskDescription,
                        systemImage: Day.coldShowerTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 7,
                        title: Day.meditateTaskTitle,
                        description: Day.meditateTaskTitle,
                        systemImage: Day.meditateTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 8,
                        title: Day.socialMediaTaskTitle,
                        description: Day.socialMediaTaskDescription,
                        systemImage: Day.socialMediaTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 9,
                        title: Day.criticalTaskTitle,
                        description: Day.criticalTaskDescription,
                        systemImage: Day.criticalTaskIcon
                    )
                }
                .padding(.horizontal)
                
                Button {
                    let newChallenge = Challenge()
                    activeChallenge = newChallenge
                    path.append(newChallenge)
                } label: {
                    Text("Start 80 Hard")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 50)
                
                Button {
                    path.append(Navigation.alreadyStarted)
                } label: {
                    Text("Already started?")
                        .foregroundStyle(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                if hasPreviousChallenges() {
                    Button {
                        path.append(Navigation.previousResults)
                    } label: {
                        Text("Show previous challenges")
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .background(
            LinearGradient(colors: [.black, .red], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
    
    func hasActiveChallenge() -> Bool {
        return challenges.contains(where: { $0.status == .inProgress }) ? true : false
    }
    
    func hasPreviousChallenges() -> Bool {
        return challenges.contains(where: { $0.status != .inProgress }) ? true : false
    }
}
