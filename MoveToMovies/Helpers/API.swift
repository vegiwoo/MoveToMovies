//
//  API.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.03.2021.
//

import Foundation

enum API : CustomStringConvertible {
    case tmdbApiKey
    case tmdbImagesPath
    var description: String {
        switch self {
        case .tmdbApiKey:
            return "2e6b2f25124ca8304e9b74fb99176e96"
        case .tmdbImagesPath:
            return "https://image.tmdb.org/t/p/"
        }
    }
}



