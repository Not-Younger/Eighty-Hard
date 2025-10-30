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
    
    @State private var animateGradient = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .foregroundStyle(
                            LinearGradient(colors: [.red, .orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(animateGradient ? 360 : 0))
                        .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: animateGradient)
                    
                    Text("80 Hard")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top, 50)
                .onAppear { animateGradient = true }
                
                Text("Complete these 9 tasks daily for 80 days in a row.")
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    StartScreenTaskRow(
                        number: 1,
                        title: "Drink a gallon of water daily.",
                        description: "Stay hydrated to improve focus, recovery, and energy.",
                        systemImage: "drop.fill"
                    )
                    
                    StartScreenTaskRow(
                        number: 2,
                        title: "1 hour workout or 45 minutes of cardio (minimum).",
                        description: "Push your limits every day — no excuses.",
                        systemImage: "figure.walk"
                    )
                    
                    StartScreenTaskRow(
                        number: 3,
                        title: "Stick to a diet.",
                        description: "Choose a nutrition plan and follow it strictly — no cheat meals.",
                        systemImage: "leaf.fill"
                    )
                    
                    StartScreenTaskRow(
                        number: 4,
                        title: "Alcoholic drink limit.",
                        description: "Limit alcohol to a maximum of 2 days per week — up to 6 drinks per day, and no more than 11 total for the week.",
                        systemImage: "wineglass"
                    )
                    
                    StartScreenTaskRow(
                        number: 5,
                        title: "Read 10 pages.",
                        description: "Feed your mind with something positive or educational daily.",
                        systemImage: "book.fill"
                    )
                    
                    StartScreenTaskRow(
                        number: 6,
                        title: "Take a 5 minute cold shower.",
                        description: "Build mental toughness and increase alertness.",
                        systemImage: "snowflake"
                    )
                    
                    StartScreenTaskRow(
                        number: 7,
                        title: "2 critical tasks.",
                        description: "Focus on two meaningful goals that move you forward.",
                        systemImage: "checkmark.seal.fill"
                    )
                    
                    StartScreenTaskRow(
                        number: 8,
                        title: "Meditate 10 minutes.",
                        description: "Quiet your mind and stay grounded in the process.",
                        systemImage: "brain.head.profile"
                    )
                    
                    StartScreenTaskRow(
                        number: 9,
                        title: "Less than 20 minutes of social media.",
                        description: "Reclaim your attention and focus on what matters.",
                        systemImage: "person.crop.circle.badge.clock"
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
                            LinearGradient(colors: [.red, .orange, .yellow], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 50)
                
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
