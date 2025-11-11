//
//  WidgetTaskCompletionView.swift
//  ProgressWidget-ExtensionExtension
//
//  Created by Jonathan Young on 11/11/25.
//

import SwiftUI

struct WidgetTaskCompletionView: View {
    let currentDay: Day
    let circleSize: CGFloat
    
    var body: some View {
        HStack {
            HStack {
                Group {
                    Image(systemName: "drop.circle.fill")
                        .foregroundStyle(currentDay.didDrinkWater ? .red : Color.gray.opacity(0.3))
                    Image(systemName: "figure.run.circle.fill")
                        .foregroundStyle(currentDay.didWorkout ? .red : Color.gray.opacity(0.3))
                    Image(systemName: "fork.knife.circle.fill")
                        .foregroundStyle(currentDay.didDiet ? .red : Color.gray.opacity(0.3))
                    Image(systemName: "hand.raised.circle.fill")
                        .foregroundStyle(currentDay.didStayUnderDrinkLimit ? .red : Color.gray.opacity(0.3))
                    Image(systemName: "book.circle.fill")
                        .foregroundStyle(currentDay.didReading ? .red : Color.gray.opacity(0.3))
                    Image(systemName: "snowflake.circle.fill")
                        .foregroundStyle(currentDay.didColdShower ? .red : Color.gray.opacity(0.3))
                    Image(systemName: "apple.meditate.circle.fill")
                        .foregroundStyle(currentDay.didMeditate ? .red : Color.gray.opacity(0.3))
                    Image(systemName: "timer.circle.fill")
                        .foregroundStyle(currentDay.didSocialMediaLimit ? .red : Color.gray.opacity(0.3))
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(currentDay.didCriticalTasks ? .red : Color.gray.opacity(0.3))
                }
                .frame(width: circleSize, height: circleSize)
                .padding(.horizontal, 4)
            }
            Spacer()
            Text("\(currentDay.number) / 80")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.gray.opacity(0.8))
        }
    }
}
