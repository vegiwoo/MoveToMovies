//
//  AppAction.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import SwiftUI
import OmdbAPI

/// Description of app action in structure composition
enum AppAction {
    case tabbar(action: TabbarAction)
    case searchMovies(action: SearchMoviesAction)
}

// MARK: Context actions
enum SearchMoviesAction {
    case assignIndexSegmentControl(Int)
    case clearSearchResults(Bool)
    case loadSearchMovies(query: String, page: Int)
    case addFoundMovies(movies: [MovieOmdbapiObject])
}

enum TabbarAction {
    case indexChange(Int)
}
