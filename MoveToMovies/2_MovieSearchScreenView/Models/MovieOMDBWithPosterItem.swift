//
//  MovieOMDBWithPosterItem.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.04.2021.
//

import Foundation
import OmdbAPI

struct MovieOMDBWithPosterItem: Hashable, Identifiable {
    var id: UUID { UUID() }
    var movie: MovieOmdbapiObject
    var poster: Data?
}

