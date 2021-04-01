//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import SwiftUI
import OmdbAPI

/// Description of app state in structure composition
struct AppState {
    var searchMovies: SearchMoviesState
    var popularMovies: PopularMoviesState
}

//MARK: Context app states
struct SearchMoviesState {
    //var foundFilms: [String: (movie: MovieOmdbapiObject, poster: UIImage?)]
    var foundFilms: [MovieOmdbapiObject]
}

struct PopularMoviesState {
    
}
