//
//  NetworkService.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 16.03.2021.
//

import Foundation
import Combine
import TmdbAPI

public protocol NetworkService {
    
    var networkServiceRequestQueue: DispatchQueue { get set }
    var networkServiceResponseQueue: DispatchQueue? { get}
}

public final class NetworkServiceImpl: NetworkService {

    private var tmdbApiKey: String
    public let networkServicePublisher = PassthroughSubject<Any,Error>()
    public lazy var networkServiceRequestQueue: DispatchQueue = {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).networkServiceRequestQueue" : "networkServiceRequestQueue", qos: .utility)
        return queue
    }()
    public var networkServiceResponseQueue: DispatchQueue? = nil
    
    private var popularMoviesList: [MovieListResultObject]? {
        willSet {
            if popularMoviesList == nil, let newValue = newValue {
                print(newValue.count)
            }
        }
    }
    
    public init(tmdbApiKey: String, networkServiceResponseQueue: DispatchQueue) {
        self.tmdbApiKey = tmdbApiKey
        self.networkServiceResponseQueue = networkServiceResponseQueue
        self.setup()
    }
    
    public func setup() {
        self.loadGenresFromTmdb()
        self.loadPopularMoviesFromTmdb()
    }
    
    public func loadGenresFromTmdb() {
        
        guard let apiResponseQueue = self.networkServiceResponseQueue
        else { return }
        
        networkServiceRequestQueue.async {
            TmdbAPI.DefaultAPI.genreMovieListGet(apiKey: self.tmdbApiKey, apiResponseQueue: apiResponseQueue) { (response, error) in
                if let error = error {
                    self.networkServicePublisher.send(completion: .failure(error))
                }
                if let genres = response?.genres {
                    self.networkServicePublisher.send(genres)
                }
            }
        }
    }
    
    public func loadPopularMoviesFromTmdb() {
        networkServiceRequestQueue.async {
            TmdbAPI.DefaultAPI.moviePopularGet(apiKey: self.tmdbApiKey) { (response, error) in
                if let error = error {
                    self.networkServicePublisher.send(completion: .failure(error))
                }
                if let popularMoviesList =  response?.results {
                    self.popularMoviesList = popularMoviesList
                }
            }
        }
    }
}
