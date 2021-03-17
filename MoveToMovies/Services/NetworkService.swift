//
//  NetworkService.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 16.03.2021.
//

import Foundation
import MapKit
import Combine
import TmdbAPI

public protocol NetworkService {
    var apiRequestQueue: DispatchQueue { get }
    var apiResponseQueue: DispatchQueue { get }
    var networkServicePublisher: PassthroughSubject<Any, Never> { get set }
}

final class NetworkServiceImpl: NetworkService {
    
    lazy var apiRequestQueue: DispatchQueue = {
        return DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).networkServiceRequestQueue" : "networkServiceRequestQueue", qos: .utility)
    }()
    var apiResponseQueue: DispatchQueue
    var networkServicePublisher: PassthroughSubject<Any, Never> = .init()
    var dataStorePublisher: PassthroughSubject<Any, Never>
    
    var dataStorageSubscriber: AnyCancellable?
    
    private var popularMoviesList: [MovieListResultObject]? {
        willSet {
            if popularMoviesList == nil || (popularMoviesList != nil &&  popularMoviesList!.isEmpty), let newValue = newValue {
                let ids = newValue.compactMap{$0.id}
                if ids.count > 0 {
                    networkServicePublisher.send(ids)
                    loadPopularMoviesInfoFromTmdb(with: ids)
                }
            }
        }
    }
    
    private var popularMoviesInfoList: [Movie]? {
        willSet {
            if let newValue = newValue {
                if let cointries = newValue.last?.productionCountries {
                    self.check(cointries: cointries)
                }
            }
        }
    }
    
    private var existingCountries: [String: ProductionCountyDTO]? {
        willSet {
            if let newValue = newValue {
                if existingCountries?.count != newValue.count {
                    
                }
            }
        }
    }
    
    init(apiResponseQueue: DispatchQueue, dataStorePublisher: PassthroughSubject<Any, Never>) {
        self.apiResponseQueue = apiResponseQueue
        self.dataStorePublisher = dataStorePublisher
        onAppear()
    }
    
    private func onAppear() {
        subscribe()
        loadGenresFromTmdb()
        loadPopularMoviesListFromTmdb()
    }
    
    private func subscribe() {
        dataStorageSubscriber = dataStorePublisher
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                print("🟢 NetworkService: DataStorePublisher finished in NetworkService.")
            }
        }, receiveValue: { (value) in
            if let existingCountries = value as? [ProductionCountyDTO] {
                for country in existingCountries {
                    if self.existingCountries == nil {
                        self.existingCountries = [String: ProductionCountyDTO]()
                    }
                    self.existingCountries?.updateValue(country, forKey: country.tag)
                }
                print("🟢 NetworkService: Info about \(existingCountries.count) countries was obtained from database.")
            }
           
        })
    }
    
    private func unscribe() {
        dataStorageSubscriber?.cancel()
    }
    
    private func loadGenresFromTmdb() {
        apiRequestQueue.async {
            TmdbAPI.DefaultAPI.genreMovieListGet(apiKey: API.tmdbApiKey.description, apiResponseQueue: self.apiResponseQueue) { (response, error) in
                if let error = error {
                    print("🔴 ERROR in NetworkService:\n\(error.localizedDescription)")
                }
                if let genres = response?.genres {
                    self.networkServicePublisher.send(genres)
                }
            }
        }
    }
    
    private func loadPopularMoviesListFromTmdb() {
        apiRequestQueue.async {
            TmdbAPI.DefaultAPI.moviePopularGet(apiKey: API.tmdbApiKey.description, apiResponseQueue: self.apiResponseQueue) { (response, error) in
                if let error = error {
                    print("🔴 ERROR in NetworkService:\n\(error.localizedDescription)")
                }
                if let popularMoviesList =  response?.results {
                    self.popularMoviesList = popularMoviesList
                }
            }
        }
    }
    
    private func loadPopularMoviesInfoFromTmdb(with ids: [Int]) {
                
        self.popularMoviesInfoList = [Movie]()
        
        apiRequestQueue.async {
            for id in ids {
                TmdbAPI.DefaultAPI.movieMovieIdGet(movieId: id, apiKey: API.tmdbApiKey.description) { (movie, error) in
                    if let error = error {
                        print("🔴 ERROR in NetworkService:\n\(error.localizedDescription)")
                    }
                    if let movie = movie {
                        self.popularMoviesInfoList!.append(movie)
                        self.networkServicePublisher.send(movie)
                    }
                }
            }
            
            
        }
    }
    
    private func check(cointries: [ProductionCountry]) {
        for country in cointries {
            if let existingCountries = self.existingCountries {
                if let tag = country.iso31661, let itemIsInDB = existingCountries[tag] {
                    if itemIsInDB.coordinate != nil {
                        continue
                    } else {
                        self.getCoordinatesBy(countryName: itemIsInDB.name, withIso: tag)
                    }
                } else {
                    self.getCoordinatesBy(countryName: country.name, withIso: country.iso31661)
                }
            } else {
                self.getCoordinatesBy(countryName: country.name, withIso: country.iso31661)
            }
        }
    }
    
    private func getCoordinatesBy(countryName name: String?, withIso tag: String?) {
        guard let name = name, let tag = tag else { return }
        
        apiRequestQueue.async {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = name
            let search = MKLocalSearch(request: searchRequest)
            
            
            search.start { (response, error)  in
                guard let response = response else {
                    print("🔴 ERROR Direct geocoding in NetworkService:\n \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
                
                if let coordinate = response.mapItems.first?.placemark.coordinate{
                    self.apiResponseQueue.async {
                        self.networkServicePublisher.send(ProductionCountyDTO(tag: tag, name: name, coordinate: coordinate))
                    }
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
