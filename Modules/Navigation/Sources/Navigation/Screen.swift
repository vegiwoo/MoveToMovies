//  Screen.swift
//  Created by Dmitry Samartcev on 25.03.2021.

#if canImport(SwiftUI)
import SwiftUI

/// Represents entity of a single screen (view) in SwiftUI
@available(iOS 13.0, *)
public struct Screen: Identifiable  {
    public let id: UUID
    public let nextScreen: AnyView
}

@available(iOS 13.0, *)
extension Screen: Equatable {
    public static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
}
#endif
