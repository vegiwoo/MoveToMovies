//
//  View + Ext.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.03.2021.
//

import SwiftUI

extension View {
    @ViewBuilder
    func navigate<Value, Destination: View>( using binding: Binding<Value?>, @ViewBuilder destination: (Value) -> Destination) -> some View {
        background(NavigationLink(binding, destination: destination))
    }
}
