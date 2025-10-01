//
//  ContentView.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 9/30/25.
//


import SwiftUI

struct RecapsView: View {
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
                RecapCardView(isExpanded: $vm.isExpanded)
                    
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


struct RecapsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecapsView()
            .preferredColorScheme(.light)
    }
}
