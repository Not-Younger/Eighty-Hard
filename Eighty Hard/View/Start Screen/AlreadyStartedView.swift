//
//  AlreadyStartedView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/30/25.
//

import SwiftData
import SwiftUI

struct AlreadyStartedView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var activeChallenge: Challenge?
    @Binding var path: NavigationPath
    
    @State private var startDate = Date()
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        Form {
            Section {
                Text("No problem. Let’s get you synced up so your progress reflects where you’re at.")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            
            Section("Progress Details") {
                DatePicker("Start Date", selection: $startDate, in: ...Date(), displayedComponents: .date)
            }
        }
        .navigationTitle("Already started?")
        .navigationBarTitleDisplayMode(.inline)
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .background(.clear)
        .cornerRadius(15)
        .onTapGesture { isTextFieldFocused = false }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        let newChallenge = Challenge(startDate: startDate)
                        activeChallenge = newChallenge
                        path.append(Navigation.alreadyStartedDataInput(challenge: newChallenge))
                    } label: {
                        Text("Continue")
                            .font(.title2.bold())
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
}

#Preview {
    @Previewable @State var path = NavigationPath()
    @Previewable @State var activeChallenge: Challenge? = Challenge()
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)
    
    return NavigationStack {
        AlreadyStartedView(activeChallenge: $activeChallenge, path: $path)
            .modelContainer(container)
            .preferredColorScheme(.dark)
    }
}
