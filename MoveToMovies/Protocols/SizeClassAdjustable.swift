//
//  SizeClassAdjustable.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI

protocol SizeClassAdjustable {
    /// Vertical size class
    var vsc: UserInterfaceSizeClass? { get }
    /// Horizontal size class
    var hsc: UserInterfaceSizeClass? { get }
}
extension SizeClassAdjustable {
    var isPad: Bool { hsc == .regular && vsc == .regular }
//    var isPadLandscape: Bool {
//        isPad && DeviceFeatures.IS_LANDSCAPE
//    }
//    var isPadPortrait: Bool {
//        isPad && DeviceFeatures.IS_PORTRAIT
//    }
    var isPadOrLandscapeMax: Bool { hsc == .regular }
    var isLandscapeMax: Bool { hsc == .regular && vsc == .compact }
    var isLandscape: Bool { vsc == .compact }
    var isPortrait: Bool { vsc == .regular }
}
