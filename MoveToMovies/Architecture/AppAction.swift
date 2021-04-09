//
//  AppAction.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import SwiftUI
import TmdbAPI
import OmdbAPI
import UIControls
import Networking

/// Description of app action in structure composition
enum AppAction {
    case tabbar(action: TabbarAction)
    case searchOmbdAPIMovies(action: SearchOmbdAPIMoviesAction)
    case popularTmbdAPIMovies(action: PopularTmbdAPIMoviesAction)
}

// MARK: Context actions
enum TabbarAction {
    case indexChange(Int)
}

enum SearchOmbdAPIMoviesAction {
    case assignIndexSegmentControl(Int)
    case changeStatusMovieSearch(MovieSearchStatus)
    case loadSearchMovies(query: String, page: Int)
    case updateMoviesWithPosters(items: [(String, Data?)])
    case addFoundMovies(query: String, movies: [MovieOmdbapiObject])
    case changeProgressMovieSearch(Float)
    case setSelectedMoviePoster(for: MovieOmdbapiObject?)
}

enum PopularTmbdAPIMoviesAction {
    case loadGenres
    case updateGenresInStorage(response: GenresResponse)
    case loadPopularMovies(message: String)
    case update(popularMovies: [MovieListResultObject])
    case updatePopularMoviesInfo(movies: [Movie], posterSize: PosterSize)
}


