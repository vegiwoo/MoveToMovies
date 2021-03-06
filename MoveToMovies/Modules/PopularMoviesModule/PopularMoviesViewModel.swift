//
//  MoviesListViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI

final class PopularMoviesViewModel: ObservableObject {
    typealias Movie = MovieListResultObject
    @Published var movies: [Movie] = []
    
    init() {
        getMovies()
    }
    
}

extension PopularMoviesViewModel {
    private func getMovies() {
        TmdbAPI.DefaultAPI.moviePopularGet(apiKey: API.apiKey.description) { (response, error) in
            if error == nil, let results = response?.results {
                self.movies = results
            } else {
                print(error.debugDescription)
            }
        }
    }
}

extension MovieListResultObject: Identifiable {}
