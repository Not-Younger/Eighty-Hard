//
//  ChallengeGradeView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/30/25.
//

import SwiftUI

struct ChallengeGradeView: View {
    let challenge: Challenge
    
    // Minimum days before grading starts
    private let minDaysForGrade = 3
    
    // completionPercentage as fraction 0.0–1.0
    private var completionFraction: Double {
        min(max(challenge.completionPercentage, 0), 1)
    }
    
    private var grade: String? {
        guard (challenge.days?.count ?? 0) >= minDaysForGrade else { return nil }
        
        switch completionFraction {
        case 1.0: return "S"
        case 0.9..<1.0: return "A"
        case 0.8..<0.9: return "B"
        case 0.7..<0.8: return "C"
        case 0.6..<0.7: return "D"
        case 0: return "F-"
        default: return "F"
        }
    }
    
    private var gradeColor: Color {
        guard let grade = grade else { return .red }
        switch grade {
        case "S": return .purple
        case "A": return .green.opacity(0.7)
        case "B": return .yellow.opacity(0.9)
        case "C": return .orange.opacity(0.9)
        case "D": return .red.opacity(0.7)
        case "F": return .red
        default: return .red.opacity(0.5)
        }
    }
    
    private var performanceText: String {
        let percentage = String(format: "%.2f", completionFraction * 100)
        
        // Encouragement before grading
        if (challenge.days?.count ?? 0) < minDaysForGrade {
            return "Keep going! Complete a few more days to see your performance grade."
        }
        
        // Adaptive grading text
        switch grade {
        case "S": return "You're on fire! You've completed 100% of your tasks. Keep up the incredible work!"
        case "A": return "Amazing! You’ve completed \(percentage)% of your tasks. Keep up the great work!"
        case "B": return "Great job! You’re at \(percentage)% of your tasks. Stay consistent and push a little further!"
        case "C": return "Not bad! \(percentage)% of your tasks completed. You can reach the next level with some extra effort."
        case "D": return "Getting there. \(percentage)% of your tasks done. Focus on building momentum!"
        case "F": return "Time to get going! Only \(percentage)% of your tasks completed. You’ve got this—take it one task at a time."
        default: return "Time to get started! None of your tasks are completed. You’ve got this—take it one task at a time."
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Circle with grade or encouragement color
            ZStack {
                Circle()
                    .fill(gradeColor)
                    .frame(width: 60, height: 60)
                
                if let grade = grade {
                    if grade == "F-" {
                        Text("😢")
                            .font(.system(size: 28))
                    } else {
                        Text(grade)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.white)
                    }
                } else {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Performance")
                    .bold()
                Text(performanceText)
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
