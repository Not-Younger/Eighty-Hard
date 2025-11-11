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
    @Query(filter: #Predicate<Challenge> { challenge in
        challenge.statusRaw != "In Progress"
    }) var challenges: [Challenge]
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            if challenges.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 48))
                        .foregroundStyle(.gray.opacity(0.8))
                    Text("No completed challenges yet.")
                        .font(.headline)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                List {
                    Group {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Track your journey of discipline and progress.")
                            
                            Text("This page shows all your previous 80 Hard challenges — completed, failed, or restarted. Reflect on your past attempts, celebrate your wins, and use what you’ve learned to push even harder this time.")
                        }
                        .padding(.vertical)
                        ForEach(challenges) { challenge in
                            Button {
                                path.append(Navigation.overview(challenge: challenge))
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Challenge \(challenge.id.prefix(8))")
                                            .font(.headline)
                                        
                                        Text("\(challenge.startDate.formatted(date: .abbreviated, time: .omitted)) → \(challenge.endDate.formatted(date: .abbreviated, time: .omitted))")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                        
                                        HStack {
                                            ProgressView(value: challenge.completionPercentage)
                                                .tint(.green)
                                                .frame(maxWidth: 120)
                                            Text(challenge.completedTasks.description + " / " + challenge.totalTasks.description)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16))
                                }
                                .padding(.vertical, 6)
                                .foregroundStyle(.white)
                                .contentShape(Rectangle())
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
        }
        .navigationTitle("Previous Challenges")
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .background(
            LinearGradient(colors: [.black, .red], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
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
        for i in 0..<80 {
            let newDay = Day(number: i)
            challenge.days?.append(newDay)
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
        }
        challenge.status = .completed
        container.mainContext.insert(challenge)
    }
    
    return NavigationStack {
        PreviousResultsView(path: $path)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
