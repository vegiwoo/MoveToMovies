//
//  NavCoordinatorViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 10.03.2021.
//
#if canImport(SwiftUI)
import SwiftUI

private struct Screen: Identifiable, Equatable {
    let id: UUID
    let nextScreen: AnyView
    
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
}

public enum PopDestination {
    case previous, root
}

//public enum NavigationTransition {
//    case none
//    case custom(AnyTransition)
//}

enum NavigationType {
    case push, pop
}

public struct TransitionsAnimation {
    let pushTransinion: AnyTransition
    let popTransinion: AnyTransition
    let pushAnimation: Animation
    let popAnimation: Animation
    
    public init(pushTransinion: AnyTransition, pushAnimation: Animation, popTransinion: AnyTransition? = nil, popAnimation: Animation? = nil) {
        self.pushTransinion = pushTransinion
        self.pushAnimation = pushAnimation
        self.popTransinion = popTransinion ?? pushTransinion
        self.popAnimation = popAnimation ?? pushAnimation
    }
}




public class NavCoordinatorViewModel: ObservableObject {
    @Published fileprivate var currentScreen: Screen?
    
    private var navigationList: LinkedList<Screen> = .init() {
        didSet {
            currentScreen = navigationList.lastValue
        }
    }
    
    var navigationListCount: Int {
        return navigationList.count
    }
    
    var navigationType: NavigationType = .push
    private let animations: (push: Animation, pop: Animation)

    init(pushAnimation: Animation, popAnimation: Animation) {
        self.animations = (pushAnimation, popAnimation)
    }
    
    func push<S: View>(_ screenView: S)  {
        withAnimation(animations.push) {
            navigationType = .push
            let screen: Screen = .init(id: UUID(), nextScreen: AnyView(screenView))
            navigationList.push(value: screen)
        }
    }
    
    func pop(to: PopDestination = .previous) {
        withAnimation(animations.pop) {
            switch to {
            case .previous:
                navigationList.pop()
            case .root:
                navigationList.popToHead()
            }
        }
    }
}

public struct NavCoordinatorView<Content>: View  where Content: View {
    
    @ObservedObject var vm: NavCoordinatorViewModel
    private let content: Content
    private let transitionsAnimation: TransitionsAnimation
    
    public init(transitionsAnimation: TransitionsAnimation = TransitionsAnimation(pushTransinion: .moveAndFade, pushAnimation: Animation.easeIn(duration: 0.35), popAnimation: Animation.easeOut(duration: 0.35)),
                @ViewBuilder content: @escaping () -> Content) {
        
        self.transitionsAnimation = transitionsAnimation
        vm = NavCoordinatorViewModel(pushAnimation: transitionsAnimation.pushAnimation,
                                     popAnimation: transitionsAnimation.popAnimation)
        self.content = content()
    }

    public var body: some View {
        let isRoot = vm.currentScreen == nil
        return ZStack {
            if isRoot {
                content
                    .transition(vm.navigationType == .push ?
                                    transitionsAnimation.pushTransinion :
                                    transitionsAnimation.popTransinion)
                    .environmentObject(vm)
            } else {
                
                vm.currentScreen!.nextScreen
                    .transition(vm.navigationType == .push ?
                                    transitionsAnimation.pushTransinion :
                                    transitionsAnimation.popTransinion)
                    .environmentObject(vm)
            }
        }
    }
}

public struct NavPushButton<Label, Destination>: View where Label: View, Destination: View {
    @EnvironmentObject var vm: NavCoordinatorViewModel
    
    private let label: () -> Label
    private let destination: Destination
    
    public init (destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        label().onTapGesture {
            vm.push(destination)
        }
    }
}

public struct NavPopButton<Label>: View where Label: View {
    @EnvironmentObject var vm: NavCoordinatorViewModel

    private let destination: PopDestination
    private let action: () -> Void
    private let label: () -> Label
    
    public init (destination: PopDestination = .previous,
                 action:  @escaping () -> Void,
                 @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        label().onTapGesture {
            action()
            vm.pop(to: destination)
        }
    }
}
#endif
