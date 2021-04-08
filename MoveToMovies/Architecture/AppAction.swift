//
//  AppAction.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import SwiftUI
import OmdbAPI
import UIControls
import Networking

/// Description of app action in structure composition
enum AppAction {
    case tabbar(action: TabbarAction)
    case searchMovies(action: SearchMoviesAction)
}

// MARK: Context actions
enum SearchMoviesAction {
    case assignIndexSegmentControl(Int)
    case changeStatusMovieSearch(MovieSearchStatus)
    case loadSearchMovies(query: String, page: Int)
    case updateMoviesWithPosters(items: [(String, Data?)])
    case addFoundMovies(query: String, movies: [MovieOmdbapiObject])
    case changeProgressMovieSearch(Float)
    case setSelectedMoviePoster(for: MovieOmdbapiObject?)
}

enum TabbarAction {
    case indexChange(Int)
}
