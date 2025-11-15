//
//  PreviousResults.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/28/25.
//

import SwiftData
import SwiftUI

struct PreviousResultsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var challenges: [Challenge]
    
    @Binding var path: NavigationPath
    
    var body: some View {
        Group {
            if challenges.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("No completed challenges yet.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
            } else {
                PreviousResultsListView(path: $path)
            }
        }
        .navigationTitle("Previous Challenges")
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .background(
            LinearGradient(colors: [.black, .red], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
//    for _ in 0..<1 {
//        let challenge = Challenge()
//        for day in challenge.days ?? [] {
//            day.didDrinkWater = true
//            day.didWorkout = true
//            day.didReading = true
//            day.didColdShower = true
//            day.didDiet = true
//            day.didCriticalTaskOne = true
//            day.didCriticalTaskTwo = true
//            day.didSocialMediaLimit = true
//            day.didStayUnderDrinkLimit = true
//            day.didMeditate = true
//        }
//        challenge.status = .completed
//        container.mainContext.insert(challenge)
//    }
    
    return NavigationStack(path: $path) {
        PreviousResultsView(path: $path)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
