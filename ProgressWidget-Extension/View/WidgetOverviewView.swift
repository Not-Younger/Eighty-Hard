//
//  WidgetOverviewView.swift
//  ProgressWidget-ExtensionExtension
//
//  Created by Jonathan Young on 11/11/25.
//

import SwiftUI

struct WidgetOverviewView: View {
    let days: [Day]
    
    var body: some View {
        GeometryReader { geometry in
            let maxWidth = geometry.size.width
            let maxHeight = geometry.size.height
            
            let spacing: CGFloat = 4
            let padding: CGFloat = 0
            
            // Compute best column count using functional style
            let gridOptions = (4...16).map { cols -> (cols: Int, itemSize: CGFloat) in
                let rows = ceil(Double(days.count) / Double(cols))
                let totalHSpacing = CGFloat(cols - 1) * spacing
                let totalVSpacing = CGFloat(rows - 1) * spacing
                let availableWidth = maxWidth - totalHSpacing - (padding * 2)
                let availableHeight = maxHeight - totalVSpacing - (padding * 2)
                let itemWidth = availableWidth / CGFloat(cols)
                let itemHeight = availableHeight / CGFloat(rows)
                let itemSize = min(itemWidth, itemHeight)
                return (cols, itemSize)
            }
            
            // Pick best configuration (largest fitting item)
            let best = gridOptions.max(by: { $0.itemSize < $1.itemSize }) ?? (cols: 10, itemSize: 10)
            
            let columns = Array(
                repeating: GridItem(.fixed(best.itemSize), spacing: spacing),
                count: best.cols
            )
            
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(days) { day in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(day.completionColor)
                        .frame(width: best.itemSize, height: best.itemSize)
                }
            }
            .padding(padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
