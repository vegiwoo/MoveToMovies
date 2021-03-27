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
import Navigation

final class MovieSearchScreenViewModel: ObservableObject {

    private var context: NSManagedObjectContext?
    private var networkService: NetworkService?
    private var dataStorageService: DataStorageService?
    private var networkServiceSubscriber: AnyCancellable?
    
    private var ncViewModel: NavCoordinatorViewModel?
    
    
    @Published private(set) var items: [MovieOmdbapiObject] = .init()
    @Published var isPageLoading: Bool = false
    var currentPage: Int = 1
    
    var searchText: String?

    deinit {
        unsubscribe()
    }

    func setup(_ context: NSManagedObjectContext, networkService: NetworkService, dataStorageService: DataStorageService, ncViewModel: NavCoordinatorViewModel) {
        self.context = context
        self.networkService = networkService
        self.dataStorageService = dataStorageService
        self.ncViewModel = ncViewModel
        subscribe()
    }
    
    private func subscribe() {
        if let networkService = networkService {
            networkServiceSubscriber = networkService.networkServicePublisher
                .subscribe(on: networkService.apiResponseQueue)
                .sink{value in
                    if let movieOmdbapiObjects = value as? (movies: [MovieOmdbapiObject], totalResults: Int) {
                        self.currentPage += 1
                        self.items.append(contentsOf: movieOmdbapiObjects.movies)
                        self.isPageLoading = false
                    }
                }
        }
    }
    
    private func unsubscribe() {
        networkServiceSubscriber?.cancel()
    }
    
    func loadPage() {
        guard let searchText = searchText, !searchText.isEmpty,
              let networkService = self.networkService,
              isPageLoading == false else { return }
        isPageLoading = true
        
        print("value \(searchText), page \(currentPage)")
        networkService.getSearchMovieRequest(title: searchText, page: currentPage)
    }
    
    func clearSearch() {
        currentPage = 1
        //searchTextLoading = ""
        items.removeAll()
    }
    
    func getRandomMovie() -> MovieItem? {
        dataStorageService?.getRendomMovieItem()
    }
    
    func navigationPop(destination: PopDestination) {
        self.ncViewModel?.pop(to: destination)
    }
}

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
