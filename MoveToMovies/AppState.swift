//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import TmdbAPI

final class AppState: ObservableObject {
    @Published var selectionTab: TabbarView.Tab = .dashboardScreen {
        didSet {
            selectedTabHandler()
        }
    }
    @Published var appViewModel: AppViewModel = .init()
    @Published var isQuickLink: Bool = false {
        didSet {
            selectionTab = .popularMoviesScreen
            randomMovie = isQuickLink == true ? appViewModel.getRandomMovie() : nil
        }
    }
    @Published var randomMovie: Movie?
    
    @Published var navigation: NavigationStack = .init(NavigationItem(view: AnyView(DashBoardScreen())))
    
    private func selectedTabHandler() {
        switch selectionTab {
        case .dashboardScreen:
            navigation.zeroingStack(with:NavigationItem(view: AnyView(DashBoardScreen())))
        case .popularMoviesScreen:
            navigation.zeroingStack(with:NavigationItem(view: AnyView(PopularMoviesScreen())))
        case .aboutUSScreen:
            navigation.zeroingStack(with:NavigationItem(view: AnyView(AboutUsScreen())))
        }
    }
    
}
