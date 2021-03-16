//
//  DataStorageService.swift
//  Created by Dmitry Samartcev on 16.03.2021.
//

import Foundation
import CoreData
import Combine
import TmdbAPI

public protocol DataStorageService {
//    var networkServiceResponseQueue: DispatchQueue { get }
//    @available(iOS 13.0, *)
//    var networkServicePublisher: PassthroughSubject<Any, Error> { get }
}

@available(iOS 13.0, *)
public final class DataStorageServiceImpl: DataStorageService {
    
    private var networkServiceResponseQueue: DispatchQueue
    private var networkServicePublisher: PassthroughSubject<Any, Error>
    private var networkServiceSubscriber: AnyCancellable?
    private var context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext, networkServiceResponseQueue: DispatchQueue,networkServicePublisher: PassthroughSubject<Any, Error>) {
        self.context = context
        self.networkServiceResponseQueue = networkServiceResponseQueue
        self.networkServicePublisher = networkServicePublisher
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }
    
    func subscribe() {
        networkServiceSubscriber = networkServicePublisher
            .subscribe(on: networkServiceResponseQueue)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("🟢 NetworkService Publisher finished.")
            case .failure(let error):
                print("🔴 ERROR:\(error.localizedDescription)")
            }
        }, receiveValue: { value in
            if let genres = value as? [Genre] {
                print(genres.count)
            }
            
            // [MovieListResultObject]
        })
    }
    
    func unsubscribe() {
        networkServiceSubscriber?.cancel()
    }
}
