//
//  Header.swift
//  Created by Dmitry Samartcev on 14.04.2021.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct Header: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
            .font(Font.system(size: 16, weight: .bold))
            .lineLimit(1)
            .foregroundColor(.secondary)
            .padding(.horizontal, 16)
    }
}

@available(iOS 13.0, *)
public extension View {
    func headerStyle() -> some View {
        self.modifier(Header())
    }
}
#endif
