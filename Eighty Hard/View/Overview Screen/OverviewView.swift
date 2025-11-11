//
//  OverviewView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftData
import SwiftUI

struct OverviewView: View {
    @Bindable var challenge: Challenge
    @Binding var path: NavigationPath
    
    @State private var csvURL: URL?
    @State private var error: Error?
    
    let totalDots = 80
    let columns = 7
    
    // Progress based on completed days
    private var daysCompletionFraction: Double {
        let completedDays = Double((challenge.days ?? []).count)
        return completedDays / Double(totalDots)
    }
    
    var body: some View {
        let days = (challenge.days ?? []).sorted { $0.number < $1.number }
        
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
                            .trim(from: 0, to: daysCompletionFraction)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: daysCompletionFraction >= 1.0
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
                            Text("\(challenge.currentDay?.number ?? 0) / 80")
                                .font(.system(size: 32, weight: .bold))
                        }
                    }
                    .padding(.vertical, 40)
                    
                    ChallengeGradeView(challenge: challenge)
                        .padding(.horizontal)
                    
                    // Grid of days
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns), spacing: 8) {
                        ForEach(0..<totalDots, id: \.self) { index in
                            let dayNumber = index + 1
                            let day = days.first(where: { $0.number == dayNumber })
                            
                            Button {
                                path.append(Navigation.tasks(day: day, dayNumber: dayNumber))
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(day?.completionColor ?? Color.gray.opacity(0.3))
                                        .frame(width: abs(itemSize), height: abs(itemSize))
                                    
                                    Text("\(dayNumber)")
                                        .font(.system(size: itemSize * 0.3, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Overview")
        .onAppear {
            if let days = challenge.days {
                regenerateDocument(days)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let csvURL {
                    ShareLink(items: [csvURL]) {
                        Text("Export CSV")
                    }
                }
            }
        }
    }
    
    private func regenerateDocument(_ days: [Day]) {
        do {
            self.csvURL = nil
            self.error = nil
            let url = try generateCSV(days)
            self.csvURL = url
        } catch {
            self.error = error
        }
    }
    
    private func generateCSV(_ days: [Day]) throws -> URL {
        let destinationURL = URL.documentsDirectory.appendingPathComponent("Eighty-Hard-\(challenge.id).csv")
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }

        var rows: [[String]] = []

        // Header row
        let headers: [String] = [
            "Day",
            "Water Task",
            "Workout Task",
            "Diet Task",
            "Alcohol Task",
            "Read Task",
            "Cold Shower Task",
            "Meditate Task",
            "Social Media Task",
            "Critical Tasks",
            "Critical Task One",
            "Critical Task Two"
        ]
        rows.append(headers)

        // Data rows
        for day in days {
            var row: [String] = []

            row.append("\(day.number)")
            row.append(day.didDrinkWater ? "X" : "")
            row.append(day.didWorkout ? "X" : "")
            row.append(day.didDiet ? "X" : "")
            row.append(day.didStayUnderDrinkLimit ? "X" : "")
            row.append(day.didReading ? "X" : "")
            row.append(day.didColdShower ? "X" : "")
            row.append(day.didMeditate ? "X" : "")
            row.append(day.didSocialMediaLimit ? "X" : "")
            row.append(day.didCriticalTasks ? "X" : "")
            row.append(day.criticalTaskOne)
            row.append(day.criticalTaskTwo)
            
            rows.append(row)
        }
        
        for i in days.count...80 {
            var row: [String] = []
            
            row.append("\(i)")
            row.append("")
            row.append("")
            row.append("")
            row.append("")
            row.append("")
            row.append("")
            row.append("")
            row.append("")
            row.append("")
            row.append("")
            row.append("")
            
            rows.append(row)
        }

        // Convert to CSV string
        let csvString = rows.map { row in
            row.map { "\"\($0)\"" }.joined(separator: ",")
        }.joined(separator: "\n")

        try csvString.write(to: destinationURL, atomically: true, encoding: .utf8)

        return destinationURL
    }
    
    func escapeCSVField(_ field: String) -> String {
        let escaped = field.replacingOccurrences(of: "\"", with: "\"\"")
        return escaped
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
    let challenge = Challenge()
    challenge.status = .completed
    
    for i in 0...80 {
        let newDay = Day(number: i)
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
        challenge.days?.append(newDay)
    }
    
    container.mainContext.insert(challenge)
    
    return NavigationStack {
        OverviewView(challenge: challenge, path: $path)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
