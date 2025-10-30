//
//  StartTaskRow.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/27/25.
//

import SwiftUI

struct StartScreenTaskRow: View {
    let number: Int
    let title: String
    let description: String
    let systemImage: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(.white.opacity(0.2)))
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: systemImage)
                        .foregroundStyle(.white.opacity(0.9))
                    Text(title)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .lineLimit(2)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
