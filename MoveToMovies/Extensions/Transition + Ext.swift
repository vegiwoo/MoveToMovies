//
//  Transition + Ext.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 10.03.2021.
//

import SwiftUI

extension AnyTransition {
    
    public static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading).combined(with: .opacity)
        let removal = AnyTransition.scale.combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

