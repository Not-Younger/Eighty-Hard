//
//  ChallengeGradeView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/30/25.
//

import SwiftUI

struct ChallengeGradeView: View {
    let challenge: Challenge
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Circle with grade or encouragement color
            ZStack {
                Circle()
                    .fill(challenge.gradeColor)
                    .frame(width: 60, height: 60)
                
                if let grade = challenge.grade {
                    Text(grade)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                } else {
                    Group {
                        if challenge.status == .inProgress {
                            Image(systemName: "hand.thumbsup.fill")
                        } else {
                            Image(systemName: "xmark")
                        }
                    }
                    .foregroundColor(.white)
                    .font(.title2)
                }
            }
            
            VStack(alignment: .leading) {
                Text(challenge.status == .inProgress ? "Performance" : "Final Grade")
                    .bold()
                
                Group {
                    if challenge.status != .inProgress && challenge.daysCompleted < Challenge.daysBeforeGrade {
                        Text("You didn't complete enough days to get a final grade.")
                    } else if challenge.status == .quit {
                        let percentage = String(format: "%.2f", challenge.completionPercentage)
                        Text("You completed \(percentage)% of your tasks through \(challenge.daysCompleted) days.")
                    } else if challenge.status == .completed {
                        let percentage = String(format: "%.2f", challenge.completionPercentage)
                        Text("You completed \(percentage)% of your tasks.")
                    } else {
                        Text(challenge.performanceText)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
