//  TransitionAndAnimations.swift
//  Created by Dmitry Samartcev on 25.03.2021.

#if canImport(SwiftUI)
import SwiftUI
/// Defines transitions and animations for navigating push and pop on navigation stack
@available(iOS 13.0, *)
public struct TransitionAndAnimations {
    let pushTransinion : AnyTransition
    let popTransinion  : AnyTransition
    let pushAnimation  : Animation
    let popAnimation   : Animation
    
    public init(pushTransinion: AnyTransition,
                pushAnimation: Animation,
                popTransinion: AnyTransition? = nil,
                popAnimation: Animation? = nil) {
        self.pushTransinion = pushTransinion
        self.pushAnimation = pushAnimation
        self.popTransinion = popTransinion ?? pushTransinion
        self.popAnimation = popAnimation ?? pushAnimation
    }
}
#endif
