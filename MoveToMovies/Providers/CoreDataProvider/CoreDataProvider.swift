//
//  CoreDataProvider.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 09.04.2021.
//

import Foundation
import CoreData
import Combine
import TmdbAPI
import Architecture

class CoreDataProvider: Singletonable {
    required init(container: IContainer, args: Void) { }
    
    var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "MoveToMoviesModel")
        
        var context: NSManagedObjectContext = .init(concurrencyType: .privateQueueConcurrencyType)
       
        container.loadPersistentStores { (storeDescription, error)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            context = container.viewContext
            context.automaticallyMergesChangesFromParent = true
            
            print("🟢 Core Data stack has been initialized with description:\n \(storeDescription)")
        }
        return context
    }()
    
    // MARK: Common
    func clearStrorаge () {
        self.context.perform {
            ["GenreItem", "MovieItem", "CollectionItem", "PosterItem", "BackdropItem", "ProductionCountryItem", "ProductionCompanyItem", "SpokenLanguageItem"].forEach {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: $0)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try self.context.execute(deleteRequest)
                    print("DEBUG: CoreDataProvider: Remove all \($0) from DB complete.")
                } catch {
                    print("ERROR: CoreDataProvider: Remove all \($0) from DB error\n\(error.localizedDescription).")
                }
            }
        }   
    }
    
    func saveContext()  {
        self.context.perform {
            if self.context.hasChanges {
                try! self.context.save()
            }
        }
    }

    // MARK: TMDB Api - Genres
    func save(genres: [Genre]) -> AnyPublisher<String,Never> {

        let entityName = "GenreItem"
        
        let genresFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let existingGenres = try! self.context.fetch(genresFetchRequest) as! [GenreItem]
        if existingGenres.count != genres.count {
            for genre in genres {
                guard let id = genre.id,
                      let name = genre.name
                else { continue }
                
                self.context.perform {
                    let newGenre = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! GenreItem
                    
                    newGenre.id = Int32(id)
                    newGenre.name = name
                    
                    self.saveContext()
                }
            }
            return Just("💾 Info about \(genres.count) genres SAVED in the database").eraseToAnyPublisher()
        } else {
            return Just("💾 Info about \(genres.count) genres UPDATED in the database").eraseToAnyPublisher()
        }
    }
    
    private func fetchingGenres(byIds ids: [Int]?) -> Deferred<Future<[GenreItem]?, Never>> {
        
        return Deferred{Future<[GenreItem]?, Never> {promise in
            if let ids = ids {
                let entityName = "GenreItem"
                let genresFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                genresFetchRequest.predicate =  NSPredicate(format: "id IN %@", ids)
                promise(.success(try! self.context.fetch(genresFetchRequest) as! [GenreItem]))
            } else { promise(.success(nil))}
        }}
    }
 
    // MARK: Movie
    func store(movies: [Movie]) -> AnyPublisher<[(imdbId: String, posterPath: String?, backdropPath: String?)],Never>?{
        
        let entityName = "MovieItem"
        
        var futures: [Future<(imdbId: String, posterPath: String?, backdropPath: String?), Never>] = []
        
        for movie in movies {
            guard let title = movie.title
            else { continue }
            
            var future: Future<(imdbId: String, posterPath: String?, backdropPath: String?), Never>
            
            let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            movieFetchRequest.predicate =  NSPredicate(format: "title == %@", title)
            
            let existingMovies = try! self.context.fetch(movieFetchRequest) as! [MovieItem]
            
            if let existingMovie = existingMovies.first {
                // Update existing movie
                future = Future<(imdbId: String, posterPath: String?, backdropPath: String?),Never> { promise in
                    
                    if let popularity = movie.popularity {existingMovie.popularity = popularity}
                    if let revenue = movie.revenue {existingMovie.revenue = Int32(revenue)}
                    if let runtime = movie.runtime {existingMovie.runtime = Int32(runtime)}
                    if let status = movie.status?.rawValue {existingMovie.status = status}
                    if let tagline = movie.tagline {existingMovie.tagline = tagline}
                    if let voteAverage = movie.voteAverage {existingMovie.voteAverage = voteAverage}
                    if let voteCount = movie.voteCount {existingMovie.voteCount = Int32(voteCount)}
                    
                    self.saveContext()
                    //print("💾 Movie with id '\(existingMovie.id)' saved in DB.")
                    promise(.success((imdbId: movie.imdbId!,
                                      posterPath: movie.posterPath,
                                      backdropPath: movie.backdropPath)))
                }
                
            } else {
                // Save new movie
                future = self.save(entityName: entityName, movie: movie)
            }
            futures.append(future)
        }
        
        return Publishers.MergeMany(futures).collect().eraseToAnyPublisher()
    }
    
    private func save(entityName: String, movie: Movie) -> Future<(imdbId: String, posterPath: String?, backdropPath: String?), Never>{
        
        return Future<(imdbId: String, posterPath: String?, backdropPath: String?),Never> {promise in
            // Create new MovieItem
            let newMovie = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! MovieItem
            
            if let adult = movie.adult {newMovie.adult = adult}
            if let backdropPath = movie.backdropPath {newMovie.backdropPath = backdropPath}
            if let budget = movie.budget {newMovie.budget = Int32(budget)}
            if let homepage = movie.homepage {newMovie.homepage = homepage}
            if let id = movie.id {newMovie.id = Int32(id)}
            if let imdbId = movie.imdbId {newMovie.imdbId = imdbId}
            if let originalTitle = movie.originalTitle {newMovie.originalTitle = originalTitle}
            if let overview = movie.overview {newMovie.overview = overview}
            if let popularity = movie.popularity {newMovie.popularity = popularity}
            if let releaseDateString = movie.releaseDate {newMovie.releaseDate = releaseDateString.toDate()}
            if let revenue = movie.revenue {newMovie.revenue = Int32(revenue)}
            if let runtime = movie.runtime {newMovie.runtime = Int32(runtime)}
            if let originalLanguage = movie.originalLanguage {newMovie.originalLanguage = originalLanguage}
            if let status = movie.status?.rawValue {newMovie.status = status}
            if let tagline = movie.tagline {newMovie.tagline = tagline}
            if let title = movie.title {newMovie.title = title}
            if let video = movie.video { newMovie.video = video}
            if let voteAverage = movie.voteAverage {newMovie.voteAverage = voteAverage}
            if let voteCount = movie.voteCount {newMovie.voteCount = Int32(voteCount)}
            
            var collectionFuture: Deferred<Future<CollectionItem?, Never>> = Deferred{Future<CollectionItem?, Never> {promise in
                promise(.success(nil))
            }}
            var genresFuture: Deferred<Future<[GenreItem]?, Never>> = Deferred{Future<[GenreItem]?, Never> {promise in
                promise(.success(nil))
            }}
            var companiesFuture: Deferred<Future<[ProductionCompanyItem]?, Never>> = Deferred{Future<[ProductionCompanyItem]?, Never> {promise in
                promise(.success(nil))
            }}
            var countriesFuture: Deferred<Future<[ProductionCountryItem]?, Never>> = Deferred{Future<[ProductionCountryItem]?, Never> {promise in
                promise(.success(nil))
            }}
            var languagesFuture: Deferred<Future<[SpokenLanguageItem]?, Never>> = Deferred{Future<[SpokenLanguageItem]?, Never> {promise in
                promise(.success(nil))
            }}
            
            // Collection
            if let collection = movie.belongsToCollection {
                collectionFuture = self.save(collection: collection)
            }
            // Genres
            if let genres = movie.genres {
                genresFuture = self.fetchingGenres(byIds: genres.compactMap{$0.id})
            }
            // Production Companies
            if let companies = movie.productionCompanies {
                companiesFuture = self.save(productionCompanies: companies)
            }
            // Production Counrtries
            if let countries = movie.productionCountries {
                countriesFuture = self.save(productionCountries: countries)
            }
            // Spoken Languages
            if let spokenLanguages = movie.spokenLanguages {
                languagesFuture = self.save(spokenLanguages: spokenLanguages)
            }

            let cancellable01 = Publishers.Zip4(collectionFuture, genresFuture, companiesFuture, countriesFuture).sink {values in
                if let collectionItem = values.0 {
                    newMovie.collection = collectionItem
                    //print(newMovie.collection?.name ?? "no collection for movie")
                }
                if let genreItems = values.1 {
                    for gerne in genreItems {
                        newMovie.addToGenres(gerne)
                        //print("genre \(gerne.name ?? "unknown") add to movie")
                    }
                }
                if let companiesItems = values.2 {
                    for company in companiesItems {
                        newMovie.addToCompanies(company)
                        //print("company \(company.name ?? "unknown") add to movie")
                    }
                }
                if let countriesItems = values.3{
                    for country in countriesItems {
                        newMovie.addToCountries(country)
                        //print("country \(country.iso31661 ?? "unknown tag") add to movie")
                    }
                }

            }
            let cancellable02 = languagesFuture.sink { languagesItems in
                if let languagesItems = languagesItems {
                    for languagesItem in languagesItems {
                        newMovie.addToLanguages(languagesItem)
                        //print("languages \(languagesItem.iso6391 ?? "unknown tag") add to movie")
                    }
                }
                
                self.saveContext()
                //print("💾 Movie with id '\(newMovie.id)' saved in DB.")
            
                promise(.success((imdbId: movie.imdbId!,
                                  posterPath: movie.posterPath,
                                  backdropPath: movie.backdropPath)))
            }
            [cancellable01, cancellable02].forEach{$0.cancel()}
        }
  
    }
    
    private func fetshingMovie(by imdbId: String) -> MovieItem? {
        let entityName = "MovieItem"
        let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        movieFetchRequest.predicate =  NSPredicate(format: "imdbId == %@", imdbId)
        let existingMovies = try! self.context.fetch(movieFetchRequest) as! [MovieItem]
        return existingMovies.first
    }

    func fetshingRandomMovie() -> MovieItem? {
        let entityName = "MovieItem"
        let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let existingMovies = try! self.context.fetch(movieFetchRequest) as! [MovieItem]
        return existingMovies.randomElement()
    }

    // MARK: Movie Covers
    func updateCovers(postersData: [(String, Data?)], backdropsData: [(String, Data?)]) -> AnyPublisher<Bool, Never> {
    
        return Future<Bool, Never> {promise in
            var counter: Int = 0
            for posterData in postersData {
                
                guard let movieItem = self.fetshingMovie(by: posterData.0)
                else { continue }
                
                if movieItem.poster == nil, let data = posterData.1 {
                    let entityName = "PosterItem"
                    let newPosterItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! PosterItem
                    
                    newPosterItem.blob = data
                    movieItem.poster = newPosterItem
                    
                    if movieItem.backdrop == nil,
                       let backdropData = backdropsData.first(where: {$0.0 == movieItem.imdbId}),
                       let data = backdropData.1 {
                        
                        let entityName = "BackdropItem"
                        let newBackdropItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! BackdropItem
                        
                        newBackdropItem.blob = data
                        movieItem.backdrop = newBackdropItem
                    }
                    
                    self.saveContext()
                    //print("💾 Update poster & backdrop data for movie with id \(String(describing: movieItem.imdbId))")
                }
                counter += 1
                if postersData.count == counter {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    // MARK: TMDB Api - Collection
    private func save(collection: MovieBelongsToCollection) -> Deferred<Future<CollectionItem?, Never>>  {
        
        return Deferred{Future<CollectionItem?, Never> {promise in
            guard let id = collection.id else { fatalError() }
            
            let entityName = "CollectionItem"
            
            let collectionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            collectionFetchRequest.predicate = NSPredicate(format: "%K == %i", "id", id)
            let fetchItems = try! self.context.fetch(collectionFetchRequest) as! [CollectionItem]
            
            if let existingCollectionItem = fetchItems.first {
                promise(.success(existingCollectionItem))
            } else {
                let newCollectionItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! CollectionItem
                
                if let collectionid = collection.id { newCollectionItem.id = Int32(collectionid) }
                if let collectionName = collection.name { newCollectionItem.name = collectionName }
                if let posterPath = collection.posterPath { newCollectionItem.posterPath = posterPath }
                if let backdropPath = collection.backdropPath { newCollectionItem.backdropPath = backdropPath }
                
                self.saveContext()
                print("💾 Collection with id '\(collection.id ?? 0)' saved in DB.")
                
                promise(.success(newCollectionItem))
            }
        }}
    }
    
    // MARK: TMDB Api - ProductionCompany
    private func save(productionCompanies: [ProductionCompany]) -> Deferred<Future<[ProductionCompanyItem]?, Never>> {
        return Deferred{Future<[ProductionCompanyItem]?, Never> {promise in
            let entityName = "ProductionCompanyItem"
            
            var results: [ProductionCompanyItem] = .init()
            
            for company in productionCompanies {
                guard let companyId = company.id,
                      let name = company.name
                else { continue }
                
                let companyFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                companyFetchRequest.predicate = NSPredicate(format: "name == %@", name)
                let existingCompanies = try! self.context.fetch(companyFetchRequest) as! [ProductionCompanyItem]
                
                if let existingCompany = existingCompanies.first {
                    // Existing Production company
                    results.append(existingCompany)
                } else {
                    // New Production company
                    let newCompany = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! ProductionCompanyItem
                    
                    newCompany.id = Int32(companyId)
                    newCompany.name = name
                    
                    if let logoPath = company.logoPath {newCompany.logoPath = logoPath}
                    if let originCountry = company.originCountry { newCompany.originCountry = originCountry}
                    
                    self.saveContext()
                    print("💾 Production company with id '\(newCompany.id)' SAVED in DB.")
                }
            }
            
            promise(.success(results))
        }}
    }
    
    // MARK: TMDB Api - ProductionCountry
    private func save(productionCountries: [ProductionCountry]) -> Deferred<Future<[ProductionCountryItem]?, Never>> {
        return Deferred{Future<[ProductionCountryItem]?, Never> {promise in
            let entityName = "ProductionCountryItem"
            var results: [ProductionCountryItem] = .init()
            
            for country in productionCountries {
                guard let name = country.name else { continue }
                
                let countryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                countryFetchRequest.predicate = NSPredicate(format: "id == %@ AND name == %i",  country.id as CVarArg, name)
                let existingCounties = try! self.context.fetch(countryFetchRequest) as! [ProductionCountryItem]
                
                if let existingCountry = existingCounties.first {
                    results.append(existingCountry)
                } else {
                    let newCountry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! ProductionCountryItem
                    
                    newCountry.id = country.id
                    newCountry.name = name
                    newCountry.iso31661 = country.iso31661
                    
                    self.saveContext()
                    print("💾 Country with tag '\(newCountry.iso31661 ?? "?")' SAVED in DB.")
                    results.append(newCountry)
                }
            }
            
            promise(.success(results))
        }}
    }
    
    // MARK: TMDB Api - SpokenLanguage
    private func save(spokenLanguages: [SpokenLanguage]) -> Deferred<Future<[SpokenLanguageItem]?, Never>> {
        return Deferred{Future<[SpokenLanguageItem]?, Never> {promise in
            
            let entityName = "SpokenLanguageItem"
            var results: [SpokenLanguageItem] = .init()
            
            for language in spokenLanguages {
                guard let name = language.name else { continue }
                
                let languageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                languageFetchRequest.predicate = NSPredicate(format: "name == %@", name)
                let existingLanguages = try! self.context.fetch(languageFetchRequest) as! [SpokenLanguageItem]
                
                if let existingLanguage = existingLanguages.first {
                    results.append(existingLanguage)
                } else {
                    let newLanguage = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! SpokenLanguageItem
                    newLanguage.name = name
                    if let iso6391 = language.iso6391 {newLanguage.iso6391 = iso6391}
                    
                    do {
                        try self.context.save()
                        print("💾 Spoken Language '\(newLanguage.name ?? "?")' saved in DB.")
                        results.append(newLanguage)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            promise(.success(results))
        }}
    }
}
