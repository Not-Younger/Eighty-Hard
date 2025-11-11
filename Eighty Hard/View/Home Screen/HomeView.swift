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
    @Environment(\.scenePhase) private var scenePhase
    @Environment(LocalNotificationManager.self) private var lnManager: LocalNotificationManager
    
    @AppStorage("carryOverCriticalTasks") private var carryOverCriticalTasks: Bool = false
    @AppStorage("isUsingNotifications") private var isUsingNotifications: Bool = false
    @AppStorage("notificationReminderTime") private var notificationReminderTime: Date = Date()
    
    @Bindable var challenge: Challenge
    @Binding var activeChallenge: Challenge?
    @Binding var path: NavigationPath
    
    @State private var isShowingFinishedAlert = false
    
    var body: some View {
        VStack {
            if let currentDay = challenge.currentDay {
                ZStack {
                    if currentDay.completedTasks == 9 {
                        LinearGradient(colors: [.black, .red], startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                    }
                    ScrollView {
                        TasksView(day: currentDay)
                    }
                    .scrollIndicators(.hidden)
                    .scrollBounceBehavior(.basedOnSize)
                }
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
                    path.append(Navigation.moreInfo)
                } label: {
                    Image(systemName: "info.circle")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    path.append(Navigation.settingsPage(challenge: challenge))
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
        .onAppear {
            updateCurrentDay()
        }
        .alert("Congratulations!", isPresented: $isShowingFinishedAlert) {
            Button("Complete") {
                challenge.status = .completed
                print("Challenge number of days: \(challenge.days!.count)")
                let day81 = challenge.days!.removeLast()
                modelContext.delete(day81) // Delete day 81
                activeChallenge = nil
                path = NavigationPath()
                print("Challenge number of days: \(challenge.days!.count)")
            }
        } message: {
            Text("You’ve completed all 80 days. That’s insane discipline. Well done. You can view this challenge in your previous challenges list.")
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    setNotifications()
                }
            }
        }
    }
    
    private func updateCurrentDay() {
        if let currentDay = challenge.currentDay {
            if currentDay.number > 80 {
                isShowingFinishedAlert = true
            } else if !Calendar.current.isDateInToday(currentDay.date) {
                let newDay = Day(number: currentDay.number + 1)
                print("New Day: \(newDay.number)")
                // Carry over critical tasks if selected
                if carryOverCriticalTasks {
                    newDay.criticalTaskOne = currentDay.criticalTaskOne
                    newDay.criticalTaskTwo = currentDay.criticalTaskTwo
                }
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
    
    func setNotifications() {
        if isUsingNotifications {
            Task {
                lnManager.clearRequests()
                var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: notificationReminderTime)
                for day in 0..<min(challenge.daysRemaining, 64) {
                    dateComponents.weekday = day
                    let uuid = "REMINDER_\(UUID().uuidString)"
                    let localNotification = LocalNotification(
                        identifier: uuid,
                        title: "Daily Tasks Reminder",
                        body: "Make sure to finalize your tasks for today!",
                        dateComponents: dateComponents,
                        repeats: true
                    )
                    await lnManager.schedule(localNotification: localNotification)
                }
            }
        } else {
            lnManager.clearRequests()
        }
    }
}

#Preview {
    @Previewable @State var lnManager = LocalNotificationManager()
    @Previewable @State var challenge = Challenge()
    @Previewable @State var activeChallenge: Challenge? = Challenge()
    @Previewable @State var path = NavigationPath()
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
    challenge.status = .inProgress
    container.mainContext.insert(challenge)
    
    return NavigationStack {
        HomeView(challenge: challenge, activeChallenge: $activeChallenge, path: $path)
            .modelContainer(container)
            .environment(lnManager)
            .preferredColorScheme(.dark)
            .tint(.red)
    }
}
