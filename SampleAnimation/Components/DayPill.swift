//
//  DayPill.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 10/1/25.
//

import SwiftUI

struct DayPill: View {
    var title: String
    @State private var isSelected = false
    init(_ title: String) { self.title = title }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.pink.opacity(0.8))
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(isSelected ? Color.green : Color.pink.opacity(0.8))
                .opacity(1)
        }
        .padding(.horizontal, 16)
        .frame(height: 34)
        .background(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.pink.opacity(0.18))
        )
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

//#Preview {
//    DayPill()
//}
