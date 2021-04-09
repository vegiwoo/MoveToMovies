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
import OmdbAPI

public protocol NetworkService {
    var apiRequestQueue: DispatchQueue { get }
    var apiResponseQueue: DispatchQueue { get }
    var networkServicePublisher: PassthroughSubject<Any, Never> { get set }
    func getSearchMovieRequest(title: String, page: Int)
}

final class NetworkServiceImpl: NetworkService {

    lazy var apiRequestQueue: DispatchQueue = {
        return DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).networkServiceRequestQueue" : "networkServiceRequestQueue", qos: .utility)
    }()
    var apiResponseQueue: DispatchQueue
    var networkServicePublisher: PassthroughSubject<Any, Never> = .init()
    var dataStoragePublisher: DataStoragePublisher
    
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
                if let movie = newValue.last {
                    self.networkServicePublisher.send(movie)
                }
            }
        }
    }
    
    private var existingCountries: [String: ProductionCountyDTO]? 

    init(apiResponseQueue: DispatchQueue, dataStoragePublisher: DataStoragePublisher) {
        self.apiResponseQueue = apiResponseQueue
        self.dataStoragePublisher = dataStoragePublisher
        onAppear()
    }
    
    private func onAppear() {
        subscribe()
        loadGenresFromTmdb()
        loadPopularMoviesListFromTmdb()
    }
    
    private func subscribe() {
        
        dataStorageSubscriber = dataStoragePublisher.requestPublisher
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                print("🟢 NetworkService: DataStorePublisher finished in NetworkService.")
            }
        }, receiveValue: { request in
            switch request {
            case .startUpdatingData:
                break
            case .completionUpdatingData:
                break
            case .getCoordinates(let existingCountries):
                for country in existingCountries {
                    if self.existingCountries == nil {
                        self.existingCountries = [String: ProductionCountyDTO]()
                    }
                    self.existingCountries?.updateValue(country, forKey: country.tag)
                }
                print("🟢 NetworkService: Info about \(existingCountries.count) countries was obtained from database.")
            case .getCovers(let coversDownloadRequest):
                self.loadCovers(with: coversDownloadRequest, posterSize: PosterSize.w500)
            }
    
        })
    }
    
    private func unscribe() {
        dataStorageSubscriber?.cancel()
    }
    
    // MARK: Tmdb
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
 
        apiRequestQueue.async {
            for id in ids {
                TmdbAPI.DefaultAPI.movieMovieIdGet(movieId: id, apiKey: API.tmdbApiKey.description) { (movie, error) in
                    if let error = error {
                        print("🔴 ERROR in NetworkService:\n\(error.localizedDescription)")
                    }
                    if let movie = movie {
                        if self.popularMoviesInfoList == nil {
                            self.popularMoviesInfoList = [Movie]()
                        }
                        self.popularMoviesInfoList!.append(movie)
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
    
    private func loadCovers(with request: CoversDownloadRequest, posterSize: PosterSize) {
       
        let tmdbImagesPath = API.tmdbImagesPath.description
        
        var posterBlob: Data? {
            didSet {
                if let posterBlob = posterBlob, request.backdropPath == nil {
                    apiResponseQueue.async {
                        self.networkServicePublisher.send(CoversDownloadResponse(movieItemId: request.movieItemId, posterBlobData: posterBlob, backdropBlobData: nil))
                    }
                }
            }
        }
        var backdropBlob: Data? {
            didSet {
                if let backdropBlob = backdropBlob {
                    //print("movieId \(request.movieItemId) backdropBlob count", backdropBlob.count)
                    apiResponseQueue.async {
                        self.networkServicePublisher.send(CoversDownloadResponse(movieItemId: request.movieItemId, posterBlobData: posterBlob, backdropBlobData: backdropBlob))
                    }
                    
                }
            }
        }
        
        var posterBlobWorkItem: DispatchWorkItem?
        var backdropBlobWorkItem: DispatchWorkItem?
  
        if let posterPath = request.posterPath {
            let posterURLString = "\(tmdbImagesPath)\(posterSize)\(posterPath)"
            guard let posterUrl = URL(string: posterURLString) else { fatalError() }
            
            posterBlobWorkItem = DispatchWorkItem { self.loadData(from: posterUrl) { (data, response, error) in
                if let error = error {
                    print("🔴 ERROR in NetworkService:\n\(error.localizedDescription)")
                }
                if let data = data {
                    posterBlob = data
                }
            }}
        }
        
        if let backdropPath = request.backdropPath {
            let backdropURLString = "\(tmdbImagesPath)\(posterSize)\(backdropPath)"
            
            guard let backdropUrl = URL(string: backdropURLString) else { fatalError() }
            
            backdropBlobWorkItem = DispatchWorkItem { self.loadData(from: backdropUrl) { (data, response, error) in
                if let error = error {
                    print("🔴 ERROR in NetworkService:\n\(error.localizedDescription)")
                }
                if let data = data {
                    backdropBlob = data
                }
            }}
            
        }
        
        if let workItem1 = posterBlobWorkItem, let workItem2 = backdropBlobWorkItem {
            apiRequestQueue.async(execute: workItem1)
            workItem1.notify(queue: apiRequestQueue, execute: workItem2)
        } else if let workItem1 = posterBlobWorkItem, backdropBlobWorkItem == nil {
            apiRequestQueue.async(execute: workItem1)
        } else if posterBlobWorkItem == nil, let workItem2 = backdropBlobWorkItem {
            apiRequestQueue.async(execute: workItem2)
        } else {
            return
        }
    }
    
    private func loadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    // MARK: Omdb
    func getSearchMovieRequest(title: String, page: Int) {
        apiResponseQueue.async(flags: .barrier) {
            OmdbAPI.DefaultAPI.rootGet(s: title, apikey: API.omdbApiKey.description, page: page) { (response, error) in
                if let error = error {
                    print("🔴 ERROR NetworkService: \(error.localizedDescription)")
                    print(error)
                }
                
                guard let totalResultsString = response?.totalResults,
                      let totalResults = Int(totalResultsString),
                      let items = response?.search else {
                    return
                }
                
                self.apiResponseQueue.async {
                    self.networkServicePublisher.send((movies: items, totalResults: totalResults))
                }
            }
        }
    }
}

extension NetworkServiceImpl {
    enum API: CustomStringConvertible {
        case tmdbApiKey
        case tmdbImagesPath
        case omdbApiKey
        var description: String {
            switch self {
            case .tmdbApiKey:
                return "2e6b2f25124ca8304e9b74fb99176e96"
            case .tmdbImagesPath:
                return "https://image.tmdb.org/t/p/"
            case .omdbApiKey:
                return "90001c5d"
            }
        }
    }
}
