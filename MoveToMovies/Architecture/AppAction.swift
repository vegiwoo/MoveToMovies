//
//  AppAction.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import OmdbAPI

/// Description of app action in structure composition
enum AppAction {
    case tabbar(action: TabbarAction)
    case searchMovies(action: SearchMoviesAction)
}

// MARK: Context actions
enum SearchMoviesAction {
    case loadSearchMovies(query: String, page: Int)
    case setSearchMovies(movies: [MovieOmdbapiObject])
}

enum TabbarAction {
    case indexChange(Int)
}
