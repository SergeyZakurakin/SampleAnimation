//
//  AppIconView.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 10/1/25.
//

import SwiftUI

struct AppIconView: View {
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

#Preview {
    AppIconView()
}
