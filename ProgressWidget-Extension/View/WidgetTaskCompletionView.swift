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
    let isSmallWidget: Bool
    
    var body: some View {
        if isSmallWidget {
            VStack {
                HStack {
                    Group {
                        Icon(currentDay.didDrinkWater, systemName: "drop.fill")
                        Icon(currentDay.didWorkout, systemName: "figure.run")
                        Icon(currentDay.didDiet, systemName: "fork.knife")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(.red)
                }
                HStack {
                    Group {
                        Icon(currentDay.didStayUnderDrinkLimit, systemName: "hand.raised.fill")
                        Icon(currentDay.didReading, systemName: "book.fill")
                        Icon(currentDay.didColdShower, systemName: "snowflake")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(.red)
                }
                HStack {
                    Group {
                        Icon(currentDay.didMeditate, systemName: "apple.meditate")
                        Icon(currentDay.didSocialMediaLimit, systemName: "clock.fill")
                        Icon(currentDay.didCriticalTasks, systemName: "checkmark")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundStyle(.red)
                }
            }
        } else {
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
    
    @ViewBuilder
    private func Icon(_ isDone: Bool, systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(isDone ? .red : Color.gray.opacity(0.3))
            Image(systemName: systemName)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.black)
        }
    }
}
