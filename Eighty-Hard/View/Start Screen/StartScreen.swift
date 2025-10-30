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
                    StartTaskRow(1, "Drink a gallon of water daily.", systemImage: "drop.fill")
                    StartTaskRow(2, "1 hour workout or 45 minutes of cardio (minimum).", systemImage: "figure.walk")
                    StartTaskRow(3, "Stick to a diet.", systemImage: "leaf.fill")
                    StartTaskRow(4, "Alcoholic drink limit.", systemImage: "wineglass")
                    StartTaskRow(5, "Read 10 pages.", systemImage: "book.fill")
                    StartTaskRow(6, "Take 5 minute cold shower.", systemImage: "snowflake")
                    StartTaskRow(7, "2 critical tasks.", systemImage: "checkmark.seal.fill")
                    StartTaskRow(8, "Meditate 10 minutes.", systemImage: "brain.head.profile")
                    StartTaskRow(9, "Less than 20 minutes of social media.", systemImage: "person.crop.circle.badge.clock")
                }
                .padding(.horizontal)
                
                Button {
                    
                } label: {
                    Text("More details")
                        .foregroundStyle(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
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
            LinearGradient(colors: [.black, .gray.opacity(0.7)], startPoint: .top, endPoint: .bottom)
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
