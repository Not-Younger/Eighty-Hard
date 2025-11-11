//
//  Progress_Widget_Extension.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/11/25.
//

import SwiftData
import WidgetKit
import SwiftUI

@main
struct Progress_Widget_Extension: Widget {
    let container: ModelContainer = DataModel.shared.modelContainer
    
    let kind: String = "Progress_Widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProgressProvider()) {
            ProgressWidgetView(entry: $0)
                .modelContainer(container)
        }
        .configurationDisplayName("Challenge Progress")
        .description("Overview of your progress on the 80 Hard challenge.")
        .supportedFamilies([
            .systemMedium
        ])
    }
}

#Preview(as: .systemMedium) {
    Progress_Widget_Extension()
} timeline: {
    ProgressEntry(date: .now)
}
