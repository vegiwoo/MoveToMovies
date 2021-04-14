//
//  AppReducer.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import Combine
import OmdbAPI
import Networking

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

func searchOmdbApiMoviesReducer(state: inout SearchMoviesState, action: SearchOmbdAPIMoviesAction, environment: AppEnvironment) -> AnyPublisher<SearchOmbdAPIMoviesAction, Never> {
    
    switch action {
    case let .loadSearchMovies(query,page):
        if !query.isEmpty {
            state.movieSearchStatus = .loading
            return (environment.networkProvider.loadMovieRequest(query: query.trimmingCharacters(in: .whitespacesAndNewlines), page: page)?
                        .map{SearchOmbdAPIMoviesAction.addFoundMovies(query: query, movies: $0.search)}
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
            
            var moviesForPosterSearch: [MovieOmdbapiObject] = .init()
            
            for movie in movies {
                if !state.foundMovies.contains(movie) {
                    state.foundMovies.append(movie)
                    moviesForPosterSearch.append(movie)
                }
                
                if state.foundMovies.isLast(movie) {
                    state.searchPage += 1
                }
            }

            return Just(SearchOmbdAPIMoviesAction.changeStatusMovieSearch(.getResults(moviesForPosterSearch)))
                .eraseToAnyPublisher()
        } else {
            if state.foundMovies.isEmpty {
                return Just(SearchOmbdAPIMoviesAction.changeStatusMovieSearch(.error))
                     .eraseToAnyPublisher()
            } else {
                return Just(SearchOmbdAPIMoviesAction.changeStatusMovieSearch(.endOfSearch))
                     .eraseToAnyPublisher()
            }
        }
    case let .assignIndexSegmentControl(index):
        state.selectedIndexSegmentControl = index
        
        if index == 1 {
            state.movieSearchStatus = .initial
        }
        
    case let .changeStatusMovieSearch(newStatus):
        
        state.movieSearchStatus = newStatus
        
        switch newStatus {
        case .initial:
            state.infoMessage = ("magnifyingglass", "Find your favorite\nmovie or TV series")
            state.foundMovies.removeAll()
            state.foundMoviesPosters.removeAll()
            state.searchPage = 1
            state.searchQuery = ""
            state.needForFurtherLoad = false
            state.progressLoad = 0.00
            state.selectedOMDBMovie = nil
            state.selectedOMDBMoviePoster = nil
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
                .map{SearchOmbdAPIMoviesAction.changeProgressMovieSearch($0)}
                .eraseToAnyPublisher()
        case let .getResults(movies):
            state.infoMessage = ("", "")
            
            if movies.count > 0 {
                var receivedItems = movies
                receivedItems.removeAll(where: {$0.poster == nil || $0.imdbID == nil})

                let dictionary: [String: String] = receivedItems.reduce(into: [:]) { dictionary, movie in
                    dictionary[movie.imdbID!] = movie.poster
                }
                
                return environment.networkProvider.loadData(for: dictionary)
                    .replaceError(with: [("String", nil)])
                    .map{SearchOmbdAPIMoviesAction.updateMoviesWithPosters(items: $0)}
                    .eraseToAnyPublisher()
            }

        case .error:
            state.infoMessage = ("xmark.octagon", "Not found\nTry changing your search")
        case .endOfSearch:
            state.movieSearchStatus = .endOfSearch
            
        }
    case let .changeProgressMovieSearch(progress):
        if progress < 100 {
            state.progressLoad = progress
        }

    case let .updateMoviesWithPosters(items):
        for item in items {
            state.foundMoviesPosters.updateValue(item.1, forKey: item.0)
        }
    case let .setSelectedOMDBMoviePoster(for: movie):
        if let newValue = movie {
            state.selectedOMDBMovie = newValue
            
            if let imdbID = newValue.imdbID,
               let poster = state.foundMoviesPosters[imdbID] {
                state.selectedOMDBMoviePoster = poster
            } else {
                state.selectedOMDBMoviePoster = nil
            }
            
        } else {
            state.selectedOMDBMovie = nil
            state.selectedOMDBMoviePoster = nil
        }
    }
    return Empty().eraseToAnyPublisher()
}

func searchTmdbApiMoviesReducer(state: inout PopularMoviesState, action: PopularTmbdAPIMoviesAction, environment: AppEnvironment) -> AnyPublisher<PopularTmbdAPIMoviesAction, Never> {
    switch action {
    case .loadGenres:
        //environment.coreDataProvider.clearStrorаge()
        state.updatingPopularMovies = false
        return (environment.networkProvider.loadGenresFromTmdb()?
                    .map{PopularTmbdAPIMoviesAction.updateGenresInStorage(response: $0)}
                    .eraseToAnyPublisher())!
    case let .updateGenresInStorage(genresResponse):
        return environment.coreDataProvider.save(genres: genresResponse.genres)
            .map{PopularTmbdAPIMoviesAction.loadPopularMovies(message: $0)}
            .eraseToAnyPublisher()
    case let .loadPopularMovies(message):
        print(message)
        return (environment.networkProvider.loadPopularMoviesListFromTmdb()?
                    .map{PopularTmbdAPIMoviesAction.update(popularMovies: $0.results)}
                    .eraseToAnyPublisher())!
    case let .update(popularMovies):
        return environment.networkProvider.loadPopularMoviesInfoFromTmdb(by: popularMovies.map{$0.id!})
            .map{PopularTmbdAPIMoviesAction.updatePopularMoviesInfo(movies: $0)}
            .eraseToAnyPublisher()
    case let .updatePopularMoviesInfo(movies):
        return (environment.coreDataProvider.store(movies: movies)?
                    .map{PopularTmbdAPIMoviesAction.loadCovers(items: $0)}
                    .eraseToAnyPublisher())!
            
    case let .loadCovers(items):
        //print("Request to download posters and backdrops for \(items.count) movies")
        let coversize = state.posterSize
        return environment.networkProvider.loadCovers(for: items, coverSize: coversize.rawValue)
            .map({ (postersData, backdropData) in
                return PopularTmbdAPIMoviesAction.updateCovers(postersData: postersData, backdropData: backdropData)
            })
            .eraseToAnyPublisher()
            
    case let .updateCovers(postersData, backdropData):
        return environment.coreDataProvider.updateCovers(postersData: postersData, backdropsData: backdropData)
            .map{_ in PopularTmbdAPIMoviesAction.updatingPopularMoviesComplete}
            .eraseToAnyPublisher()
    case .updatingPopularMoviesComplete:
        print("🟢 Popular films update completed.")
        state.updatingPopularMovies = true
    case let .setCoreData(context):
        state.context = context
    case let .setSelectedTMDBMovieCovers(movie):
        if let movie = movie {
            state.selectedTMDBMovie = movie
            state.selectedTMDBMoviePoster = movie.poster?.blob != nil ? movie.poster!.blob : nil
            state.selectedTMDBMovieBackdrop = movie.backdrop?.blob != nil ? movie.backdrop!.blob : nil
        } else {
            state.selectedTMDBMovie = nil
            state.selectedTMDBMoviePoster = nil
            state.selectedTMDBMovieBackdrop = nil
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
    case let .searchOmbdAPIMovies(action):
        return searchOmdbApiMoviesReducer(state: &state.searchMovies, action: action, environment: environment)
            .map(AppAction.searchOmbdAPIMovies)
            .eraseToAnyPublisher()
    
    case let .popularTmbdAPIMovies(action):
        return searchTmdbApiMoviesReducer(state: &state.popularMovies, action: action, environment: environment)
            .map(AppAction.popularTmbdAPIMovies)
            .eraseToAnyPublisher()
    }
}
