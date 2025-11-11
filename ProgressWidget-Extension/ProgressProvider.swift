//
//  ProgressProvider.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/11/25.
//

import SwiftData
import SwiftData
import WidgetKit

struct ProgressProvider: TimelineProvider {
    private let placeholderEntry: ProgressEntry = ProgressEntry(date: Date())
    
    func placeholder(in context: Context) -> ProgressEntry {
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ProgressEntry) -> ()) {
        completion(placeholderEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ProgressEntry>) -> Void) {
        // Create a single entry for the current time.
        let entry = ProgressEntry(date: Date())
        
        // Return a timeline with the single entry that doesn't refresh
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}
