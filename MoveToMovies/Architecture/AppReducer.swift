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
        if !query.isEmpty {
            return (environment.networkProvider.loadMovieRequest(query: query.trimmingCharacters(in: .whitespacesAndNewlines), page: page)?
                        .map{SearchMoviesAction.addFoundMovies(query: query, movies: $0.search)}
                        .eraseToAnyPublisher())!
        } else {
            return Empty().eraseToAnyPublisher()
        }
    case let .addFoundMovies(query, movies):
        
        state.needForFurtherLoad = false
        
        if movies.count > 0 {
            if state.searchQuery != query {
                state.foundMovies.removeAll()
                state.searchQuery = query
            }
            
            state.foundMovies.append(contentsOf: movies)
            state.searchPage += 1
            
            return Just(SearchMoviesAction.changeStatusMovieSearch(.getResults))
                .eraseToAnyPublisher()
        } else {
            return Just(SearchMoviesAction.changeStatusMovieSearch(.error))
                .eraseToAnyPublisher()
        }
    case let .assignIndexSegmentControl(index):
        state.selectedIndexSegmentControl = index
    case let .changeStatusMovieSearch(newStatus):
        
        state.movieSearchStatus = newStatus
        
        switch newStatus {
        case .initial:
            state.infoMessage = ("magnifyingglass", "Find your favorite\nmovie or TV series")
            state.foundMovies = []
            state.searchPage = 1
            state.searchQuery = ""
        case .typing:
            state.infoMessage = ("", "")
        case .search:
            state.infoMessage = ("", "")
        case .getResults:
            state.infoMessage = ("", "")
        case .error:
            state.infoMessage = ("xmark.octagon", "Not found\nTry changing your search")
        }
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


