//
//  SizeClassAdjustable.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

protocol SizeClassAdjustable {
    var verticalSizeClass: UserInterfaceSizeClass? { get }
    var horizontalSizeClass: UserInterfaceSizeClass? { get }
}
extension SizeClassAdjustable {
    var isPad: Bool {
        return horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
//    var isPadLandscape: Bool {
//        isPad && DeviceFeatures.IS_LANDSCAPE
//    }
//    var isPadPortrait: Bool {
//        isPad && DeviceFeatures.IS_PORTRAIT
//    }
    var isPadOrLandscapeMax: Bool {
        horizontalSizeClass == .regular
    }
    var isLandscapeMax: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .compact
    }
    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    var isPortrait: Bool {
        verticalSizeClass == .regular
    }
}
