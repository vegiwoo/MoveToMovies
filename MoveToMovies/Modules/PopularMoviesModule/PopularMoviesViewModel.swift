//
//  MoviesListViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 04.03.2021.
//

import SwiftUI
import TmdbAPI
import Combine

final class PopularMoviesViewModel: ObservableObject {
    @Published var movies: [MovieListResultObject] = []
    
    let subject = PassthroughSubject<Movie, Never>()
    
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
    
    func getMovie(by id: Int) {
        TmdbAPI.DefaultAPI.movieMovieIdGet(movieId: id, apiKey: API.apiKey.description) { (movie, error) in
            
            guard let movie = movie, error == nil else {
                print(error!.localizedDescription); return
            }
            
            self.subject.send(movie)
            
        }
    }
}

extension PopularMoviesViewModel {
    func getRandomElement() -> MovieListResultObject? {
        guard movies.count > 0,
              let randomMovie = movies.randomElement()
        else { return nil }
        
        return randomMovie 
    }
}

extension MovieListResultObject: Identifiable {}
