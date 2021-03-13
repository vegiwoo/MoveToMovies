//
//  BasicRootView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 13.03.2021.
//

import SwiftUI

struct BasicRootView: View, SizeClassAdjustable {
    @Environment(\.verticalSizeClass) var _verticalSizeClass
    @Environment(\.horizontalSizeClass) var _horizontalSizeClass
    var vsc: UserInterfaceSizeClass? { _verticalSizeClass }
    var hsc: UserInterfaceSizeClass? { _horizontalSizeClass }
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct BasicRootView_Previews: PreviewProvider {
    static var previews: some View {
        BasicRootView()
    }
}
