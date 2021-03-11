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

enum NavigationType {
    case push, pop
}

public class NavCoordinatorViewModel: ObservableObject {
    @Published fileprivate var currentScreen: Screen?
    
    private var navigationList: LinkedList<Screen> = .init() {
        didSet {
            currentScreen = navigationList.lastValue
        }
    }

    func push<S: View>(_ screenView: S)  {
        let screen: Screen = .init(id: UUID(), nextScreen: AnyView(screenView))
        navigationList.push(value: screen)
    }
    
    func popTo(destination: PopDestination = .previous) {
        switch destination {
        case .previous:
            navigationList.pop()
        case .root:
            navigationList.popToHead()
        }
    }
    
}

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
                vm.currentScreen!.nextScreen.environmentObject(vm)
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
    
    private let label: () -> Label
    private let destination: PopDestination
    
    public init (destination: PopDestination = .previous,
                 @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        label().onTapGesture {
            vm.popTo(destination: destination)
        }
    }
}
#endif
