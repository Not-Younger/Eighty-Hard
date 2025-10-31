//
//  TaskRow.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftData
import SwiftUI

struct TaskRow: View {
    let name: String
    @Binding var isComplete: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
            .foregroundColor(isComplete ? .red : .gray)
            .font(.title)
            .onTapGesture {
                withAnimation {
                    isComplete.toggle()
                }
            }
            Text(name)
        }
    }
}
