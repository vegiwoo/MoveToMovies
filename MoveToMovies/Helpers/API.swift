//
//  API.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 07.03.2021.
//

import Foundation

enum API : CustomStringConvertible {
    case tmdbApiKey
    var description: String {
        switch self {
        case .tmdbApiKey:
            return "2e6b2f25124ca8304e9b74fb99176e96"
        }
    }
}



