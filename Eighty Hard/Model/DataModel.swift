//
//  DataModel.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/11/25.
//

import SwiftUI
import SwiftData

actor DataModel {
    static let shared = DataModel()
    private init() {}
    
    nonisolated lazy var modelContainer: ModelContainer = {
        let schema = Schema([Challenge.self])
        let config = ModelConfiguration("Eighty Hard", schema: schema)
        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container: \(error)")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
        return modelContainer
    }()
}
