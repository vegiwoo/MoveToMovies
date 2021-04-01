//
//  MovieOmdbapiObject + Ext.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 31.03.2021.
//

import Foundation
import OmdbAPI

extension MovieOmdbapiObject: Identifiable {
    public var id: String { imdbID! }
}

extension MovieOmdbapiObject: Equatable {
    public static func == (lhs: MovieOmdbapiObject, rhs: MovieOmdbapiObject) -> Bool {
        lhs.title == rhs.title
    }
}

extension MovieOmdbapiObject: Hashable {
    public func hash (into hasher: inout Hasher) {
        hasher.combine (title)
    }
    public var hashValue: Int {
        var hasher = Hasher ()
        self.hash (into: &hasher)
        return hasher.finalize ()
    }
}

