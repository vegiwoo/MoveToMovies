//
//  DashboardViewModel.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import CoreData
import MapKit
import TmdbAPI

final class DashboardViewModel: ObservableObject {
    
    private var networkService: NetworkService?
    private var dataStorageService: DataStorageService?
    
    lazy private var context: NSManagedObjectContext? = nil
    let queue = DispatchQueue.global(qos: .utility)
    
    var popularMoviesIds: [Int] = .init()

    func setup(networkService: NetworkService, dataStorageService: DataStorageService) {
        self.networkService = networkService
        self.dataStorageService = dataStorageService
    }
    
//    // MARK: Network
//    func loadPopularMoviesInfo() {
//        
//        let movieEntityName = "MovieItem"
//        
//        popularMoviesIds.forEach{
//            TmdbAPI.DefaultAPI.movieMovieIdGet(movieId: $0, apiKey: API.tmdbApiKey.description) { (movie, error) in
//                if let error = error {
//                    print("🔴 \(error.localizedDescription)")
//                }
//                
//                guard let movie = movie, let id = movie.id, let title = movie.title, let context = self.context  else { return }
//
//                let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntityName)
//                movieFetchRequest.predicate = NSPredicate(format: "id == %@ AND title == %i", id, title)
//                let existingMovies = try! context.fetch(movieFetchRequest) as! [MovieItem]
//                
//                if let existingMovie = existingMovies.first {
//                    
//                    if let popularity = movie.popularity {existingMovie.popularity = popularity}
//                    if let revenue = movie.revenue {existingMovie.revenue = Int32(revenue)}
//                    if let runtime = movie.runtime {existingMovie.runtime = Int32(runtime)}
//                    if let status = movie.status?.rawValue {existingMovie.status = status}
//                    if let tagline = movie.tagline {existingMovie.tagline = tagline}
//                    if let voteAverage = movie.voteAverage {existingMovie.voteAverage = voteAverage}
//                    if let voteCount = movie.voteCount {existingMovie.voteCount = Int32(voteCount)}
//                    
//                    try! context.save()
//                    
//                } else {
//                    self.save(movie: movie, id: id, title: title, movieEntityName: movieEntityName, in: context)
//                }
//            }
//        }
//    }
//    
//    func loadImages(movieId: Int, posterPath: String?, backdropPath: String?, posterSize: PosterSizes) {
//        
//        guard let context = context else { return }
//        
//        let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieItem")
//        movieFetchRequest.predicate = NSPredicate(format: "%K = %@", "id", movieId)
//        let existingMovies = try! context.fetch(movieFetchRequest) as! [MovieItem]
//        
//        if let existingMovie = existingMovies.first {
//            
//            let tmdbImagesPath = API.tmdbImagesPath.description
// 
//            // poster
//            if let posterPath = posterPath {
//                let posterString = "\(tmdbImagesPath)\(posterSize)\(posterPath)"
//                
//                guard let posterUrl = URL(string: posterString) else { fatalError()}
//                
//                self.loadData(from: posterUrl) { (data, response, error) in
//                    if let error = error {
//                        print("🔴 \(error.localizedDescription)")
//                    }
//                    if let data = data {
//                        let poster = NSEntityDescription.insertNewObject(forEntityName: "PosterItem", into: context) as! PosterItem
//                        poster.blob = data
//                        existingMovie.movieToPoster = poster
//                        try! context.save()
//                    }
//                }
//            }
//
//            //backdrop
//            if let backdropPath = backdropPath {
//                let backdropString = "\(tmdbImagesPath)\(posterSize)\(backdropPath)"
//                guard  let backdropUrl = URL(string: backdropString)
//                else { fatalError() }
//                
//                self.loadData(from: backdropUrl) { (data, response, error) in
//                    if let error = error {
//                        print("🔴 \(error.localizedDescription)")
//                    }
//                    if let data = data {
//                        let backdrop = NSEntityDescription.insertNewObject(forEntityName: "BackdropItem", into: context) as! BackdropItem
//                        backdrop.blob = data
//                        existingMovie.movieToBackdrop = backdrop
//                        try! context.save()
//                    }
//                }
//            }
//        }
//    }
//    
//    private func loadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//    
//    // MARK: Data store
//    private func fetchingGernes(by genresId: [Int]?, in context:  NSManagedObjectContext) -> NSSet? {
//        
//        guard let ids = genresId else { return nil }
//        
//        let entityName = "GenreItem"
//        
//        let genresFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        genresFetchRequest.predicate =  NSPredicate(format: "id IN %@", ids)
//        let fetchingGenres = try! context.fetch(genresFetchRequest) as! [GenreItem]
//        return NSSet(objects: fetchingGenres)
//    }
//    
//    private func save(movie: Movie, id: Int, title: String, movieEntityName: String, in context: NSManagedObjectContext) {
//        
//        let newMovie = NSEntityDescription.insertNewObject(forEntityName: movieEntityName, into: context) as! MovieItem
//        
//        if let adult = movie.adult {newMovie.adult = adult}
//        if let backdropPath = movie.backdropPath {newMovie.backdropPath = backdropPath}
//        if let budget = movie.budget {newMovie.budget = Int32(budget)}
//        if let homepage = movie.homepage {newMovie.homepage = homepage}
//        newMovie.id = Int32(id)
//        if let imdbId = movie.imdbId {newMovie.imdbId = imdbId}
//        if let originalTitle = movie.originalTitle {newMovie.originalTitle = originalTitle}
//        if let overview = movie.overview {newMovie.overview = overview}
//        if let popularity = movie.popularity {newMovie.popularity = popularity}
//        if let releaseDateString = movie.releaseDate {newMovie.releaseDate = releaseDateString.toDate()}
//        if let revenue = movie.revenue {newMovie.revenue = Int32(revenue)}
//        if let runtime = movie.runtime {newMovie.runtime = Int32(runtime)}
//        if let originalLanguage = movie.originalLanguage {newMovie.originalLanguage = originalLanguage}
//        if let status = movie.status?.rawValue {newMovie.status = status}
//        if let tagline = movie.tagline {newMovie.tagline = tagline}
//        newMovie.title = title
//        if let video = movie.video { newMovie.video = video}
//        if let voteAverage = movie.voteAverage {newMovie.voteAverage = voteAverage}
//        if let voteCount = movie.voteCount {newMovie.voteCount = Int32(voteCount)}
//        
//        var collectionItem: CollectionItem?
//        var genreItems: NSSet?
//        var companyItems: NSSet?
//        var countriesItems: NSSet?
//        var languagesItems: NSSet?
//        
//        if let collection = movie.belongsToCollection {
//            collectionItem = self.save(collection: collection, in: context)
//        }
//        
//        if let genres = movie.genres {
//            genreItems = self.fetchingGernes(by: genres.compactMap{$0.id}, in: context)
//        }
//        
//        if let companies = movie.productionCompanies {
//            companyItems = self.save(productionCompanies: companies, in: context)
//        }
//        
//        if let countries = movie.productionCountries {
//            countriesItems = self.save(productionCountries: countries, in: context)
//        }
//        
//        if let spokenLanguages = movie.spokenLanguages {
//            languagesItems = self.save(spokenLanguages: spokenLanguages, in: context)
//        }
//        
//        newMovie.movieToCollection = collectionItem
//        newMovie.movieToGernes = genreItems
//        newMovie.movieToCompany = companyItems
//        newMovie.movieToCountries = countriesItems
//        newMovie.movieToLanguages = languagesItems
//        
//        try! context.save()
//        
//        queue.async {
//            self.loadImages(movieId: id, posterPath: movie.posterPath, backdropPath: movie.backdropPath, posterSize: .w500)
//            
//        }
//        
//       
//    }
//    
//    private func save(collection: MovieBelongsToCollection, in context: NSManagedObjectContext) -> CollectionItem? {
//        
//        guard let id = collection.id else { return nil}
//        
//        let entityName = "CollectionItem"
//        
//        let collectionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        collectionFetchRequest.predicate = NSPredicate(format: "%K = %@", "id", id)
//        let fetchItems = try! context.fetch(collectionFetchRequest) as! [CollectionItem]
//        
//        if let existingCollectionItem = fetchItems.first {
//            return existingCollectionItem
//        } else {
//            let newCollectionItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! CollectionItem
//            
//            if let collectionid = collection.id {
//                newCollectionItem.id = Int32(collectionid)
//            }
//            if let collectionName = collection.name {
//                newCollectionItem.name = collectionName
//            }
//            if let posterPath = collection.posterPath {
//                newCollectionItem.posterPath = posterPath
//            }
//            if let backdropPath = collection.backdropPath {
//                newCollectionItem.backdropPath = backdropPath
//            }
//            try! context.save()
//            
//            return newCollectionItem
//        }
//    }
//    
//    private func save(productionCompanies: [ProductionCompany], in context: NSManagedObjectContext) -> NSSet? {
//        
//        let entityName = "ProductionCompanyItem"
//        var results: [ProductionCompanyItem] = .init()
//        
//        for company in productionCompanies {
//            guard let companyId = company.id, let name = company.name else { continue }
//            
//            let companyFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//            companyFetchRequest.predicate = NSPredicate(format: "id == %@ AND name == %i",  Int32(companyId), name)
//            let existingCompanies = try! context.fetch(companyFetchRequest) as! [ProductionCompanyItem]
//            
//            if let existingCompany = existingCompanies.first {
//                results.append(existingCompany)
//            } else {
//                let newCompany = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ProductionCompanyItem
//                newCompany.id = Int32(companyId)
//                newCompany.name = name
//                if let logoPath = newCompany.logoPath {newCompany.logoPath = logoPath}
//                if let originCountry = newCompany.originCountry { newCompany.originCountry = originCountry}
//                
//                do {
//                    try context.save(); results.append(newCompany)
//                } catch {
//                    print("🔴 \(error.localizedDescription)")
//                }
//            }
//        }
//        return NSSet(objects: results)
//    }
//    
//    private func save(productionCountries: [ProductionCountry], in context: NSManagedObjectContext) -> NSSet? {
//        
//        let entityName = "ProductionCountryItem"
//        var results: [ProductionCountryItem] = .init()
//        
//        for country in productionCountries {
//            guard let name = country.name else { continue }
//            
//            let countryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//            countryFetchRequest.predicate = NSPredicate(format: "id == %@ AND name == %i",  country.id as CVarArg, name)
//            let existingCounties = try! context.fetch(countryFetchRequest) as! [ProductionCountryItem]
//            
//            if let existingCountry = existingCounties.first {
//                results.append(existingCountry)
//            } else {
//                let newCountry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ProductionCountryItem
//                
//                newCountry.id = country.id; newCountry.name = name
//                if let iso31661 = country.iso31661 { newCountry.iso31661 = iso31661}
//                
//                let searchRequest = MKLocalSearch.Request()
//                searchRequest.naturalLanguageQuery = newCountry.name
//                let search = MKLocalSearch(request: searchRequest)
//                
//                search.start { (response, error)  in
//                    guard let response = response else {
//                        print("Error: \(error?.localizedDescription ?? "Unknown error").")
//                        return
//                    }
//                    
//                    if let coordinate = response.mapItems.first?.placemark.coordinate{
//                        newCountry.latitude = coordinate.latitude
//                        newCountry.longitude = coordinate.longitude
//                    }
//                    
//                    try! context.save(); results.append(newCountry)
//                    print("save coordinate!")
//                }
//            }
//        }
//        return NSSet(objects: results)
//    }
//    
//    private func save(spokenLanguages: [SpokenLanguage], in context: NSManagedObjectContext) -> NSSet? {
//        
//        let entityName = "SpokenLanguageItem"
//        var results: [SpokenLanguageItem] = .init()
//        
//        for language in spokenLanguages {
//            guard let name = language.name else { continue }
//            
//            let languageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//            languageFetchRequest.predicate = NSPredicate(format: "name == %@", name)
//            let existingLanguages = try! context.fetch(languageFetchRequest) as! [SpokenLanguageItem]
//            
//            if let existingLanguage = existingLanguages.first {
//                results.append(existingLanguage)
//            } else {
//                let newLanguage = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! SpokenLanguageItem
//                newLanguage.name = name
//                if let iso6391 = language.iso6391 {newLanguage.iso6391 = iso6391}
//                
//                do {
//                    try context.save(); results.append(newLanguage)
//                } catch {
//                    print("🔴 \(error.localizedDescription)")
//                }
//            }
//            
//        }
//        
//        return NSSet(objects: results)
//    }
}


enum PosterSizes {
    case w92, w154, w185, w342, w500, w780, original
}
