//
//  ContentView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftData
import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Environment(LocalNotificationManager.self) private var lnManager: LocalNotificationManager
    @Query private var challenges: [Challenge]
    
    @State private var path = NavigationPath()
    @State private var activeChallenge: Challenge? = nil
    
    var body: some View {
        NavigationStack(path: $path) {
            StartScreen(activeChallenge: $activeChallenge, path: $path)
                .environment(lnManager)
                .onAppear {
                    handleChallengeSync()
                }
                .onChange(of: challenges) { _, _ in
                    handleChallengeSync()
                }
                .onChange(of: scenePhase) { _, newValue in
                    if newValue == .inactive {
                        WidgetCenter.shared.reloadTimelines(ofKind: "Progress_Widget")
                    }
                }
                .preferredColorScheme(.dark)
                .navigationDestination(for: Challenge.self) { challenge in
                    HomeView(challenge: challenge, activeChallenge: $activeChallenge, path: $path)
                }
                .navigationDestination(for: Navigation.self) { navigation in
                    Group {
                        switch navigation {
                        case .previousResults:
                            PreviousResultsView(path: $path)
                        case .overview(let challenge):
                            OverviewView(challenge: challenge, path: $path)
                        case .tasks(let day, let dayNumber):
                            if let day {
                                TasksView(day: day)
                            } else {
                                NoDataView(dayNumber: dayNumber, path: $path)
                            }
                        case .alreadyStarted:
                            AlreadyStartedView(activeChallenge: $activeChallenge, path: $path)
                        case .alreadyStartedDataInput(let challenge):
                            AlreadyStartedDataInputView(challenge: challenge, path: $path)
                        case .moreInfo:
                            MoreInfoView(path: $path)
                        case .settingsPage(let challenge):
                            SettingsView(challenge: challenge, activeChallenge: $activeChallenge, path: $path)
                        }
                    }
                    .environment(lnManager)
                }
        }
        .tint(.red)
    }
    
    private func handleChallengeSync() {
        let inProgressChallenges = challenges
            .filter { $0.status == .inProgress }
            .sorted { $0.startDate < $1.startDate }

        if let currentChallenge = inProgressChallenges.first {
            activeChallenge = currentChallenge
            path = NavigationPath()
            path.append(currentChallenge)

            if inProgressChallenges.count > 1 {
                for i in 1..<inProgressChallenges.count {
                    modelContext.delete(inProgressChallenges[i])
                }
            }
        }
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
