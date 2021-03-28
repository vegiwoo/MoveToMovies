//  RectanglePreferenceKey.swift
//  Created by Dmitry Samartcev on 28.03.2021.


#if canImport(SwiftUI)
import SwiftUI

public struct RectanglePreferenceKey: PreferenceKey {
    
    public static var defaultValue: CGRect = .zero
    
    public init() {}
    
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
#endif
