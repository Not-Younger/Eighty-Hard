//
//  HomeView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var challenge: Challenge
    @Binding var activeChallenge: Challenge?
    @Binding var path: NavigationPath
    
    @State private var isShowingSettings = false
    
    var body: some View {
        VStack {
            if let currentDay = challenge.currentDay {
                Group {
                    if currentDay.completedTasks == 9 {
                        ScrollView {
                            TasksView(day: currentDay)
                        }
                        .background(
                            LinearGradient(colors: [.black, .red], startPoint: .top, endPoint: .bottom)
                                .ignoresSafeArea()
                        )
                    } else {
                        ScrollView {
                            TasksView(day: currentDay)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollBounceBehavior(.basedOnSize)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("80 Hard")
        .navigationBarBackButtonHidden(true)
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Image(systemName: "info.circle")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    isShowingSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
                Button {
                    path.append(Navigation.overview(challenge: challenge))
                } label: {
                    Image(systemName: "calendar")
                }
            }
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView(challenge: challenge, activeChallenge: $activeChallenge, path: $path)
        }
        .onAppear {
            if let currentDay = challenge.currentDay {
                let dayNumber = challenge.days!.count + 1
                if dayNumber > 80 {
                    
                } else if !Calendar.current.isDateInToday(currentDay.date) {
                    let newDay = Day(number: dayNumber)
                    newDay.challenge = challenge
                    modelContext.insert(newDay)
                    challenge.days?.append(newDay)
                }
            } else {
                // Day 1
                let newDay = Day(number: 1)
                newDay.challenge = challenge
                modelContext.insert(newDay)
                challenge.days?.append(newDay)
            }
        }
    }
}
