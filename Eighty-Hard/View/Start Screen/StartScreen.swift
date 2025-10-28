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
    
    let hasCompletedChallenge: Bool
    
    // Gradient animation
    @State private var animateGradient = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // Title with circular motif
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .foregroundStyle(
                            LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
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
                    modelContext.insert(Challenge())
                } label: {
                    Text("Start 80 Hard \(hasCompletedChallenge ? "Again " : "")")
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
                if hasCompletedChallenge {
                    NavigationLink {
                        PreviousResults()
                    } label: {
                        Text("Previous results")
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .background(
            LinearGradient(colors: [.black, .gray.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}
#Preview {
    StartScreen(hasCompletedChallenge: true)
}
