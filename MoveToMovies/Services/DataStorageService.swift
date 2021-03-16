//
//  DataStorageService.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 16.03.2021.
//

import Foundation
import CoreData
import Combine
import TmdbAPI

protocol DataStorageService {
    var context: NSManagedObjectContext { get }
    var networkResponseQueue: DispatchQueue { get set}
    var networkPublisher: PassthroughSubject<Any, Error> { get set }
    var networkSubscriber: AnyCancellable? { get }
    func saveContext()
}

final class DataStorageServiceImpl: DataStorageService {
    var networkResponseQueue: DispatchQueue
    var networkPublisher: PassthroughSubject<Any, Error>
    var networkSubscriber: AnyCancellable?
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
   
    init(networkResponseQueue: DispatchQueue, networkPublisher: PassthroughSubject<Any, Error>) {
        self.networkResponseQueue = networkResponseQueue
        self.networkPublisher = networkPublisher
        onAppear()
    }
    
    deinit {
        unsubscribe()
    }
    
    private func onAppear() {
        subscribe()
    }
    
    private func subscribe() {
        networkSubscriber = networkPublisher
            .subscribe(on: networkResponseQueue)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("🟢 NetworkService Publisher finished.")
            case .failure(let error):
                print("🔴 ERROR:\(error.localizedDescription)")
            }
        }, receiveValue: { value in
            if let genres = value as? [Genre] {
                self.save(genres: genres)
            }
            // [MovieListResultObject]
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
    
    private func save(genres: [Genre]) {
        
        let entityName = "GenreItem"
        
        var count = 1
        
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
                    print("save", count)
                    count += 1
                }
            }
        }
    }
    
}
