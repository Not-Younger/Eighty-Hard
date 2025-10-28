//
//  TasksView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftUI

struct TasksView: View {
    @Bindable var day: Day
    
    private var tasks: [(String, Binding<Bool>)] {
        [
            (Day.waterTaskText, $day.didDrinkWater),
            (Day.workoutTaskText, $day.didWorkout),
            (Day.dietTaskText, $day.didDiet),
            (Day.alcoholTaskText, $day.didStayUnderDrinkLimit),
            (Day.readingTaskText, $day.didReading),
            (Day.coldShowerTaskText, $day.didColdShower),
            (Day.criticalTaskText, $day.didCriticalTasks),
            (Day.meditateTaskText, $day.didMeditate),
            (Day.socialMediaTaskText, $day.didSocialMediaLimit)
        ]
    }
    
    private var completedCount: Int {
        tasks.filter { $0.1.wrappedValue }.count
    }
    
    private var totalCount: Int { tasks.count }
    
    private var isAllCompleted: Bool { completedCount == totalCount }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Day \(day.number)")
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                
                Text(isAllCompleted ? "🎉 All tasks completed!" : "\(completedCount) of \(totalCount) tasks completed")
                    .font(.headline)
                    .foregroundColor(isAllCompleted ? .primary : .secondary)
                    .animation(.easeInOut(duration: 0.3), value: completedCount)
                
                ProgressView(value: Double(completedCount), total: Double(totalCount))
                    .accentColor(.green)
                    .animation(.easeInOut(duration: 0.3), value: completedCount)
            }
            .padding(.bottom)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(tasks.indices, id: \.self) { index in
                        TaskRow(name: tasks[index].0, isComplete: Binding(
                            get: { tasks[index].1.wrappedValue },
                            set: { newValue in
                                tasks[index].1.wrappedValue = newValue
                                
                                // Haptic for individual task
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                
                                // Celebration haptic if all tasks completed
                                if completedCount == totalCount {
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            }
                        ))
                    }
                }
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Tasks")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let day = Day(number: 1)
    return NavigationStack {
        TasksView(day: day)
    }
}
