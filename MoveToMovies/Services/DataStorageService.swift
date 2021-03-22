//
//  DataStorageService.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 16.03.2021.
//

import Foundation
import CoreData
import MapKit
import Combine
import TmdbAPI

protocol DataStorageService {
    var context: NSManagedObjectContext { get }
    var networkResponseQueue: DispatchQueue { get set}
    var networkPublisher: PassthroughSubject<Any, Never> { get set }
    var networkSubscriber: AnyCancellable? { get }
    var dataStoragePublisher: DataStoragePublisher { get }
    func saveContext()
}

final class DataStorageServiceImpl: DataStorageService {
    
    var fetching: Bool = true
    
    var networkResponseQueue: DispatchQueue
    var networkPublisher: PassthroughSubject<Any, Never>
    var networkSubscriber: AnyCancellable?
    var dataStoragePublisher: DataStoragePublisher
    
    let dataStorageQueue: DispatchQueue = .init(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).dataStorageQueue" : "dataStorageQueue", qos: .utility)
    
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "MoveToMoviesModel")
        let persistentStoreDescriptions = NSPersistentStoreDescription()
        persistentStoreDescriptions.shouldMigrateStoreAutomatically = true
        persistentStoreDescriptions.shouldInferMappingModelAutomatically = true
        
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
   
    lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .utility
        return operationQueue
    }()
    
    init(networkResponseQueue: DispatchQueue, networkPublisher: PassthroughSubject<Any, Never>, dataStoragePublisher: DataStoragePublisher) {
        self.networkResponseQueue = networkResponseQueue
        self.networkPublisher = networkPublisher
        self.dataStoragePublisher = dataStoragePublisher
        onAppear()
    }
    
    deinit {
        unsubscribe()
    }

    private func onAppear() {
        removeAll()
        subscribe()
        getInfoAboutExistingCountries()
    }

    private func subscribe() {
        networkSubscriber = networkPublisher
            .subscribe(on: networkResponseQueue)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("🟢 NetworkService: Publisher finished.")
                case .failure(let error):
                    print("🔴 ERROR in NetworkService:\n\(error.localizedDescription)")
                }
            }, receiveValue: { value in
                if let genres = value as? [Genre] {
                    self.save(genres: genres)
                }
                if let popularMovieIds = value as? [Int] {
                    self.cleanUpStorageFromIrrelevantIdsOfPopularFilms(with: popularMovieIds)
                }
                
                if let movie = value as? Movie {
                    self.store(movie: movie)
                }
                
                if let country = value as? ProductionCountyDTO {
                    self.store(country: country)
                }
                
                if let coversResponse = value as? CoversDownloadResponse {
                    self.save(coversResponse: coversResponse)
                }
            })
    }
    
    private func unsubscribe() {
        
    }
    
    private func removeAll() {
        //dataStorageQueue.async(flags: .barrier) {
            ["GenreItem", "MovieItem", "CollectionItem", "PosterItem", "BackdropItem", "ProductionCountryItem", "ProductionCompanyItem", "SpokenLanguageItem"].forEach {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: $0)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    try self.context.execute(deleteRequest)
                    print("🧹 DataStorageService: Remove all \($0) from DB complete.")
                } catch {
                    print("🧹🔴 DataStorageService: Remove all \($0) from DB error\n\(error.localizedDescription).")
                }
            }
        //}
    }
    
    func saveContext() {
        context.perform {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: Genres
    private func save(genres: [Genre]) {

        let entityName = "GenreItem"
        
        let genresFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let existingGenres = try! self.context.fetch(genresFetchRequest) as! [GenreItem]
        if existingGenres.count != genres.count {
            for genre in genres {
                guard let id = genre.id, let name = genre.name else { continue }
                
                self.context.perform {
                    let newGenre = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! GenreItem
                    
                    newGenre.id = Int32(id)
                    newGenre.name = name
                    
                    do {
                        try self.context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            print("💾 Info of Genres updated in DB.")
        }
    }
    
    private func fetchGernes(byIds ids: [Int]?) -> NSSet? {
        guard let ids = ids else { return nil }
        
        let entityName = "GenreItem"
        
        let genresFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        genresFetchRequest.predicate =  NSPredicate(format: "id IN %@", ids)
        let fetchingGenres = try! self.context.fetch(genresFetchRequest) as! [GenreItem]

        return NSSet(objects: fetchingGenres)
    }
    
    // MARK: Movies
    private func cleanUpStorageFromIrrelevantIdsOfPopularFilms(with actuslIds: [Int]) {
        let entityName = "MovieItem"
            let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            movieFetchRequest.predicate =  NSPredicate(format: "NOT (id IN %@)", actuslIds)
            let irrelevantMovies = try! self.context.fetch(movieFetchRequest) as! [MovieItem]
            
            if irrelevantMovies.count > 0 {
                for movie in irrelevantMovies {
                    //dataStorageQueue.async(flags: .barrier) {
                    self.context.perform {
                        self.context.delete(movie)
                    }
                    self.saveContext()
                    //}
                }
                print("💾 Database has been cleared of irrelevant popular movie ids.")
            } else {
                print("💾 There are no popular movie ids in database.")
            }
    }
    
    private func store(movie: Movie) {
        
        guard let id = movie.id, let title = movie.title else { return }
        
            let entityName = "MovieItem"
        
        self.context.perform {
            let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            movieFetchRequest.predicate =  NSPredicate(format: "title == %@", title)
            
            let existingMovies = try! self.context.fetch(movieFetchRequest) as! [MovieItem]
            
            if let existingMovie = existingMovies.first {
                if let popularity = movie.popularity {existingMovie.popularity = popularity}
                if let revenue = movie.revenue {existingMovie.revenue = Int32(revenue)}
                if let runtime = movie.runtime {existingMovie.runtime = Int32(runtime)}
                if let status = movie.status?.rawValue {existingMovie.status = status}
                if let tagline = movie.tagline {existingMovie.tagline = tagline}
                if let voteAverage = movie.voteAverage {existingMovie.voteAverage = voteAverage}
                if let voteCount = movie.voteCount {existingMovie.voteCount = Int32(voteCount)}

                do {
                    try self.context.save()
                    print("💾 Movie with id '\(id)' updated in DB.")
                } catch {
                    print(error.localizedDescription)
                }
 
                self.checkPosterAndBackdropAvailability(posterPath: movie.posterPath, backdropPath: movie.backdropPath, movieItem: existingMovie)
            } else {
                self.save(movie: movie)
            }
        }
  
    }
    
    private func save(movie: Movie)  {
        
        let entityName = "MovieItem"
        
        self.context.perform {
            
            let newMovie = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! MovieItem
            
            if let collection = movie.belongsToCollection,
               let collectionItem = self.save(collection: collection) {
                newMovie.collection = collectionItem
            }
            
            if let genres = movie.genres,
               let genreItems = self.fetchGernes(byIds: genres.compactMap{$0.id}) {
                newMovie.genres?.adding(genreItems)
            }
            
            if let companies = movie.productionCompanies,
               let companyItems = self.save(productionCompanies: companies) {
                newMovie.companies?.adding(companyItems)
            }
            
            if let countries = movie.productionCountries,
               let countriesItems = self.save(countries: countries) {
                newMovie.countries?.adding(countriesItems)
            }
            
            if let spokenLanguages = movie.spokenLanguages,
               let languagesItems = self.save(spokenLanguages: spokenLanguages) {
                newMovie.languages?.adding(languagesItems)
            }
            
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
            
            do {
                try self.context.save()
                print("💾 Movie with id '\(movie.id ?? 0)' saved in DB.")
            } catch {
                print(error.localizedDescription)
            }
            
            self.checkPosterAndBackdropAvailability(posterPath: movie.posterPath, backdropPath: movie.backdropPath, movieItem: newMovie)
        }
    }
    
    private func fetchMovie(byId id: Int32) -> MovieItem? {
        let entityName = "MovieItem"
        let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        movieFetchRequest.predicate =  NSPredicate(format: "id == %i", id)
        let existingMovies = try! self.context.fetch(movieFetchRequest) as! [MovieItem]
        return existingMovies.first
    }
    
    // MARK: Collection
    private func save(collection: MovieBelongsToCollection) -> CollectionItem? {
        
        guard let id = collection.id else { return nil }
 
        let entityName = "CollectionItem"
        let collectionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        collectionFetchRequest.predicate = NSPredicate(format: "%K == %i", "id", id)
        let fetchItems = try! self.context.fetch(collectionFetchRequest) as! [CollectionItem]
        
        if let existingCollectionItem = fetchItems.first {
            return existingCollectionItem
        } else {

            let newCollectionItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! CollectionItem
            
            if let collectionid = collection.id { newCollectionItem.id = Int32(collectionid) }
            if let collectionName = collection.name { newCollectionItem.name = collectionName }
            if let posterPath = collection.posterPath { newCollectionItem.posterPath = posterPath }
            if let backdropPath = collection.backdropPath { newCollectionItem.backdropPath = backdropPath }
            
            do {
                try self.context.save()
                print("💾 Collection with id '\(collection.id ?? 0)' saved in DB.")
                return newCollectionItem
            } catch {
                print(error.localizedDescription)
                return nil
            }

            
        }
        // TODO: Запрос на загрузку картинок для коллекции
    }
    
    // MARK: Producrion Company
    private func save(productionCompanies: [ProductionCompany]) -> NSSet? {
        
        let entityName = "ProductionCompanyItem"
        var results: [ProductionCompanyItem] = .init()
        
        for company in productionCompanies {
            guard let companyId = company.id, let name = company.name else { continue }
            
            let companyFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            companyFetchRequest.predicate = NSPredicate(format: "name == %@", name)
            let existingCompanies = try! context.fetch(companyFetchRequest) as! [ProductionCompanyItem]
            
            if let existingCompany = existingCompanies.first {
                results.append(existingCompany)
            } else {
                let newCompany = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ProductionCompanyItem
                
                newCompany.id = Int32(companyId)
                newCompany.name = name
                
                if let logoPath = newCompany.logoPath {newCompany.logoPath = logoPath}
                if let originCountry = newCompany.originCountry { newCompany.originCountry = originCountry}
                
                do {
                    try self.context.save()
                    print("💾 Production company '\(name)' saved in DB.")
                    results.append(newCompany)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return NSSet(objects: results)
    }
    
    // MARK: Production Country
    private func getInfoAboutExistingCountries() {
        let entityName = "ProductionCountryItem"
        
        self.context.perform {
            let countriesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let existingCountries = try! self.context.fetch(countriesFetchRequest) as! [ProductionCountryItem]
            
            if existingCountries.count > 0 {
                var existingCountriesDTO: [ProductionCountyDTO] = .init()
                
                for country in existingCountries {
                    guard let countryName = country.name, let countrytTag = country.iso31661 else { continue }
                    
                    existingCountriesDTO.append(ProductionCountyDTO(tag: countrytTag, name: countryName, coordinate: CLLocationCoordinate2D(latitude: country.latitude, longitude: country.longitude)))
                }
                DispatchQueue.global(qos: .utility).async {
                    self.dataStoragePublisher.publish(request: .getCoordinates(existingCountriesDTO))
                }
            }
        }
    }
    
    private func store(country: ProductionCountyDTO) {
        let entityName = "ProductionCountryItem"
        
        self.context.perform {
            let countryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            countryFetchRequest.predicate = NSPredicate(format: "iso31661 == %@", country.tag)
            let existingCountries = try! self.context.fetch(countryFetchRequest) as? [ProductionCountryItem]
            
            if existingCountries != nil, let existingCountry = existingCountries!.first {
                
                existingCountry.name = country.name
                existingCountry.iso31661 = country.tag
                
                if let coordinate = country.coordinate {
                    existingCountry.latitude = coordinate.latitude
                    existingCountry.longitude = coordinate.longitude
                }
                
                do {
                    try self.context.save()
                    print("💾 Country with tag '\(existingCountry.iso31661 ?? "?")' updated in DB.")
                } catch {
                    print(error.localizedDescription)
                }
                
            } else {
                let newCountry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! ProductionCountryItem
                
                newCountry.name = country.name
                newCountry.iso31661 = country.tag
                
                if let coordinate = country.coordinate {
                    newCountry.latitude = coordinate.latitude
                    newCountry.longitude = coordinate.longitude
                }
                
                do {
                    try self.context.save()
                    print("💾 Country with tag '\(newCountry.iso31661 ?? "?")' saved in DB.")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func save(countries: [ProductionCountry]) -> NSSet? {
        
        let entityName = "ProductionCountryItem"
        var results: [ProductionCountryItem] = .init()
        
        for country in countries {
            guard let name = country.name else { continue }
            
            let countryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            countryFetchRequest.predicate = NSPredicate(format: "id == %@ AND name == %i",  country.id as CVarArg, name)
            let existingCounties = try! context.fetch(countryFetchRequest) as! [ProductionCountryItem]
            
            if let existingCountry = existingCounties.first {
                results.append(existingCountry)
            } else {
                let newCountry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ProductionCountryItem
                
                newCountry.id = country.id
                newCountry.name = name
                newCountry.iso31661 = country.iso31661
                
                do {
                    try self.context.save()
                    print("💾 Country with tag '\(newCountry.iso31661 ?? "?")' saved in DB.")
                    results.append(newCountry)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return NSSet(objects: results)
    }
    
    // MARK: SpokenLanguage
    private func save(spokenLanguages: [SpokenLanguage]) -> NSSet? {
        
        let entityName = "SpokenLanguageItem"
        var results: [SpokenLanguageItem] = .init()
        
        for language in spokenLanguages {
            guard let name = language.name else { continue }
            
            let languageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            languageFetchRequest.predicate = NSPredicate(format: "name == %@", name)
            let existingLanguages = try! context.fetch(languageFetchRequest) as! [SpokenLanguageItem]
            
            if let existingLanguage = existingLanguages.first {
                results.append(existingLanguage)
            } else {
                let newLanguage = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! SpokenLanguageItem
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
        
        return NSSet(objects: results)
    }
    
    // MARK: Poster && Backdrop
    private func checkPosterAndBackdropAvailability(posterPath: String?, backdropPath: String?, movieItem: MovieItem) {
        
        let posterEntityName = "PosterItem"
        let backdropEntityName = "BackdropItem"
        
        var existingCoversDownloadRequest: CoversDownloadRequest?
        
        requestForPoster:
        if let posterPath = posterPath {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: posterEntityName)
            request.predicate = NSPredicate(format: "movie = %@", movieItem)
            let fetchExistingPosters = try! context.fetch(request) as? [PosterItem]
            
            if fetchExistingPosters?.first != nil {
                break requestForPoster
            } else {
                existingCoversDownloadRequest = CoversDownloadRequest(movieItemId: movieItem.id, posterPath: posterPath, backdropPath: nil)
            }
        }
        
        requestForBackdrop:
        if let backdropPath = backdropPath {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: backdropEntityName)
            request.predicate = NSPredicate(format: "movie = %@", movieItem)
            let fetchExistingBackdrops = try! context.fetch(request) as? [BackdropItem]
            
            if fetchExistingBackdrops?.first != nil {
                break requestForBackdrop
            } else {
                if var coversDownloadRequest = existingCoversDownloadRequest {
                    coversDownloadRequest.backdropPath = backdropPath
                } else {
                    existingCoversDownloadRequest = CoversDownloadRequest(movieItemId: movieItem.id, posterPath: nil, backdropPath: backdropPath)
                }
            }
            
            if existingCoversDownloadRequest != nil {
                DispatchQueue.global(qos: .utility).async {
                    self.dataStoragePublisher.publish(request: .getCovers(existingCoversDownloadRequest!))
                }
            }
        }
    }
    
    private func save(coversResponse: CoversDownloadResponse) {

        self.context.perform {
            guard let movieItem = self.fetchMovie(byId: coversResponse.movieItemId) else {
                print("No fetch movieItem"); return
            }
            
            if let posterBlobData = coversResponse.posterBlobData, posterBlobData.count > 0 {

                let entityName = "PosterItem"
                let newPosterItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! PosterItem
                
                newPosterItem.blob = posterBlobData
                movieItem.poster = newPosterItem
                
                do {
                    try self.context.save()
                    print("💾 Save poster to movie with id '\(movieItem.id)' in DB.")
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            if let backdropBlobData = coversResponse.backdropBlobData, backdropBlobData.count > 0 {
                let entityName = "BackdropItem"
                let newBackdropItem = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! BackdropItem
                
                newBackdropItem.blob = backdropBlobData
                movieItem.backdrop = newBackdropItem
                
                do {
                    try self.context.save()
                    print("💾 Save backdrop to movie with id '\(movieItem.id)' in DB.")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        
       

       
    }
}

struct ProductionCountyDTO {
    var tag: String
    var name: String
    var coordinate: CLLocationCoordinate2D?
}

struct CoversDownloadRequest {
    let movieItemId: Int32
    var posterPath: String?
    var backdropPath: String?
}

struct CoversDownloadResponse {
    let movieItemId: Int32
    let posterBlobData: Data?
    let backdropBlobData: Data?
}

enum PosterSizes {
    case w92, w154, w185, w342, w500, w780, original
}


class DataStoragePublisher {

    var requestPublisher: AnyPublisher<DataStorageRequest, Never> {
        self.subject.eraseToAnyPublisher()
    }
    private var subject = PassthroughSubject<DataStorageRequest, Never>()
    private(set) var request: DataStorageRequest? {
        didSet {
            if let request = request {
                subject.send(request)
            }
        }
    }
    func publish(request: DataStorageRequest) {
        self.request = request
    }
    
}

enum DataStorageRequest {
    case startUpdatingData
    case completionUpdatingData
    case getCoordinates([ProductionCountyDTO])
    case getCovers(CoversDownloadRequest)
}
