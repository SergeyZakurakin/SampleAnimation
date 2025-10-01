//
//  ContentView.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 9/30/25.
//


import SwiftUI

// MARK: - ViewModel (MVVM)
final class RecapsViewModel: ObservableObject {
    @Published var isExpanded: Bool = false
    @Published var selectedScope: Int = 0
}

// MARK: - Screen
struct RecapsScreen: View {
    @StateObject private var vm = RecapsViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 14) {
                HStack {
                    CircleButton(system: "xmark", action: {}, width: 20, height: 40)
                    
                    Spacer()
                    Text("Recaps")
                        .font(.title3.weight(.semibold))
                    Spacer()
                }
                
                // Card (expands down)
                RecapCard(isExpanded: $vm.isExpanded)
                    
                Picker("Scope", selection: $vm.selectedScope) {
                    Text("Day").tag(0)
                    Text("Week").tag(1)
                    Text("Month").tag(2)
                    Text("Year").tag(3)
                }
                .pickerStyle(.segmented)
               
                Text("30 September")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }
}

// MARK: - Card (2 states)
struct RecapCard: View {
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
            AppIcon()
            
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

// MARK: - Helper Views
struct AppIcon: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(LinearGradient(colors: [.pink, .purple], startPoint: .bottomLeading, endPoint: .topTrailing))
                .frame(width: 54, height: 54)
            Circle().fill(Color.red)
                .frame(width: 16, height: 16)
                .offset(x: 4, y: -4)
        }
    }
}

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

// MARK: - Preview
struct RecapsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecapsScreen()
            .preferredColorScheme(.light)
    }
}
