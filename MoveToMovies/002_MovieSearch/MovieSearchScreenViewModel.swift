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
    
    @Published private(set) var searchMovies: [MovieOmdbapiObject] = .init()
    @Published private(set) var searchMoviePosters: [String : Data] = .init()
    @Published var isPageLoading: Bool = false
    var currentPage: Int = 1
    
    var searchText: String?
    
    var bag: Set<AnyCancellable> = .init()

    init(_ context: NSManagedObjectContext, networkService: NetworkService, dataStorageService: DataStorageService) {
        self.context = context
        self.networkService = networkService
        self.dataStorageService = dataStorageService
    
        print("⬆️ MovieSearchScreenViewModel init")
    }
    
    deinit {
        unsubscribe()
        print("⬇️ MovieSearchScreenViewModel deinit")
    }

    func setup(ncViewModel: NavCoordinatorViewModel) {
        self.ncViewModel = ncViewModel
        subscribe()
        print("🔄 MovieSearchScreenViewModel setup")
    }
    
    private func subscribe() {
        if let networkService = networkService {
            networkServiceSubscriber = networkService.networkServicePublisher
                .subscribe(on: networkService.apiResponseQueue)
                .sink{value in
                    if let movieOmdbapiObjects = value as? (movies: [MovieOmdbapiObject], totalResults: Int) {
                        self.currentPage += 1
                        self.searchMovies.append(contentsOf: movieOmdbapiObjects.movies)
                        self.isPageLoading = false
                        self.loadPostersForSearch(movies: movieOmdbapiObjects.movies)
                    }
                }
        }
    }
    
    private func unsubscribe() {
        networkServiceSubscriber?.cancel()
        clearSearch()
    }

    func loadPage() {
        guard let searchText = searchText, !searchText.isEmpty,
              let networkService = self.networkService,
              isPageLoading == false else { return }
        isPageLoading = true
        
        print("value \(searchText), page \(currentPage)")
        networkService.getSearchMovieRequest(title: searchText, page: currentPage)
    }
    
    private func loadPostersForSearch(movies: [MovieOmdbapiObject]) {
        for movie in movies {
            if let posterString = movie.poster,
               let posterURL = URL(string: posterString) {
                let cancellable: AnyCancellable = URLSession.shared.dataTaskPublisher(for: posterURL)
                    .sink { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("🔴 ERROR: Load poster for search movie failure\n\(error.localizedDescription)")
                    }
                } receiveValue: { (data, _) in
                    self.searchMoviePosters.updateValue(data, forKey: movie.id)
                    self.objectWillChange.send()
                }
                cancellable.store(in: &bag)
            }
        }
    }
    
    func clearSearch() {
        currentPage = 1
        //searchTextLoading = ""
        searchMovies.removeAll()
        searchMoviePosters.removeAll()
        bag.forEach{$0.cancel()}
    }
    
    func getRandomMovie() -> MovieItem? {
        dataStorageService?.getRendomMovieItem()
    }
    
    // Navigation
    func navigationPop(destination: PopDestination) {
        self.ncViewModel?.pop(to: destination)
    }
    
    func navigationPush(destination: AnyView) {
        self.ncViewModel?.push(destination)
    }
    
    func navigationStackCount() -> Int? {
        ncViewModel?.navigationSequenceCount
    }
}
