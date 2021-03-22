//
//  MovieSearchScreenViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 14.03.2021.
//

import SwiftUI
import CoreData
import Combine
import TmdbAPI
import OmdbAPI

final class MovieSearchScreenViewModel: ObservableObject {

    private var context: NSManagedObjectContext?
    private var networkService: NetworkService?
    private var networkServiceSubscriber: AnyCancellable?

    
    func setup(_ context: NSManagedObjectContext, networkService: NetworkService) {
        self.context = context
        self.networkService = networkService
        subscribe()
    }
    
    private func subscribe() {
        if let networkService = networkService {
            networkServiceSubscriber = networkService.networkServicePublisher
                .subscribe(on: networkService.apiResponseQueue)
                .sink{value in
                if let movieOmdbapiObjects = value as? [MovieOmdbapiObject] {
                    print(movieOmdbapiObjects)
                }
            }
        }
    }
    
    func getSearchMovieRequest(title: String, page: Int) {
        self.networkService?.getSearchMovieRequest(title: title, page: page)
    }
}


