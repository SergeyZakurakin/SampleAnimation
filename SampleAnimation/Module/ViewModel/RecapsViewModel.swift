//
//  RecapsViewModel.swift
//  SampleAnimation
//
//  Created by Sergey Zakurakin on 10/1/25.
//

import SwiftUI

final class RecapsViewModel: ObservableObject {
    @Published var isExpanded: Bool = false
    @Published var selectedScope: Int = 0
}
