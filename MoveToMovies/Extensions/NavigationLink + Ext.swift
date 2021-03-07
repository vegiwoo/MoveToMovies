//
//  NavigationLink + Ext.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.03.2021.
//

import SwiftUI

extension NavigationLink where Label == EmptyView {
    init?<Value>(_ binding: Binding<Value?>, @ViewBuilder destination: (Value) -> Destination) {
        guard let value = binding.wrappedValue else { return nil }
        
        let isActive = Binding(
            get: { true },
            set: { newValue in if !newValue { binding.wrappedValue = nil } }
        )
        
        self.init(destination: destination(value), isActive: isActive, label: EmptyView.init)
    }
}
