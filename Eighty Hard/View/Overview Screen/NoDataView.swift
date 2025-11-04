//
//  NoDataView.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/31/25.
//

import SwiftUI

struct NoDataView: View {
    let dayNumber: Int
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(.gray.opacity(0.7))
                .padding(.top, 80)
            
            Text("No Data for Day \(dayNumber)")
                .font(.title3.bold())
                .foregroundStyle(.white.opacity(0.9))
            
            Text("This date is in the future and can't tracked yet.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                path.removeLast()
            } label: {
                Text("Go Back")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    
    return NoDataView(dayNumber: 1, path: $path)
}
