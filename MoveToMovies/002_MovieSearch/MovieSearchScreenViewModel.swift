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
    
    @Published private(set) var items: [MovieOmdbapiObject] = .init()
    @Published private(set) var page: Int = 0
    @Published var searchTextLoading: String = "" {
        willSet {
            if newValue != searchTextLoading {
                searchText = newValue
            }
        }
    }
    @Published private(set) var isPageLoading: Bool = false
    
    var searchText: String? {
        willSet {
            print("searchText", searchText)
            loadPage()
        }
    }
    
    
    func setup(_ context: NSManagedObjectContext, networkService: NetworkService) {
        self.context = context
        self.networkService = networkService
        subscribe()
    }
    
    var count: Int = 0
    
    private func subscribe() {
        if let networkService = networkService {
            networkServiceSubscriber = networkService.networkServicePublisher
                .subscribe(on: networkService.apiResponseQueue)
                .sink{value in
                if let movieOmdbapiObjects = value as? [MovieOmdbapiObject] {
                    self.count += 1
                    print("Получены данные", self.count)
                    self.items.append(contentsOf: movieOmdbapiObjects)
                    self.isPageLoading = false
                }
            }
        }
    }
    
    func loadPage() {
        guard let title = searchText, let networkService = self.networkService,
              isPageLoading == false else { return }
        isPageLoading = true
        page += 1
        print("value \(title), page \(page)")
        networkService.getSearchMovieRequest(title: title, page: page)
    }
    
    func clearSearch() {
        page = 0
        //searchTextLoading = ""
        items.removeAll()
    }
}

extension MovieOmdbapiObject: Identifiable {
    public var id: UUID { UUID() }
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
