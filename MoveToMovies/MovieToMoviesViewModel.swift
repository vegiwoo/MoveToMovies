//
//  MovieToMoviesViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import TmdbAPI

final class MovieToMoviesViewModel: ObservableObject {
    
    @Published var genres: [Genre] = []
    
    init() {
        getGenres()
    }
}

extension MovieToMoviesViewModel {
    private func getGenres() {
        TmdbAPI.DefaultAPI.genreMovieListGet(apiKey: API.apiKey.description, apiResponseQueue: DispatchQueue.global(qos: .utility)) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let responseGernes = response?.genres {
                    self.genres = responseGernes
                }
            }
        }
    }
}

extension Genre: Identifiable {}
