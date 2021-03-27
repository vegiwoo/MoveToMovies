//  NavCoordinatorViewModel.swift
//  Created by Dmitry Samartcev on 25.03.2021.

#if canImport(SwiftUI)
import SwiftUI

/// Represents the ViewModel for the navigation coordinator.
@available(iOS 13.0, *)
public final class NavCoordinatorViewModel: ObservableObject {
    @Published var currentScreen: Screen?
    private var navigationSequence: LinkedList<Screen> = .init() {
        didSet {
            currentScreen = navigationSequence.lastValue
        }
    }
    var navigationType: NavigationType = .push
    private let animations: (push: Animation, pop: Animation)

    public var navigationSequenceCount: Int{
        navigationSequence.count
    }

    public init(pushAnimation: Animation, popAnimation: Animation) {
        self.animations = (pushAnimation, popAnimation)
    }
    
    /// Method for moving forward in navigation sequence.
    /// - Parameter screenView: Next screen relative to current one.
    public func push<S: View>(_ screenView: S)  {
        withAnimation(animations.push) {
            navigationType = .push
            let screen: Screen = .init(id: UUID(), nextScreen: AnyView(screenView))
            navigationSequence.push(value: screen)
        }
    }
    
    /// Method for moving backward through navigation sequence.
    /// - Parameter to: Target of return in navigation sequence.
    public func pop(to: PopDestination = .previous) {
        withAnimation(animations.pop) {
            switch to {
            case .previous:
                navigationSequence.pop()
            case .root:
                navigationSequence.popToHead()
            }
        }
    }
}
#endif
