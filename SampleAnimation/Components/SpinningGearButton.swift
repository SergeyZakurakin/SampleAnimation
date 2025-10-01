//
//  SpinningGearButton.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 10/1/25.
//

import SwiftUI

// MARK: - Gear with reverse rotation on expand/collapse
struct SpinningGearButton: View {
    @Binding var isExpanded: Bool
    var action: () -> Void

    @State private var turns: Int = 0   // number of "half turns" by 180°

    var body: some View {
        Button {
            action() // toggle expansion -> triggers rotation
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
                Image(systemName: "gear")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary.opacity(0.6))
                    .rotationEffect(.degrees(Double(turns) * 180))
                    .animation(.easeInOut(duration: 0.45), value: turns)
            }
            .frame(width: 54, height: 40)
        }
        .buttonStyle(.plain)
        .onChange(of: isExpanded) { newValue in
            // expand → rotate forward, collapse → rotate backward
            turns += newValue ? 1 : -1
        }
    }
}


//#Preview {
//    SpinningGearButton()
//}
