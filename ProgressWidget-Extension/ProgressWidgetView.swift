//
//  ProgressWidgetView.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/11/25.
//

import SwiftData
import WidgetKit
import SwiftUI

struct ProgressWidgetView: View {
    @Query private var challenges: [Challenge]
    var entry: ProgressProvider.Entry

    var body: some View {
        // Get current challenge from SwiftData
        let challenge = challenges.filter { $0.status == .inProgress }.sorted { $0.startDate < $1.startDate }.first ?? Challenge()
        let days = (challenge.days ?? []).sorted { $0.number < $1.number }
        
        Group {
            WidgetOverviewView(days: days)
            if let currentDay = challenge.currentDay {
                WidgetTaskCompletionView(currentDay: currentDay, circleSize: 8)
            }
        }
        .containerBackground(for: .widget) {
            Color.black
        }
    }
}
