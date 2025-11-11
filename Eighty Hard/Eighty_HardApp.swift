//
//  Eighty_HardApp.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftData
import SwiftUI

@main
struct Eighty_HardApp: App {
    let container: ModelContainer = DataModel.shared.modelContainer
    let lnManager = LocalNotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    try? await lnManager.requestAuthorization()
                }
        }
        .modelContainer(container)
        .environment(lnManager)
    }
}
