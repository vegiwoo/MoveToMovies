//
//  AppAction.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import SwiftUI
import CoreData
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
    case hideTabbar(Bool)
}

enum SearchOmbdAPIMoviesAction {
    case assignIndexSegmentControl(Int)
    case changeStatusMovieSearch(MovieSearchStatus)
    case loadSearchMovies(query: String, page: Int)
    case addFoundMovies(query: String, movies: [MovieOmdbapiObject])
    case loadMovieCovers(movies: [MovieOmdbapiObject])
    case updateMoviesWithPosters(movies: [MovieOmdbapiObject], downloadItems: [(String, Data?)])
    case changeProgressMovieSearch(Float)
    case setSelectedOMDB(item: FoundItem?)
}

enum PopularTmbdAPIMoviesAction {
    case setCoreData(context: NSManagedObjectContext)
    case loadGenres
    case updateGenresInStorage(response: GenresResponse)
    case loadPopularMovies(message: String)
    case update(popularMovies: [MovieListResultObject])
    case updatePopularMoviesInfo(movies: [Movie])
    case loadCovers(items: [(imdbId: String, posterPath: String?, backdropPath: String?)])
    case updateCovers(postersData: [(String, Data?)], backdropData: [(String, Data?)])
    case updatingPopularMoviesComplete
    case setSelectedTMDBMovieCovers(for: MovieItem?)
    case isQuickTransition(Bool)
}
