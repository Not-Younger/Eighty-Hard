//
//  PreviousResults.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/28/25.
//

import SwiftData
import SwiftUI

struct PreviousResults: View {
    @Query private var previousChallenges: [Challenge]
    
    init() {
        _previousChallenges = Query(filter: #Predicate {
            $0.isCompleted == true
        }, sort: \.endDate, order: .reverse)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if previousChallenges.isEmpty {
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
                        ForEach(previousChallenges) { challenge in
                            NavigationLink {
                                OverviewView(challenge: challenge)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Challenge \(challenge.id.prefix(4))")
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
                                .padding(.vertical, 6)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle("Previous Challenges")
                }
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
    
    return PreviousResults()
        .modelContainer(container)
}
