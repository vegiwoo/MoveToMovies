//
//  AppState.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 05.03.2021.
//

import SwiftUI
import CoreData
import TmdbAPI
import Networking
import DataStorage

final class AppState: ObservableObject {
    // Network
    static var networkServiceRequestQueue: DispatchQueue = createNetworkServiceRequestQueue()
    static var networkService: NetworkServiceImpl = createNetworkService()
    // Data store
    var dataStorageService: DataStorageServiceImpl?

    @Published var selectTabIndex: Int = TabbarTab.dashboardScreen.rawValue  {
        didSet {
            selectedTabHandler()
        }
    }
    @Published var appViewModel: AppViewModel = .init()
    @Published var isQuickLink: Bool = false {
        didSet {
            //selectionTab = .popularMoviesScreen
            randomMovie = isQuickLink == true ? appViewModel.getRandomMovie() : nil
        }
    }
    @Published var randomMovie: Movie?
    
    @Published var selectionScreen: AnyView = AnyView(DashBoardScreen(actualColor: TabbarTab.dashboardScreen.actualColor, title: TabbarTab.dashboardScreen.text))
    
    private func selectedTabHandler() {
        if let selectedTab = TabbarTab.allCases.first(where: {$0.rawValue == selectTabIndex}) {
            switch selectedTab {
            case .dashboardScreen:
                selectionScreen = AnyView(DashBoardScreen(
                                            actualColor: selectedTab.actualColor,
                                            title: selectedTab.text)
                                            .environment(\.managedObjectContext, AppState.context))
            case .movies:
                selectionScreen = AnyView(MovieSearchScreen(
                                            actualColor: selectedTab.actualColor,
                                            title: selectedTab.text)
                                            .environment(\.managedObjectContext, AppState.context))
            case .aboutUSScreen:
                selectionScreen = AnyView(AboutUsScreen())
            }
        }
    }
    
    static var context: NSManagedObjectContext = createContext()
    
    private static func createNetworkServiceRequestQueue() -> DispatchQueue {
        return DispatchQueue(label: Bundle.main.bundleIdentifier != nil ? "\(Bundle.main.bundleIdentifier!).networkServiceRequestQueue" : "networkServiceRequestQueue", qos: .utility)
    }

    private static func createNetworkService() -> NetworkServiceImpl {
        return NetworkServiceImpl(tmdbApiKey: API.tmdbApiKey.description, networkServiceResponseQueue: AppState.networkServiceRequestQueue)
    }
    
    private static func createContext() -> NSManagedObjectContext {
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

    }
    
    
    private static func createDataStorageService() -> DataStorageServiceImpl {
        
        
        return DataStorageServiceImpl(context: AppState.context, networkServiceResponseQueue: networkServiceRequestQueue, networkServicePublisher: AppState.networkService.networkServicePublisher)
    }

    func saveContext() {
        if AppState.context.hasChanges {
            do {
                try AppState.context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }

}
