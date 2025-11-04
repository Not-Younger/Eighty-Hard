//
//  MoreInfoView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/31/25.
//

import SwiftUI

struct MoreInfoView: View {
    @Binding var path: NavigationPath
    
    @State private var animateGradient = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .foregroundStyle(
                            LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(animateGradient ? 360 : 0))
                        .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: animateGradient)
                    
                    Text("80 Hard")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top, 50)
                .onAppear { animateGradient = true }
                
                Text("Complete these 9 tasks daily for 80 days in a row.")
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    StartScreenTaskRow(
                        number: 1,
                        title: Day.waterTaskTitle,
                        description: Day.waterTaskDescription,
                        systemImage: Day.waterTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 2,
                        title: Day.workoutTaskTitle,
                        description: Day.workoutTaskDescription,
                        systemImage: Day.workoutTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 3,
                        title: Day.dietTaskTitle,
                        description: Day.dietTaskDescription,
                        systemImage: Day.dietTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 4,
                        title: Day.alcoholTaskTitle,
                        description: Day.alcoholTaskDescription,
                        systemImage: Day.alcoholTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 5,
                        title: Day.readingTaskTitle,
                        description: Day.readingTaskDescription,
                        systemImage: Day.readingTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 6,
                        title: Day.coldShowerTaskTitle,
                        description: Day.coldShowerTaskDescription,
                        systemImage: Day.coldShowerTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 7,
                        title: Day.meditateTaskTitle,
                        description: Day.meditateTaskTitle,
                        systemImage: Day.meditateTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 8,
                        title: Day.socialMediaTaskTitle,
                        description: Day.socialMediaTaskDescription,
                        systemImage: Day.socialMediaTaskIcon
                    )
                    
                    StartScreenTaskRow(
                        number: 9,
                        title: Day.criticalTaskTitle,
                        description: Day.criticalTaskDescription,
                        systemImage: Day.criticalTaskIcon
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .padding(.horizontal)
        }
        .navigationTitle("More Info")
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: [.black, .red], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    return NavigationStack {
        MoreInfoView(path: $path)
    }
}
