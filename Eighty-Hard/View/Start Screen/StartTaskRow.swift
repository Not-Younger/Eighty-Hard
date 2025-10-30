//
//  StartTaskRow.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftUI

struct StartTaskRow: View {
    let number: Int
    let task: String
    let systemImage: String
    
    init(_ number: Int, _ task: String, systemImage: String) {
        self.number = number
        self.task = task
        self.systemImage = systemImage
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Text("\(number).")
                .bold()
            Image(systemName: systemImage)
                .frame(width: 24)
            Text("\(task)")
                .bold()
        }
        .foregroundColor(.white)
        .padding(.vertical, 5)
    }
}
