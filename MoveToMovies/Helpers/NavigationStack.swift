//
//  NavigationStack.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 09.03.2021.
//

import SwiftUI

struct NavigationItem {
    var view: AnyView
}

final class NavigationStack: ObservableObject {
    @Published var viewStack: [NavigationItem] = .init()
    @Published var currentView: NavigationItem
    
    init (_ currentView: NavigationItem) {
        self.currentView = currentView
    }

    
    func zeroingStack(with currentView: NavigationItem) {
        DispatchQueue.main.async {
            self.currentView = currentView
            self.viewStack.removeAll()
        }
    }
    
    func unwind() {
        if viewStack.count == 0 { return }
        let last = viewStack.count - 1
        currentView = viewStack[last]
        viewStack.remove(at: last)
    }
    
    func advance(_ view: NavigationItem) {
        viewStack.append(currentView)
        currentView = view
    }
    
    func containsInStack(by id: UUID) -> Bool {
        viewStack.contains(where: {$0.view.id == id})
    }
//
//    func toDachboardScreen() {
//        currentView = NavigationItem(view: AnyView(DashboardScreen()))
//    }
}

struct NavigationHost: View {
    @EnvironmentObject var navigation: NavigationStack
    
    var body: some View {
        GeometryReader{ geometry in
            navigation.currentView.view
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
