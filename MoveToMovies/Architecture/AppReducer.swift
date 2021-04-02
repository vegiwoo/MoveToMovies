//
//  AppReducer.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import Combine

typealias Reducer<State, Action, Environment> = (inout State, Action, Environment) -> AnyPublisher<Action, Never>

// MARK: Contextual reducers
func tabbarReducer(state: inout TabBarState, action: TabbarAction, environment: AppEnvironment) -> AnyPublisher<TabbarAction, Never> {
    switch action {
    case let .indexChange(index):
        state.selectedIndex = index
        state.selectedView = TabBarState.setActualScreen(for: index)
    }
    return Empty().eraseToAnyPublisher()
}

func searchMoviesReducer(state: inout SearchMoviesState, action: SearchMoviesAction, environment: AppEnvironment) -> AnyPublisher<SearchMoviesAction, Never> {
    
    switch action {
    case let .loadSearchMovies(query,page):
        return (environment.networkProvider.loadMovieRequest(query: query, page: page)?
                    .map{SearchMoviesAction.setSearchMovies(movies: $0.search)}
                    .eraseToAnyPublisher())!
    case let .setSearchMovies(movies):
        state.foundFilms = movies
    }
    return Empty().eraseToAnyPublisher()
}

/// Description of app reduser in structure composition
func appReducer(state: inout AppState, action: AppAction, environment: AppEnvironment) -> AnyPublisher<AppAction, Never>{
    switch action {
    case let .tabbar(action):
        return tabbarReducer(state: &state.tabBar, action: action, environment: environment)
            .map(AppAction.tabbar)
            .eraseToAnyPublisher()
    case let .searchMovies(action):
        return searchMoviesReducer(state: &state.searchMovies, action: action, environment: environment)
            .map(AppAction.searchMovies)
            .eraseToAnyPublisher()
    
    }
}
