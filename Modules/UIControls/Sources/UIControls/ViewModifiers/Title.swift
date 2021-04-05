//
//  Title.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)

public struct Title: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.system(size: 45, weight: .black))
            .lineLimit(1)
            .padding(.horizontal, 16)
            .padding(.top, 44)
    }
}

@available(iOS 13.0, *)
public extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}
#endif
