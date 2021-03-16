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
    var apiRequestQueue: DispatchQueue { get }
    var apiResponseQueue: DispatchQueue { get }
    var publisher: PassthroughSubject<Any, Error> { get set }
}

final class NetworkServiceImpl: NetworkService {
    
    lazy var apiRequestQueue: DispatchQueue = {
        return DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).networkServiceRequestQueue" : "networkServiceRequestQueue", qos: .utility)
    }()
    var apiResponseQueue: DispatchQueue
    var publisher: PassthroughSubject<Any, Error> = .init()
    
    init(apiResponseQueue: DispatchQueue) {
        self.apiResponseQueue = apiResponseQueue
        onAppear()
    }
    
    private func onAppear() {
        loadGenresFromTmdb()
        loadPopularMoviesFromTmdb()
    }
    
    private func loadGenresFromTmdb() {
        apiRequestQueue.async {
            TmdbAPI.DefaultAPI.genreMovieListGet(apiKey: API.tmdbApiKey.description, apiResponseQueue: self.apiResponseQueue) { (response, error) in
                if let error = error {
                    self.publisher.send(completion: .failure(error))
                }
                if let genres = response?.genres {
                    self.publisher.send(genres)
                }
            }
        }
    }
    
    private func loadPopularMoviesFromTmdb() {
        apiRequestQueue.async {
            TmdbAPI.DefaultAPI.moviePopularGet(apiKey: API.tmdbApiKey.description, apiResponseQueue: self.apiResponseQueue) { (response, error) in
                if let error = error {
                    self.publisher.send(completion: .failure(error))
                }
                if let popularMoviesList =  response?.results {
                    self.publisher.send(popularMoviesList)
                }
            }
        }
    }
}

extension NetworkServiceImpl {
    enum API: CustomStringConvertible {
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

}
