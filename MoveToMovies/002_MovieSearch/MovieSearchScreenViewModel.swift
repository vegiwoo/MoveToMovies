//
//  MovieSearchScreenViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 14.03.2021.
//

import SwiftUI
import TmdbAPI
import CoreData

final class MovieSearchScreenViewModel: ObservableObject {

    private var context: NSManagedObjectContext?
    

    func setup(_ context: NSManagedObjectContext) {
        self.context = context
    }

}


