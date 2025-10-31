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
    
    @State private var path = NavigationPath()
    @State private var activeChallenge: Challenge? = nil
    
    var body: some View {
        NavigationStack(path: $path) {
            StartScreen(activeChallenge: $activeChallenge, path: $path)
                .onAppear {
                    if let currentChallenge = challenges.first(where: { $0.status == .inProgress }) {
                        activeChallenge = currentChallenge
                        path.append(currentChallenge)
                    }
                }
                .preferredColorScheme(.dark)
                .navigationDestination(for: Challenge.self) { challenge in
                    HomeView(challenge: challenge, activeChallenge: $activeChallenge, path: $path)
                }
                .navigationDestination(for: Navigation.self) { navigation in
                    switch navigation {
                    case .previousResults:
                        PreviousResultsView(path: $path)
                    case .overview(let challenge):
                        OverviewView(challenge: challenge, path: $path)
                    case .tasks(let day, let dayNumber):
                        if let day {
                            TasksView(day: day)
                        } else {
                            Text("No data for day \(dayNumber)")
                        }
                    case .alreadyStarted:
                        AlreadyStartedView(activeChallenge: $activeChallenge, path: $path)
                    }
                }
        }
        .accentColor(.red)
    }
}

#Preview {
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
    let challenge = Challenge()
    challenge.status = .completed
    container.mainContext.insert(challenge)
    
    return ContentView()
        .modelContainer(container)
}
