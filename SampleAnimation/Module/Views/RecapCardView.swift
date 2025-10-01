//
//  RecapCardView.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 10/1/25.
//

import SwiftUI

// MARK: - Card (2 states)
struct RecapCardView: View {
    @Binding var isExpanded: Bool
    
    private let collapsedHeight: CGFloat = 160
    private let expandedExtra: CGFloat = 120 // height of the button area
    
    // Unified expansion progress 0..1 – moves content like a "scroll"
    @State private var expandProgress: CGFloat = 0 // 0 = collapsed, 1 = expanded
    @State private var buttonsHeight: CGFloat = 0  // actual height of the buttons block
    
    var body: some View {
        VStack(spacing: 0) {
            header
            footerButtons
        }
        .frame(maxWidth: .infinity)
        .frame(
            height: isExpanded ? (collapsedHeight + expandedExtra) : collapsedHeight,
            alignment: .top
        )
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(alignment: .topTrailing) {
            CircleButton(system: "xmark", action: {}, width: 40, height: 30)
                .padding(10)
        }
        .clipped()
        .shadow(color: .black.opacity(0.1), radius: 2)
        .onAppear { expandProgress = isExpanded ? 1 : 0 }
        .onChange(of: isExpanded) { newValue in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                expandProgress = newValue ? 1 : 0
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.9), value: isExpanded)
    }
    
    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            AppIconView()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Enable Recap Alerts?")
                    .font(.headline)
                
                Text("Peak can notify you as soon as new recaps are ready.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 10) {
                    CapsuleButton(title: "Sure", filled: true) {}
                    
                    SpinningGearButton(isExpanded: $isExpanded, action: toggle)
                }
                .padding(.top, 14)
            }
            
            Spacer()
        }
        .padding(16)
    }
    
    private var footerButtons: some View {
        // Visible area under the divider grows with expansion progress
        let visibleHeight = max(0, expandedExtra * expandProgress)
        // Keep the button block pinned to the bottom of the visible area
        let topPadding = max(0, visibleHeight - buttonsHeight)
        
        return VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 1)
                .scaleEffect(x: max(0.0001, expandProgress), y: 1, anchor: .leading)
                .animation(.easeInOut(duration: 0.22), value: expandProgress)
                .padding(.top, 8)
            
            // "Window" below the divider, its height = visibleHeight
            ZStack(alignment: .top) {
                VStack(spacing: 20) {
                    // Content: buttons + measuring their height
                    ButtonsGrid()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(HeightReader($buttonsHeight))
                        .padding(.top, topPadding) // keep pinned to the bottom of the "window"
                    Spacer(minLength: 0)
                }
            }
            .frame(height: visibleHeight) // grows with the white background
            .clipped()                    // hard mask: "from under divider"
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    private func toggle() {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.9)) {
            isExpanded.toggle()
        }
    }
}

//#Preview {
//    RecapCardView(isExpanded: true)
//}



// MARK: - Buttons (no logic)
private struct ButtonsGrid: View {
    var body: some View {
        let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        LazyVGrid(columns: cols, spacing: 12) {
            DayPill("Day")
            DayPill("Week")
            DayPill("Month")
            DayPill("Year")
        }
    }
}


// MARK: - Height measurement
private struct HeightReader: View {
    @Binding var height: CGFloat
    init(_ height: Binding<CGFloat>) { _height = height }
    
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: HeightKey.self, value: geo.size.height)
        }
        .onPreferenceChange(HeightKey.self) { height = $0 }
    }
}


private struct HeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
