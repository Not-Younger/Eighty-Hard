//
//  ContentView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var challenges: [Challenge]
    @Query private var inProgressChallenges: [Challenge]
    @Query private var completedChallenges: [Challenge]
    
    init() {
        _inProgressChallenges = Query(filter: #Predicate {
            $0.isCompleted == false
        })
        _completedChallenges = Query(filter: #Predicate {
            $0.isCompleted == true
        })
    }
    
    var body: some View {
        NavigationStack {
            if challenges.isEmpty {
                StartScreen(hasCompletedChallenge: false)
            } else if let currentChallenge = inProgressChallenges.first {
                HomeView(challenge: currentChallenge)
            } else {
                // No active challenge
                StartScreen(hasCompletedChallenge: true)
            }
        }
    }
}

#Preview {
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
    let challenge = Challenge()
    challenge.isCompleted = true
    container.mainContext.insert(challenge)
    
    return ContentView()
        .modelContainer(container)
}
