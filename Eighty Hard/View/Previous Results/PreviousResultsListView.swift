//
//  PreviousResultsListView.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/15/25.
//

import SwiftData
import SwiftUI

struct PreviousResultsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Challenge> { challenge in
        challenge.statusRaw != "In Progress"
    }, sort: \.startDate, order: .reverse) var challenges: [Challenge]
    
    @Binding var path: NavigationPath
    
    var body: some View {
        List {
            Group {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Track your journey of discipline and progress.")
                    
                    Text("This page shows all your previous 80 Hard challenges — both completed or quit. Reflect on your past attempts, celebrate your wins, and use what you’ve learned to push even harder this time.")
                }
                ForEach(challenges) { challenge in
                    Button {
                        path.append(Navigation.overview(challenge: challenge))
                    } label: {
                        PreviousResultsRowView(challenge: challenge, path: $path)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .onDelete(perform: deleteChallenge)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.visible, edges: [.top, .bottom])
        }
        .listStyle(.plain)
    }
    
    func deleteChallenge(at offsets: IndexSet) {
        for offset in offsets {
            let challenge = challenges[offset]
            modelContext.delete(challenge)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
    for _ in 0..<1 {
        let challenge = Challenge()
        for day in challenge.days ?? [] {
            day.didDrinkWater = true
            day.didWorkout = true
            day.didReading = true
            day.didColdShower = true
            day.didDiet = true
            day.didCriticalTaskOne = true
            day.didCriticalTaskTwo = true
            day.didSocialMediaLimit = true
            day.didStayUnderDrinkLimit = true
            day.didMeditate = true
        }
        challenge.status = .completed
        container.mainContext.insert(challenge)
    }
    
    return NavigationStack {
        PreviousResultsListView(path: $path)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
