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
    
    init() {
        loadGernes()
    }

    func setup(_ context: NSManagedObjectContext) {
        self.context = context
      }

    func loadGernes() {
        DefaultAPI.genreMovieListGet(apiKey: API.tmdbApiKey.description) { (response, error) in
            if let error = error {
                print(" \(error.localizedDescription)")
            }
//            if let genres = response?.genres {
//
//                let context = self.persistentContainer.newBackgroundContext()
//
//                for item in genres {
//                    let genre = NSEntityDescription.insertNewObject(forEntityName: "GerneItem", into: context) as! GenreItem
//                    genre.setValue(item.id, forKey: "id")
//                    genre.setValue(item.name, forKey: "name")
//
//                    try! context.save()
//                }
//            }
        }
    }
    
    
    
}
