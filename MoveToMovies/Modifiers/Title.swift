//
//  Title.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

import Foundation
import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.system(size: 45, weight: .black))
            .lineLimit(1)
            .padding([.leading, .top, .trailing])
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}
