//
//  NavCoordinatorView.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 11.03.2021.
//

#if canImport(SwiftUI)
import SwiftUI

public struct NavCoordinatorView<Content>: View  where Content: View {
    
    @ObservedObject var vm: NavCoordinatorViewModel
    private let content: Content
    
    public init( @ViewBuilder content: @escaping () -> Content) {
        
        vm = NavCoordinatorViewModel()
        self.content = content()
    }

    public var body: some View {
        let isRoot = vm.currentScreen == nil
        return ZStack {
            if isRoot {
                content.environmentObject(vm)
            } else {
                vm.next(currentNodeId: vm.currentScreen!.id)?.environmentObject(vm)
            }
        }
    }
}
#endif
