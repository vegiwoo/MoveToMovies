//
//  Transition + Ext.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, *)
public extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading).combined(with: .opacity)
        let removal = AnyTransition.scale.combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
#endif
