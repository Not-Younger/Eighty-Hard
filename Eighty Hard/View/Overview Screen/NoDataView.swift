//
//  NoDataView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/31/25.
//

import SwiftUI
import SwiftData

struct NoDataView: View {
    let day: Day
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(.gray.opacity(0.7))
                .padding(.top, 80)
            
            Text("No Data for Day \(day.number)")
                .font(.title3.bold())
                .foregroundStyle(.white.opacity(0.9))
            
            Group {
                Text("This date is in the future or the challenge was quit before it happened and can't be tracked yet.")
            }
            .font(.subheadline)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            Button {
                path.removeLast()
            } label: {
                Text("Go Back")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(day.date.formatted(.dateTime.month().day().year()))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    @Previewable @State var challenge = Challenge()
    let challengeConfig = ModelConfiguration(for: Challenge.self, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Challenge.self, configurations: challengeConfig)

    container.mainContext.insert(challenge)
    
    return NavigationStack {
        NoDataView(day: challenge.days?.first ?? Day(number: 1, date: Date()), path: $path)
            .modelContainer(container)
            .preferredColorScheme(.dark)
            .tint(.red)
    }
}
