//
//  TasksView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftUI

struct TasksView: View {
    @Bindable var day: Day
    
    @State private var isShowingCriticalTaskAlert: Bool = false
    
    private var tasks: [(String, Binding<Bool>)] {
        [
            (Day.waterTaskTitle, $day.didDrinkWater),
            (Day.workoutTaskTitle, $day.didWorkout),
            (Day.dietTaskTitle, $day.didDiet),
            (Day.alcoholTaskTitle, $day.didStayUnderDrinkLimit),
            (Day.readingTaskTitle, $day.didReading),
            (Day.coldShowerTaskTitle, $day.didColdShower),
            (Day.meditateTaskTitle, $day.didMeditate),
            (Day.socialMediaTaskTitle, $day.didSocialMediaLimit)
        ]
    }
    
    private var completedCount: Int {
        tasks.filter { $0.1.wrappedValue }.count
    }
    
    private var totalCount: Int { tasks.count }
    
    private var isAllCompleted: Bool { completedCount == totalCount }
    
    // Computed color based on completion percentage
    private var progressColor: Color {
        let fraction = Double(completedCount) / Double(totalCount)
        switch fraction {
        case 1: return .red
        default:
            return .orange
        }
    }
    
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
                    .accentColor(progressColor)
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
                    HStack {
                        Image(systemName: day.didCriticalTasks ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(day.didCriticalTasks ? .red : .gray)
                            .font(.title)
                            .onTapGesture {
                                withAnimation {
                                    if day.critcalTaskOne.isEmpty || day.critcalTaskTwo.isEmpty {
                                        isShowingCriticalTaskAlert.toggle()
                                    } else if !day.critcalTaskOne.isEmpty && !day.critcalTaskTwo.isEmpty {
                                        let newValue = !day.didCriticalTasks
                                        day.didCriticalTaskOne = newValue
                                        day.didCriticalTaskTwo = newValue
                                    }
                                }
                            }
                        Text(Day.criticalTaskTitle)
                    }
                    Group {
                        HStack {
                            Image(systemName: day.didCriticalTaskOne ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(day.didCriticalTaskOne ? .red : .gray)
                                .font(.title)
                                .onTapGesture {
                                    withAnimation {
                                        if day.critcalTaskOne.isEmpty {
                                            isShowingCriticalTaskAlert.toggle()
                                        } else {
                                            day.didCriticalTaskOne.toggle()
                                        }
                                    }
                                }
                            TextField("Task One", text: $day.critcalTaskOne)
                                .onChange(of: day.critcalTaskOne) { _, newValue in
                                    withAnimation {
                                        if newValue.isEmpty {
                                            day.didCriticalTaskOne = false
                                        }
                                    }
                                }
                        }
                        HStack {
                            Image(systemName: day.didCriticalTaskTwo ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(day.didCriticalTaskTwo ? .red : .gray)
                                .font(.title)
                                .onTapGesture {
                                    withAnimation {
                                        if day.critcalTaskTwo.isEmpty {
                                            isShowingCriticalTaskAlert.toggle()
                                        } else {
                                            day.didCriticalTaskTwo.toggle()
                                        }
                                    }
                                }
                            TextField("Task Two", text: $day.critcalTaskTwo)
                                .onChange(of: day.critcalTaskTwo) { _, newValue in
                                    withAnimation {
                                        if newValue.isEmpty {
                                            day.didCriticalTaskTwo = false
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.leading)
                    .padding(.leading)
                    .alert("Finish Critical Tasks", isPresented: $isShowingCriticalTaskAlert) {
                        Button("OK") { }
                    } message: {
                        Text("You can finish your critical tasks once they are filled in and checked off.")
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
