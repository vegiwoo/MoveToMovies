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
}
