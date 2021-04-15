//
//  Info.swift
//  Created by Dmitry Samartcev on 14.04.2021.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct Info: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
            .font(Font.system(size: 18, weight: .regular))
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .multilineTextAlignment(.center)
    }
}

@available(iOS 13.0, *)
public extension View {
    func infoStyle() -> some View {
        self.modifier(Info())
    }
}
#endif

