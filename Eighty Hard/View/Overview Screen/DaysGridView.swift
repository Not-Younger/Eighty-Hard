//
//  DaysGridView.swift
//  Eighty Hard
//
//  Created by Jonathan Young on 11/13/25.
//

import SwiftUI

struct DaysGridView: View {
    let days: [Day]
    let columns: Int
    let totalSpacing: CGFloat
    let availableWidth: CGFloat
    let itemSize: CGFloat
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            ForEach(["Sun","Mon","Tue","Wed","Thu","Fri","Sat"], id: \.self) { label in
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        
        // Grid of days
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns), spacing: 8) {
            let firstDay = days.first!
            let weekdayIndex = Calendar.current.component(.weekday, from: firstDay.date) // 1=Sun,7=Sat
            let leadingEmptySlots = weekdayIndex - 1
            
            ForEach(0..<leadingEmptySlots, id: \.self) { _ in
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.clear)
                        .frame(width: abs(itemSize), height: abs(itemSize))
                }
            }
            ForEach(days) { day in
                Button {
                    if day.isAccessible {
                        path.append(Navigation.tasks(day: day))
                    } else {
                        path.append(Navigation.noData(day: day))
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(day.completionColor)
                            .frame(width: abs(itemSize), height: abs(itemSize))
                        
                        Text("\(day.number)")
                            .font(.system(size: itemSize * 0.3, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
