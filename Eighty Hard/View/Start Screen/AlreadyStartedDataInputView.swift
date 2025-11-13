//
//  AlreadyStartedDataInputView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/31/25.
//

import SwiftData
import SwiftUI

struct AlreadyStartedDataInputView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var challenge: Challenge
    @Binding var path: NavigationPath
    
    let columns = 7
    
    var body: some View {
        let days = (challenge.days ?? []).sorted { $0.date < $1.date }
        
        GeometryReader { geometry in
            let totalSpacing: CGFloat = CGFloat(columns - 1) * 8 // 8pt spacing between items
            let availableWidth = geometry.size.width - totalSpacing - 32 // minus horizontal padding
            let itemSize = availableWidth / CGFloat(columns)
            
            ScrollView {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                            .frame(width: 180, height: 180)
                        
                        Circle()
                            .trim(from: 0, to: challenge.daysCompletedFraction)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: challenge.daysCompletedFraction >= 1.0
                                        ? [.green]
                                        : [.red, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 180, height: 180)
                        
                        VStack(alignment: .center) {
                            Text("Day")
                                .font(.system(size: 18, weight: .medium))
                            Text("\(challenge.currentDay?.number ?? 80) / 80")
                                .font(.system(size: 32, weight: .bold))
                        }
                    }
                    .padding(.vertical, 40)
                    
                    HStack(alignment: .center, spacing: 12) {
                        // Circle with grade or encouragement color
                        ZStack {
                            Circle()
                                .fill(.red)
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "text.document.fill")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Sync Your Journey")
                                .bold()
                            Text("You’ve already put in the work — now let’s make sure your progress reflects that. Tap each past day and update your completed tasks.")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .lineLimit(nil)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                        .padding(.horizontal)
                    
                    // Grid of days
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns), spacing: 8) {
                        ForEach(days) { day in
                            Button {
                                path.append(Navigation.tasks(day: day))
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(day.completionColor)
                                        .frame(width: abs(itemSize), height: abs(itemSize))
                                    
                                    Text("\(day.number)")
                                        .font(.system(size: itemSize * 0.3, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 140)
            }
            .scrollIndicators(.hidden)
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            modelContext.insert(challenge)
                            path = NavigationPath()
                            path.append(challenge)
                        } label: {
                            Text("Continue 80 Hard")
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
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Data Input")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
    let challenge = Challenge()
    challenge.status = .completed
    
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
    
    container.mainContext.insert(challenge)
    
    return NavigationStack {
        AlreadyStartedDataInputView(challenge: challenge, path: $path)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
