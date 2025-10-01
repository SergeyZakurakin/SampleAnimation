//
//  CapsuleButton.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 10/1/25.
//

import SwiftUI

struct CapsuleButton: View {
    var title: String
    var filled: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(height: 40)
                .frame(minWidth: 80)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(filled ? Color.pink.opacity(0.8) : Color(.systemGray5))
                )
                .foregroundColor(filled ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    CapsuleButton()
//}
