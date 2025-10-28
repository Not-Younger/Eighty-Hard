//
//  SettingsView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/28/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let challenge: Challenge
    
    @State private var isShowingEndChallengeAlert = false
    
    var body: some View {
        VStack {
            Button(role: .destructive) {
                isShowingEndChallengeAlert = true
            } label: {
                Text("End Challenge")
            }
        }
        .alert("Are you sure you want to stop 80 Hard?", isPresented: $isShowingEndChallengeAlert) {
            Button("Delete Challenge", role: .destructive) {
                dismiss()
            }
            Button("End Challenge", role: .cancel) {
                challenge.isEnded = true
            }
        } message: {
            Text("You can delete the challenge and all of its data or you can end your attempt and keep record of it.")
        }

    }
}
