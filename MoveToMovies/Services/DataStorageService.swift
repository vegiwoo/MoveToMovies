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
    var dataStorePublisher: PassthroughSubject<Any, Never> { get }
    func saveContext()
}

final class DataStorageServiceImpl: DataStorageService {
   
    var networkResponseQueue: DispatchQueue
    var networkPublisher: PassthroughSubject<Any, Never>
    var networkSubscriber: AnyCancellable?
    var dataStorePublisher: PassthroughSubject<Any, Never>
    let dataStorageQueue: DispatchQueue = .init(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).dataStorageQueue" : "dataStorageQueue", qos: .utility)
    
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "MoveToMoviesModel")
        let persistentStoreDescriptions = NSPersistentStoreDescription()
        persistentStoreDescriptions.shouldMigrateStoreAutomatically = true
        persistentStoreDescriptions.shouldInferMappingModelAutomatically = true
        
        var context: NSManagedObjectContext = .init(concurrencyType: .mainQueueConcurrencyType)
       
        container.loadPersistentStores { (storeDescription, error)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            context = container.viewContext
            print("🟢 Core Data stack has been initialized with description:\n \(storeDescription)")
        }
        
        return context
    }()
   
    init(networkResponseQueue: DispatchQueue, networkPublisher: PassthroughSubject<Any, Never>, dataStorePublisher: PassthroughSubject<Any, Never> ) {
        self.networkResponseQueue = networkResponseQueue
        self.networkPublisher = networkPublisher
        self.dataStorePublisher = dataStorePublisher
        onAppear()
    }
    
    deinit {
        unsubscribe()
    }
    
    private func onAppear() {
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
                // Save movie items
            }

            
            if let country = value as? ProductionCountyDTO {
                self.save(country: country)
            }
        })
    }
    
    private func unsubscribe() {
        
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    // MARK: Countries
    private func getInfoAboutExistingCountries() {
        let entityName = "ProductionCountryItem"
        dataStorageQueue.async(flags: .barrier) {
            let countriesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let existingCountries = try! self.context.fetch(countriesFetchRequest) as! [ProductionCountryItem]
            
            if existingCountries.count > 0 {
                var existingCountriesDTO: [ProductionCountyDTO] = .init()
                
                for country in existingCountries {
                    guard let countryName = country.name, let countrytTag = country.iso31661 else { continue }
                    
                    existingCountriesDTO.append(ProductionCountyDTO(tag: countrytTag, name: countryName, coordinate: CLLocationCoordinate2D(latitude: country.latitude, longitude: country.longitude)))
                }
      
                DispatchQueue.global(qos: .utility).async {
                    self.dataStorePublisher.send(existingCountriesDTO)
                }
            }
        }
    }
    
    private func save(country: ProductionCountyDTO) {
        let entityName = "ProductionCountryItem"
        dataStorageQueue.async(flags: .barrier) {
        
                let countryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                countryFetchRequest.predicate = NSPredicate(format: "iso31661 == %@", country.tag)
                let existingCountries = try! self.context.fetch(countryFetchRequest) as! [ProductionCountryItem]
                
                if let existingCountry = existingCountries.first {
                    
                    existingCountry.name = country.name
                    existingCountry.iso31661 = country.tag
                    
                    if let coordinate = country.coordinate {
                        existingCountry.latitude = coordinate.latitude
                        existingCountry.longitude = coordinate.longitude
                    }
                    
                    self.saveContext()
                    print("🟢 DataStorageService: Update coutry info: \(existingCountry.iso31661 ?? "")")
                } else {
                    let newCountry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.context) as! ProductionCountryItem
                    
                    newCountry.name = country.name
                    newCountry.iso31661 = country.tag
                    
                    if let coordinate = country.coordinate {
                        newCountry.latitude = coordinate.latitude
                        newCountry.longitude = coordinate.longitude
                    }
                    
                    self.saveContext()
                    print("🟢 DataStorageService: Save coutry info: \(newCountry.iso31661 ?? "")")
                }
        }
    }
    
    // MARK: Genres
    private func save(genres: [Genre]) {
        let entityName = "GenreItem"
        dataStorageQueue.async(flags: .barrier) {
            let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let existingGenres = try! self.context.fetch(movieFetchRequest) as! [GenreItem]
            if existingGenres.count != genres.count {
                for genre in genres {
                    
                    guard let id = genre.id, let name = genre.name else {
                        continue
                    }
                    
                    let newGenre = NSEntityDescription.insertNewObject(forEntityName: "GenreItem", into: self.context) as! GenreItem
                    newGenre.id = Int32(id)
                    newGenre.name = name
                    
                    self.saveContext()
                }
                print("💾 Genres saved in database.")
            } else {
                print("💾 Genres updated in database.")
            }
        }
    }

    private func cleanUpStorageFromIrrelevantIdsOfPopularFilms(with actuslIds: [Int]) {
        let entityName = "MovieItem"
        dataStorageQueue.async(flags: .barrier) {
            let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            movieFetchRequest.predicate =  NSPredicate(format: "NOT (id IN %@)", actuslIds)
            let irrelevantMovies = try! self.context.fetch(movieFetchRequest) as! [MovieItem]
            
            if irrelevantMovies.count > 0 {
                for movie in irrelevantMovies {
                    self.context.delete(movie)
                    self.saveContext()
                }
                print("💾 Database has been cleared of irrelevant popular movie ids.")
            } else {
                print("💾 There are no popular movie ids in database.")
            }
        }
    }
}

struct ProductionCountyDTO {
    var tag: String
    var name: String
    var coordinate: CLLocationCoordinate2D?
}
