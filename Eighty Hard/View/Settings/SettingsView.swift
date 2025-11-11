//
//  SettingsView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/28/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("carryOverCriticalTasks") private var carryOverCriticalTasks: Bool = false
    
    @Bindable var challenge: Challenge
    @Binding var activeChallenge: Challenge?
    @Binding var path: NavigationPath
    
    @State private var csvURL: URL?
    @State private var error: Error?
    @State private var isShowingEndChallengeAlert = false
    @State private var isShowingDeleteChallengeAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section("Export Data") {
                    Text("Export your data into CSV format.")
                    if let csvURL {
                        ShareLink(items: [csvURL]) {
                            HStack {
                                Spacer()
                                Text("Export CSV")
                                Spacer()
                            }
                        }
                    }
                }
                
                Section {
                    Toggle("Carry over critical tasks", isOn: $carryOverCriticalTasks)
                } header: {
                    Text("Preferences")
                } footer: {
                    Text("This will carry your previous day's critical tasks over to the next day.")
                }
                
                Section("End or Delete Challenge") {
                    Button(role: .destructive) {
                        isShowingEndChallengeAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Quit Challenge")
                            Spacer()
                        }
                    }
                    Button(role: .destructive) {
                        isShowingDeleteChallengeAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Challenge")
                            Spacer()
                        }
                    }
                }
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    return 0
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let days = challenge.days {
                regenerateDocument(days)
            }
        }
        .alert("Are you sure?", isPresented: $isShowingEndChallengeAlert) {
            Button("Quit Challenge", role: .destructive) {
                challenge.status = .quit
                activeChallenge = nil
                path = NavigationPath()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will quit your current challenge and mark it as incomplete. It will still show up in your previous challenges.")
        }
        .alert("Are you sure?", isPresented: $isShowingDeleteChallengeAlert) {
            Button("Delete Challenge", role: .destructive) {
                modelContext.delete(challenge)
                activeChallenge = nil
                path = NavigationPath()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete your current challenge and all data associated with it. This action cannot be undone.")
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
        let destinationURL = URL.documentsDirectory.appendingPathComponent("80Hard-\(challenge.id).csv")
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
    @Previewable @State var challenge = Challenge()
    @Previewable @State var activeChallenge: Challenge? = Challenge()
    @Previewable @State var path = NavigationPath()
    
    SettingsView(challenge: challenge, activeChallenge: $activeChallenge, path: $path)
        .colorScheme(.dark)
}
