//
//  SmallPosterFrame.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 08.03.2021.
//

import SwiftUI

@available(iOS 13.0, *)
public struct SmallPosterFrame: ViewModifier, SizeClassAdjustable {
    
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    public var vsc: UserInterfaceSizeClass? { _verticalSizeClass }
    public var hsc: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    let size: CGSize
    
    public func body(content: Content) -> some View {
        content
            .frame(width: isPad ? size.width / 5 :  isPadOrLandscapeMax ? size.height / 3 : size.width / 5.5, height: size.height - 20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.all, 10)
    }
}

@available(iOS 13.0, *)
public extension View {
    func smallPosterFrame(geometrySize: CGSize) -> some View {
        self.modifier(SmallPosterFrame( size: geometrySize))
    }
}
