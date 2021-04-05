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
    case addFoundMovies(query: String, movies: [MovieOmdbapiObject])
}

enum TabbarAction {
    case indexChange(Int)
}
