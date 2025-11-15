//
//  PreviousResultsRowView.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/15/25.
//

import SwiftUI

struct PreviousResultsRowView: View {
    let challenge: Challenge
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack(alignment: .top) {
            Group {
                switch challenge.status {
                case .inProgress:
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.orange)
                case .quit:
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                case .completed:
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .font(.system(size: 18, weight: .bold, design: .monospaced))
            VStack(alignment: .leading, spacing: 4) {
                Text("Challenge \(challenge.id.prefix(8))")
                    .font(.headline)
                
                let startDate = challenge.startDate.formatted(date: .abbreviated, time: .omitted)
                let endDate = challenge.endDate.formatted(date: .abbreviated, time: .omitted)
                Text("\(startDate) → \(endDate) (^[\(challenge.daysCompleted) days](inflect: true))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack {
                    ProgressView(value: challenge.completionFractionAllTasks)
                        .tint(.green)
                        .frame(maxWidth: 120)
                    Text("\(challenge.completedTasks) / \(challenge.totalTasks)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 16))
        }
        .padding(.vertical, 6)
        .foregroundStyle(.white)
        .contentShape(Rectangle())
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let challenge = Challenge()
    List {
        PreviousResultsRowView(challenge: challenge, path: $path)
    }
}
