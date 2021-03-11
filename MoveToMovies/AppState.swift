//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import TmdbAPI

final class AppState: ObservableObject {
    @Published var selectTabIndex: Int = TabbarTab.dashboardScreen.rawValue  {
        didSet {
            selectedTabHandler()
        }
    }
    @Published var appViewModel: AppViewModel = .init()
    @Published var isQuickLink: Bool = false {
        didSet {
            //selectionTab = .popularMoviesScreen
            randomMovie = isQuickLink == true ? appViewModel.getRandomMovie() : nil
        }
    }
    @Published var randomMovie: Movie?
    
    @Published var selectionScreen: AnyView = AnyView(DashBoardScreen())
    
    private func selectedTabHandler() {
        if let selectedTab = TabbarTab.allCases.first(where: {$0.rawValue == selectTabIndex}) {
            switch selectedTab {
            case .dashboardScreen:
                selectionScreen = AnyView(DashBoardScreen())
            case .popularMoviesScreen:
                selectionScreen = AnyView(PopularMoviesScreen())
            case .aboutUSScreen:
                selectionScreen = AnyView(AboutUsScreen())
            }
        }
    }
}
