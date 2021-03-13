//
//  SmallPosterFrame.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 08.03.2021.
//

import SwiftUI

struct SmallPosterFrame: ViewModifier, SizeClassAdjustable {
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var vsc: UserInterfaceSizeClass? { _verticalSizeClass }
    var hsc: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    let size: CGSize
    
    func body(content: Content) -> some View {
        content
            .frame(width: isPad ? size.width / 5 :  isPadOrLandscapeMax ? size.height / 3 : size.width / 5.5, height: size.height - 10)
    }
}

extension View {
    func smallPosterFrame(geometrySize: CGSize) -> some View {
        self.modifier(SmallPosterFrame( size: geometrySize))
    }
    
}
