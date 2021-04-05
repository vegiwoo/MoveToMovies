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
        
        state.movieSearchStatus = .loading
        
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
            
            for movie in movies {
                
                if let imdbID = movie.imdbID, let posterString = movie.poster,
                   let posterURL = URL(string: posterString) {
                    return (environment.networkProvider.loadCover(from: posterURL, for: imdbID)?
                                .map{SearchMoviesAction.addMovieWithPoster(movie: movie, poster: $0.data)}
                                .eraseToAnyPublisher())!
                } else {
                    return Just(SearchMoviesAction.addMovieWithoutPoster(movie: movie))
                        .eraseToAnyPublisher()
                }
            }
            
            
            
            
            
            
            
           
            
            //state.foundMovies.append(contentsOf: movies)
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
            state.foundMovies.removeAll()
            state.searchPage = 1
            state.searchQuery = ""
            state.needForFurtherLoad = false
        case .typing:
            state.infoMessage = ("", "")
        case .loading:
            state.infoMessage = ("", "")
            
            state.progressLoad = 0.00
            
            var initValue: Float = state.progressLoad
            let publisher = PassthroughSubject<Float, Never>()

            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                if initValue < 100.00 {
                    initValue += 1
                    publisher.send(initValue)
                } else {
                    timer.invalidate()
                }
            }.fire()
            
            return publisher
                .map{SearchMoviesAction.changeProgressMovieSearch($0)}
                .eraseToAnyPublisher()
        case .getResults:
            state.infoMessage = ("", "")
        case .error:
            state.infoMessage = ("xmark.octagon", "Not found\nTry changing your search")
        }
    case let .changeProgressMovieSearch(progress):
        if progress < 100 {
            state.progressLoad = progress
        }
    case let .addMovieWithPoster(movie, poster):
        state.foundMovies.append(MovieOMDBWithPosterItem(movie: movie, poster: poster))
    case let .addMovieWithoutPoster(movie):
        state.foundMovies.append(MovieOMDBWithPosterItem(movie: movie, poster: nil))
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

