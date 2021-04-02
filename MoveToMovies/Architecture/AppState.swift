//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import SwiftUI
import UIControls
import OmdbAPI

/// Description of app state in structure composition
struct AppState {
    var tabBar: TabBarState
    var searchMovies: SearchMoviesState
    var popularMovies: PopularMoviesState
}

//MARK: Context app states
struct TabBarState {
    var tabBarItems: [TabBarItem] {
        return [
            TabBarItem(sfSymbolName: "list.dash", title: "Dashboard", color: TabbarTab.dashboardScreen.actualColor),
            TabBarItem(sfSymbolName: "tv", title: "Search Movies", color: TabbarTab.movies.actualColor),
            TabBarItem(sfSymbolName: "info", title: "About us", color: TabbarTab.aboutUSScreen.actualColor),
        ]
    }
    var selectedIndex: Int = 0 {
        didSet {
            selectedView = TabBarState.setActualScreen(for: selectedIndex)
        }
    }
    var selectedView: AnyView = TabBarState.setActualScreen(for: 0) 
    
    static func setActualScreen(for index: Int) -> AnyView {
        if let selectedTabbarTab = TabbarTab.allCases.first(where: { $0.rawValue == index }) {
            switch selectedTabbarTab {
            case .dashboardScreen:
                return AnyView(DashScreenContainerView())
            case .movies:
                return AnyView(MovieSearchContainerView())
            case .aboutUSScreen:
                return AnyView(AboutUsContainerView())
            }
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct SearchMoviesState {
    var foundFilms: [MovieOmdbapiObject]
}

struct PopularMoviesState {
    
}

