//
//  NavCoordinatorViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 10.03.2021.
//
#if canImport(SwiftUI)
import SwiftUI

extension AnyView: Identifiable {
    public var id: UUID {
        UUID()
    }
}

extension AnyView: Equatable {
    public static func == (lhs: AnyView, rhs: AnyView) -> Bool {
        lhs.id == rhs.id
    }
}

public class NavCoordinatorViewModel: ObservableObject {
    @Published var currentScreen: AnyView?
    
    private var navigationList: LinkedList<AnyView> = .init() {
        didSet {
            if let currentScreen = currentScreen {
                navigationList.push(value: AnyView(currentScreen))
            }
        }
    }
    
    func push<S: View>(_ view: S)  {
        navigationList.push(value: AnyView(view))
    }
    
    func popToPrevious() -> AnyView? {
        navigationList.pop()
    }
    
    func popToRoot() -> AnyView? {
        navigationList.popToHead()
    }
    
    func next(currentNodeId: UUID) -> AnyView? {
        navigationList.getNextNodeValueForNode(currentNodeId)
    }
}
#endif
