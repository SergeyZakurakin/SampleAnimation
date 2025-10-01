//
//  CircleButton.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 10/1/25.
//

import SwiftUI

struct CircleButton: View {
    var system: String
    var action: () -> Void
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
                Image(systemName: system)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .opacity(0.6)
            }
            .frame(width: width, height: height)
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    CircleButton()
//}
