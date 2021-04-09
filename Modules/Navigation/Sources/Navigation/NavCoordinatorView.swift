//  NavCoordinatorView.swift
//  Created by Dmitry Samartcev on 25.03.2021.

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct NavCoordinatorView<Content>: View  where Content: View {
    
    @ObservedObject var vm: NavCoordinatorViewModel
    private let content: Content
    private let ta: TransitionAndAnimations
    
    public init(ta: TransitionAndAnimations = TransitionAndAnimations(
                    pushTransinion: AnyTransition.opacity,
                    pushAnimation: Animation.easeIn(duration: 0.3),
                    popTransinion: AnyTransition.opacity,
                    popAnimation: Animation.easeOut(duration: 0.3)),
                @ViewBuilder content: @escaping () -> Content) {
        
        self.ta = ta
        self.vm = NavCoordinatorViewModel.init(pushAnimation: ta.pushAnimation, popAnimation: ta.popAnimation)
        self.content = content()
    }
    
    public var body: some View {
           let isRoot = vm.currentScreen == nil
           return ZStack {
               if isRoot {
                   content
                       .transition(vm.navigationType == .push ?
                                       ta.pushTransinion :
                                       ta.popTransinion)
                       .environmentObject(vm)
               } else {
                   vm.currentScreen!.nextScreen
                       .transition(vm.navigationType == .push ?
                                       ta.pushTransinion :
                                       ta.popTransinion)
                       .environmentObject(vm)
               }
           }
       }
}
#endif
