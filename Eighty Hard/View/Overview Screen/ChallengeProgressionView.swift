//
//  ChallengeProgressionView.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/15/25.
//

import SwiftUI

struct ChallengeProgressionView: View {
    let daysCompletedFraction: Double
    let currentDayNumber: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                .frame(width: 180, height: 180)
            
            Circle()
                .trim(from: 0, to: daysCompletedFraction)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .foregroundStyle(
                    LinearGradient(
                        colors: daysCompletedFraction >= 1.0
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
                Text("\(currentDayNumber) / 80")
                    .font(.system(size: 32, weight: .bold))
            }
        }
    }
}

#Preview {
    let challenge = Challenge()
    ChallengeProgressionView(daysCompletedFraction: challenge.daysCompletedFraction, currentDayNumber: challenge.currentDay?.number ?? 80)
}
